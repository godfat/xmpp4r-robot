
require 'set'
require 'thread'

require 'xmpp4r'
require 'xmpp4r/roster'

class Jabber::Robot
  attr_accessor :username, :password, :client, :errback,
                :retry_time, :auto_accept_subscription

  def initialize username, password, opts={}, &errback
    @username = username
    @password = password
    @errback  = errback
    @roster   = {:available   => Set.new,
                 :away        => Set.new,
                 :unavailable => Set.new}

    @retry_time               = Float(opts[:retry_time] || 0)
    @auto_accept_subscription = opts[:auto_accept_subscription]

    @roster_mutex = Mutex.new
    @helper_mutex = Mutex.new
    @client = nil # eliminate warning
  end

  def inspect
    "#<#{self.class.name} username=#{username.inspect}>"
  end

  def client
    @client ||= Jabber::Client.new(Jabber::JID::new(username))
  end

  def helper
    @helper ||= Jabber::Roster::Helper.new(client, false)
  end

  # Start the robot. This is not thread safe.
  #
  # @api public
  def start
    if @client # restart
      stop
      @client = nil
    end
    initialize_callbacks
    connect
    login
    available
    roster
    self
  end

  def stop
    client.close
    self
  end

  def connect
    client.connect
    self
  end

  def login
    client.auth(password)
    self
  end

  ##### getters #####

  def roster sync=false
    sync_roster if sync || @roster[:unknown].nil?
    @roster_mutex.synchronize{ @roster }
  end

  ##### actions #####

  def available
    client.send(Jabber::Presence.new.set_type(:available))
  end

  # e.g. robot.message('someone@example.com', 'Hi!')
  def message to_jid, body
    client.send(Jabber::Message::new(to_jid, body).set_type(:chat))
  end

  # e.g. robot.subscribe('someone@example.com')
  def subscribe to_jid
    client.send(Jabber::Presence.new.set_type(:subscribe).set_to(to_jid))
  end

  ##### callbacks #####

  # e.g. robot.notify_presence{ |from, status| puts "#{from} is #{status}" }
  # The status could be one of :available, :away, :unavailable
  def notify_presence
    client.add_presence_callback do |presence|
      status = presence.type ||
                 case presence.show # http://xmpp.org/rfcs/rfc3921.html
                 when nil, :chat
                   :available
                 when :away, :dnd, :xa
                   :away
                 else
                   raise "What's this show? #{presence.show}"
                 end

      protect_yield do
        yield(jid_to_username(presence.from), status)
        false
      end
    end
  end

  # e.g. robot.notify_message{ |from, body| puts "#{from}: #{body}" }
  def notify_message
    client.add_message_callback do |message|
      protect_yield do
        if message.body
          yield(jid_to_username(message.from), message.body.strip)
        end
        false
      end
    end
  end

  ##### private #####

  private
  def initialize_callbacks
    client.on_exception do |exp|
      errback.call(exp) if errback

      next if retry_time == 0.0

      $stderr.puts "ERROR: #{exp}: #{exp.backtrace}" +
                   " We'll sleep for #{retry_time} seconds and retry."
      sleep(retry_time)
      start
    end

    client.add_presence_callback do |presence|
      if auto_accept_subscription && presence.type == :subscribe
        subscribe(presence.from)
      end
      false
    end

    notify_presence do |jid, status|
      @roster_mutex.synchronize do
        @roster[:unknown].delete(jid) if @roster[:unknown]

        [:available, :away, :unavailable].each do |type|
          if type == status
            @roster[type].add(jid)
          else
            @roster[type].delete(jid)
          end
        end
      end
    end
  end

  def jid_to_username jid
    "#{jid.node}@#{jid.domain}"
  end

  def protect_yield
    yield
  rescue => e
    errback.call(e) if errback
  end

  def sync_roster
    @helper_mutex.synchronize do
      clear_roster_semaphore
      helper.get_roster
      helper.wait_for_roster
    end
    @roster_mutex.synchronize do
      @roster[:unknown] =
        Set.new(helper.items.keys.map(&method(:jid_to_username))) -
        @roster[:available] - @roster[:away] - @roster[:unavailable]
    end
  end

  # a hack to let us always get the latest roster
  def clear_roster_semaphore
    helper.instance_variable_get(:@roster_wait).
           instance_variable_set(:@tickets, 0)
  end
end
