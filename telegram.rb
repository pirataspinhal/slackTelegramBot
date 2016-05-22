require 'telegram/bot'

class TelegramBot
	attr_reader :bot
	def initialize(token, options)
		@bot = Telegram::Bot::Client.new(token, options)
	end

	def cycle
		bot.fetch_updates do |message|
			case message
			when Telegram::Bot::Client
			end
			puts "got message from #{message.from.username}: #{message.text}"
			bot.api.send_message(chat_id: message.chat.id, text: "echo #{message.text}")
		end
	end
end
