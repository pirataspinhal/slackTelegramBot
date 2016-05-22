require 'socket'

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
@server = TCPServer.new 25566
def listen_loop(&block)
	puts "---- Thread: inside listen loop"
	loop do
		puts "---- Thread: inside listen once"

		puts "---- Thread: Waiting for connection"
		Thread.new(@server.accept) do |client|
			puts "------ Thread: Connected"

			data = ''
			while text = client.gets
				data << text
			end
			puts "------ Thread: Read data"

			params = get_params(data)
			puts "------ Thread: Got params"

			client.close

			yield params if block_given?

		end
	end
end

stack = []
Thread.new do
	puts "thread running"
	listen_loop do |params|
		puts "---- Thread: Got message, pushing"
		stack.push params
	end
end

running = true
Signal.trap("INT") { puts "Interrupting... "; running = false }

while running
	puts "running"
	if stack.empty?
		puts "found empty stack, sleeping"
		sleep(10)
	else
		params = stack.shift
		puts "found params\n#{params.inspect}"
	end
end
