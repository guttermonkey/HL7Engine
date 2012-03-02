# HL7 Engine
## Using ruby-hl7 (https://github.com/segfault/ruby-hl7)

Requirements:
* ruby-hl7 (https://github.com/segfault/ruby-hl7)
* thread
* socket

This is a project in progress that will open a proxy server to listen for HL7
messages using the ruby-hl7 library, copy data to a database & then forward the
message (unaltered for now) to another HL7 endpoint.

