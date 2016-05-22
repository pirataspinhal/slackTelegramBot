require File.expand_path './server'

class SlackBot

	attr_accessor :stack, :slack
	def initialize(port)
		@slack = SlackWebhookListener.new port
		@stack = []
	end

	def start_listening
		slack.listen_loop_nonblock(stack)
	end

	def cycle
		return if stack.empty?
		puts "got update from slack!"
		params = stack.shift
		yield params
	end

end
