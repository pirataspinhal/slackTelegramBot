require 'socket'

class SlackWebhookListener

	attr_accessor :server

	def initialize(port)
		self.server = TCPServer.new port
	end

	def get_params(data, arr_sep = '&', hash_sep = '=')
		cap = /(token=.*)/.match(data).captures.first
		cap = cap.split(arr_sep)
		params = {}
		cap.each do |arr_entry|
			arr_entry.chomp!
			hash_entry = arr_entry.split(hash_sep)
			params[hash_entry.first.to_sym] = hash_entry.last
		end
		params
	end

	def listen_once(&block)
			client = self.server.accept

			data = ''
			while text = client.gets
				data << text
			end

			params = get_params(data)

			client.close

			block.call(params)
	end

	def listen_loop(&block)
		loop do
			listen_once(block)
		end
	end
end
