require 'socket'

server = TCPServer.new 25566

loop do
	client = server.accept
	while line = client.gets
		puts line
	end
end
