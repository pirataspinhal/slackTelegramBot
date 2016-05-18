require 'telegram/bot'
require File.expand_path './server'

module CONST

	Token = ENV['bot_token']
	Chat = 41487359;

end

server = Server.new 25566

server.listen do |params|



	Telegram::Bot::Client.run(CONST::Token) do |bot|
		bot.api.send_message(chat_id: CONST::Chat, text: "#{params['user_name']}: #{params['text']}")
	end

end
