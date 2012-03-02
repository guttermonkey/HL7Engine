require 'rubygems'
require 'ruby-hl7'
require 'thread'
require 'socket'

incoming_port = 2402
outgoing_ip = '127.0.0.1'
outgoing_port = 5900

proxy_server = TCPServer.new(incoming_port)
puts "HL7 proxy server listening on port: #{incoming_port}"
puts "Sending HL7 to server: #{outgoing_ip}:#{outgoing_port}"

while true
	incoming_socket = proxy_server.accept
	Thread.new( incoming_socket ) do |my_socket|
		raw_input = my_socket.readlines
		message = HL7::Message.new( raw_input )
		puts "forwarding message:\n#{message.to_s}"
		outgoing_socket = TCPSocket.open( outgoing_ip, ougoing_port )
		outgoing_socket.write message.to_mllp
		outgoing_socket.close
	end
end