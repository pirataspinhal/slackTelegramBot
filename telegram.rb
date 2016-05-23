require 'telegram/bot'
require 'yaml'
require 'date'

class TelegramBot
	attr_reader :bot
	def initialize(token, options)
		@bot = Telegram::Bot::Client.new(token, options)
	end

	def cycle
		bot.fetch_updates do |message|
			case message
			when Telegram::Bot::Types::Message
				handle_message message
			end
		end
	end

	def reply(message, options)
		return if message.nil? && options[:chat_id].nil?
		opt = { chat_id: message.respond_to?('chat') ? message.chat.id : nil, text: '' }
		opt.merge! options

		bot.api.send_message(opt)
	end

	def handle_message(message)
		case message.text
		when '/start'
			reply message, text: "welcome"
		when /\/configure/
			slack = /\/configure (.+)/.match(message.text).captures
			slack = slack.first.split(' ').first
			if slack
				use_registry do |reg|
					reg[slack] = (reg[slack] || []) << message.chat.id
				end
				reply message, text: "Configured slack token '#{slack}' to be used in this chat"
			else
				reply message, text: "Usage: /configure <slack token>, for more information, use /help"
			end
		when /\/clear/
			deleted = true
			text = "This chat does not have any assigned slack tokens, for more informations, use /help"
			use_registry do |reg|
				reg.each do |tok, chats|
					chats.delete(message.chat.id) { deleted = false }
					text = "Successfully removed '#{tok}' from this chat" if deleted
				end
			end
			reply message, text: text
		end
	end

	def handle_slack_params(params)
		use_registry do |reg|
			tok = params[:token]
			if reg[tok]
				reg[tok].each do |chat|
					reply(nil, chat_id: chat, text: "got slack message in channel #{params[:channel_name]}\nat #{Time.at(params[:timestamp].to_i)}\n#{params[:user_name]}: #{params[:text].gsub('\+', ' ')}")
				end
			else
				puts "didnt find token #{tok.inspect}"
			end
		end
	end

	def use_registry
		reg = YAML.load_file(CONST::Telegram::Registry_File)
		reg = {} unless reg
		ret = yield reg
		File.open(CONST::Telegram::Registry_File, 'w') { |f| f.puts reg.to_yaml }
		ret
	end

end
