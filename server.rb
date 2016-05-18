require 'socket'

class Server
	attr_accessor :server
	def initialize(port)
		puts 'initializing server'
		self.server = TCPServer.new port
	end

	def listen(&block)
		loop do

			puts 'waiting for a connection...'
			client = self.server.accept
			puts 'got a request!'

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

			puts "got message"
			puts params.inspect

			block.call(params)

		end
	end
end
