
require 'xmpp4r'
require 'xmpp4r/roster'

class Jabber::Robot
  attr_accessor :username, :password, :client, :errback,
                :retry_time, :auto_accept_subscription

  def initialize username, password, opts={}, &errback
    @username = username
    @password = password
    @errback  = errback

    @retry_time               = Float(opts[:retry_time] || 0)
    @auto_accept_subscription = opts[:auto_accept_subscription]
  end

  def inspect
    "#<#{self.class.name} username=#{username.inspect}>"
  end

  def client
    @client ||= Jabber::Client.new(Jabber::JID::new(username))
  end

  def helper
    @helper ||= Jabber::Roster::Helper.new(client)
  end

  def start
    if @client # restart
      stop
      @client = nil
    end
    initialize_callbacks
    connect
    login
    available
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

  def roster
    helper.wait_for_roster
    helper.items
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

  # e.g. robot.notify_presence{ |from, reason| puts "#{from} is #{reason}" }
  def notify_presence
    client.add_presence_callback do |presence|
      # :available, :away, :unavailable
      show = presence.type ||
               case presence.show # http://xmpp.org/rfcs/rfc3921.html
               when nil, :chat
                 :available
               when :away, :dnd, :xa
                 :away
               else
                 raise "What's this show? #{presence.show}"
               end

      protect_yield do
        yield(jid_to_username(presence.from), show)
      end
    end
  end

  # e.g. robot.notify_message{ |from, body| puts "#{from}: #{body}" }
  def notify_message
    client.add_message_callback do |message|
      protect_yield do
        if message.body
          yield(jid_to_username(message.from), message.body.strip)
          true
        else
          false
        end
      end
    end
  end

  ##### private #####

  private
  def initialize_callbacks
    client.on_exception do |exp|
      errback.call(exp) if errback

      next unless retry_time == 0.0

      $stderr.puts "ERROR: #{exp}: #{exp.backtrace}" +
                   " We'll sleep for #{retry_time} seconds and retry."
      sleep(retry_time)
      start
    end

    client.add_presence_callback do |presence|
      if auto_accept_subscription && presence.type == :subscribe
        subscribe(presence.from)
        true
      else
        false
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
end
