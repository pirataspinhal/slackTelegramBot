require 'socket'

server = TCPServer.new 25566

loop do

	client = server.accept

	data = ''
	while text = client.gets
		data << text
	end

	cap = /(token=.*)/.match(data).captures.first
	cap = cap.split('&')
	params = {}
	cap.each do |entry|
		entry.chomp!
		e = entry.split('=')
		params[e[0].to_sym] = e[1]
	end

	puts params.inspect

	puts "#{params[:user_name]}: #{params[:text]}"


	puts '---------------------------'

end
