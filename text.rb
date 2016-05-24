module SuperHash
	def respond_to?(symbol, include_private=true)
		return true if key?(symbol.to_sym)
		super
	end
	def method_missing(method_name, *args)
		if respond_to? method_name
			self[method_name.to_sym]
		else
			super
		end
	end
end

class Text
	class << self
		alias_method :[], :get
		def [](text_name, placeholders = [])
			text = YAML.load(ERB.new(File.read(filename)).result) || {}
			text[text_name] % placeholders
		end
	end
end
