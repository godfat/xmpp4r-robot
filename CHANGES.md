# CHANGES

## xmpp4r-robot 0.2.2 -- 2014-01-25

* Should also synchronize @roster.

## xmpp4r-robot 0.2.1 -- 2014-01-25

* Fixed retry_time bug.
* Made roster thread safe.

## xmpp4r-robot 0.2.0 -- 2014-01-23

* Jabber::Robot#start would now act as restart.
* Jabber::Robot#roster added which would return a list of roster,
  with the state of :available, :away, :unavailable, and :unknown.
* Now we never consume any events.

## xmpp4r-robot 0.1 -- 2014-01-22

* Birthday!
