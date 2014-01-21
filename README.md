# xmpp4r-robot [![Build Status](https://secure.travis-ci.org/godfat/xmpp4r-robot.png?branch=master)](http://travis-ci.org/godfat/xmpp4r-robot)

by Lin Jen-Shin ([godfat](http://godfat.org))

## LINKS:

* [github](https://github.com/godfat/xmpp4r-robot)
* [rubygems](https://rubygems.org/gems/xmpp4r-robot)
* [rdoc](http://rdoc.info/github/godfat/xmpp4r-robot)

## DESCRIPTION:

Simple XMPP client built upon xmpp4r. Intended for building simple robots.

## WHY?

XMPP is such a beast and therefore xmpp4r is quite complex and hard to use
for some simple scenario where we merely want to write some XMPP robots.
This is an attempt to make it easy for such use cases.

## REQUIREMENTS:

* Tested with MRI (official CRuby) 2.0.0, 2.1.0, Rubinius and JRuby.

## INSTALLATION:

    gem install xmpp4r-robot

## SYNOPSIS:

``` ruby
require 'xmpp4r/robot'

robot = Jabber::Robot.new('someone@gmail.com', 'awesome password',
                          :retry_time => 10,
                          :auto_accept_subscription => true)

robot.notify_presence do |from, reason|
  # reason could be one of :available, :away, :unavailable
  puts "#{from} is #{reason}"
end

robot.notify_message do |from, body|
  puts "#{from} said: #{body}"
  robot.message(from, "#{from} just told me: #{body}") # echo back

  robot.subscribe(from) if body == 'subscribe' # demonstrate how we subscribe
end

robot.start

rd, wr = IO.pipe
Signal.trap('INT'){ wr.puts
rd.gets

robot.stop
```

## NOTES:

* If you want to login with a Google Apps Google Talk account, for example,
  suppose your domain is `example.com`, and your account is `robot`, then
  you need to login as `robot@example.com` and make sure you have proper
  `SRV` records. Namely `_xmpp-server._tcp.example.com.` and
  `_xmpp-client._tcp.example.com.`. Checkout [Olark's SRV instructions][]
  and Google's manual for [enabling chats outside Google Apps][].

* You might also want to read the [RFC for XMPP][] occasionally. We would try
  hard to use the same terms from XMPP, so that it's less confusing.

[Olark's SRV instructions]: http://www.olark.com/gtalk/check_srv
[enabling chats outside Google Apps]: https://support.google.com/a/answer/34143?hl=en
[RFC for XMPP]: http://xmpp.org/rfcs/rfc3921.html

## CONTRIBUTORS:

* Lin Jen-Shin (@godfat)

## LICENSE:

Apache License 2.0

Copyright (c) 2014, Lin Jen-Shin (godfat)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
