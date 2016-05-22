require File.expand_path './slack'
require File.expand_path './telegram'

module CONST
	module Telegram
		Token = ENV['bot_token']
		Chat = 41487359;
		Registry_File = File.expand_path './registry.yml'
	end
	module Slack
		Port = 25567
	end
end

def start(port = CONST::Slack::Port)

	slack = SlackBot.new port
	telegram = TelegramBot.new(CONST::Telegram::Token, timeout: 1)

	running = true
	Signal.trap('INT') { running = false }

	slack.start_listening

	while running
		puts 'running telegram cycle'
		telegram.cycle
		puts 'running slack cycle'
		slack.cycle do |params|
			telegram.handle_slack_params params
		end
	end
end

start
