class Numeric 	
	require 'money'
	require 'money/bank/google_currency'


	@@day ||= Time.new.day

	def self.rate currency
		bank = Money::Bank::GoogleCurrency.new
		bank.get_rate(currency, :EGP).to_f
	end

	dollar ||= rate :USD
	euro ||= rate :EUR
	yen ||= rate :YEN

	@@cach={}

	@@currencies = {egps: 1, dollars: dollar, euros: euro, yens: yen}

	@@currencies.each do |currency, rate|
		define_method(currency) do
			self * rate
		end
		alias_method "#{currency}s".to_sym, currency
	end

	def convert_currency options={}
		current_day = Time.new.day

		if current_day != @@day
			@@cach.clear
		end

		from = 	options[:from]
		to = options[:to]
		k = from.to_s + to.to_s

		#check if user did this convertion through the same day
		if @@cach.has_key?(k)
			@@cach[k]
			puts "enterd if"
		else
			puts "enterd else"
			currency_1 = @@currencies[from]
			currency_1 ||= @@currencies[(from.to_s+"s").to_sym]
			currency_2 = @@currencies[to]
			currency_2 ||= @@currencies[(to.to_s+"s").to_sym]
			
			rate = currency_1 / currency_2
			@@cach[k] = self * rate
			@@cach[k]
		end
	end

	def add_currency options={}
		@@currencies = @@currencies.merge(options)
	end
end