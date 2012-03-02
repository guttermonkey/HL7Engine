require 'rubygems'
require 'ruby-hl7'
require 'thread'
require 'socket'
require 'data_mapper'

###
# Set up
###

incoming_port = 2402
outgoing_ip = '127.0.0.1'
outgoing_port = 5900

# Display debug logs for DataMapper
DataMapper::Logger.new($stdout, :debug)

# Set up the DataMapper connection to a localhost Postgres server
# with a database name of hl7engine (change as appropriate)
DataMapper.setup(:default, 'postgres://user:password@localhost/hl7engine')

# Initialize a basic class to store the data with
class Message
	include DataMapper::Resource
	property :id, Serial
	property :raw_input, Text, :required => true
	property :created_at, DateTime
end

# Finalize the table and set to auto-upgrade whenever we change it
DataMapper.finalize.auto_upgrade!

###
# Application
###

# Set up the local listening server.  Log information to stdout
proxy_server = TCPServer.new(incoming_port)
puts "HL7 proxy server listening on port: #{incoming_port}"
puts "Sending HL7 to server: #{outgoing_ip}:#{outgoing_port}"

# Listen on the specified port and handle each incoming message
while true
	incoming_socket = proxy_server.accept
	Thread.new( incoming_socket ) do |my_socket|
		raw_input = my_socket.readlines
		
		# Add the raw message to the database
		m = Message.new
		m.raw_input = raw_input
		m.created_at = Time.now
		m.save
		
		# Create an HL7 message object
		message = HL7::Message.new( raw_input )

		# Forward it on
		puts "forwarding message:\n#{message.to_s}"
		outgoing_socket = TCPSocket.open( outgoing_ip, ougoing_port )
		outgoing_socket.write message.to_mllp
		outgoing_socket.close
	end
end