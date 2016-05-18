require 'socket'

server = TCPServer.new 2000

loop do
	client = server.accept
	while line = client.gets
		puts line
	end
end
