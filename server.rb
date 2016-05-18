require 'socket'

server = TCPServer.new 25566

loop do
	client = server.accept
	method, path = client.gets.split
	headers = {}
	while line = client.gets.split(' ', 2)
		break if line[0] = ''
		headers[line[0].chop] = line[1].strip
	end
	data = client.read(headers['Content-Length'].to_i)

	puts "Method: #{method}\n path: #{path}"

	puts data

	puts headers.inspect
end
