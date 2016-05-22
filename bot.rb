require 'telegram/bot'
require File.expand_path './server'

module CONST
	module Telegram
		Token = ENV['bot_token']
		Chat = 41487359;
	end
	module Slack
		Port = 25567
	end
end

def telegram_cycle(bot)
	bot.fetch_updates do |message|
		case message
		when Telegram::Bot::Client
		end
		puts "got message from #{message.from.username}: #{message.text}"
		bot.api.send_message(chat_id: message.chat.id, text: "echo #{message.text}")
	end
end

def slack_cycle(stack, bot)
	return if stack.empty?
	puts "got update from slack!"
	params = stack.shift
	bot.api.send_message(chat_id: CONST::Telegram::Chat, text: "#{params[:user_name]}: #{params[:text]}")
end

def start(port = CONST::Slack::Port)
	slack = SlackWebhookListener.new port

	bot = Telegram::Bot::Client.new(CONST::Telegram::Token, timeout: 1)

	running = true
	Signal.trap('INT') { running = false }

	stack = []
	slack.listen_loop_nonblock(stack)

	while running
		puts 'running telegram cycle'
		telegram_cycle bot
		puts 'running slack cycle'
		slack_cycle stack, bot
	end
end

start
