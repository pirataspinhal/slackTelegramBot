require 'socket'

server = TCPServer.new 25566

loop do
	client = server.accept
	header = client.recv(1024)
	puts "got header:\n#{header.to_s}"
	length = /Content-Length: (\d+)/.match.captures.first.to_i
	puts "got len: #{length}"
	data = client.recv(length.to_i)

	puts data.inspect
	puts data

	client.close

=begin
	client = server.accept
	line = ''
	while thisline = client.gets
		line << thisline
		line << '\n'
	end
	length = /Content-Length: (\d+)/.match(line)
	next unless length
	length = length.captures
	puts length.inspect
	length = length.first.to_i

	data = client.read(length)
	puts data.inspect
=end
end
