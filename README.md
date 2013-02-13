HL7 Listener
============
This is another abandoned project of mine in that I've since replaced it with my MongoHL7
project.  I'll leave this updated version of it here in case someone could benefit from
it someday.  All it does is open up a listener and wait for incoming HL7 messages.  When
it receives one it saves a copy of it to a local MySQL database and then forwards it on
to a destination, unaltered.