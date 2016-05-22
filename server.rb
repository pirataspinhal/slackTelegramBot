require 'socket'
require 'timeout'

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

	['_loop', '_once'].each do |lop|
		method_name = "listen#{lop}"
		define_method("#{method_name}_nonblock") do |stack|
			Thread.start do
				self.send(method_name) do |params|
					stack.push params
					yield params if block_given?
				end
			end
		end
	end

	def listen_once

		client = self.server.accept

		data = ''
		while text = client.gets
			data << text
		end

		params = get_params(data)

		client.close

		#block.call(params)
		yield params
	end

	def listen_loop(&block)
		loop do
			listen_once(&block)
		end
	end
end
