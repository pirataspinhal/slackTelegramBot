require 'telegram/bot'
require File.expand_path './server'

module CONST
	module Telegram
		Token = ENV['bot_token']
		Chat = 41487359;
	end
	module Slack
		Port = 25566
	end
end

def telegram_cycle(bot)
	bot.fetch_updates do |message|
		puts "got message from #{message.from.username}: #{message.text}"
		bot.api.send_message(chat_id: message.chat.id, text: "echo #{message.text}")
	end
end

def slack_cycle(slack, bot)
	slack.listen_once do |params|
		puts "got update from slack!"
		bot.api.send_message(chat_id: CONST::Telegram::Chat, text: "#{params[:user_name]}: #{params[:text]}")
	end
end

def start(port = CONST::Slack::Port)
	slack = SlackWebhookListener.new port

	bot = Telegram::Bot::Client.new(CONST::Telegram::Token, timeout: 1)

	running = true
	Signal.trap('INT') { running = false }
	while running
		telegram_cycle bot
		slack_cycle slack, bot
	end
end

=begin
	puts "will get updates"
	newbot.run do |bot|
		#bot.listen do |message|
		puts 'fetching first update'
		bot.fetch_updates do |message|
			puts "got message from #{message.from.username}: #{message.text}\n message:\n#{message.inspect}"
			bot.api.send_message(chat_id: message.chat.id, text: "Olar")
		end
		puts 'fetching second update'
		bot.fetch_updates do |message|
			puts "extra one to clear out"
			puts message.inspect
		end
	end
	puts "after that"
=end

start
