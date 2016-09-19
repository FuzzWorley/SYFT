require 'date'

TICKERS =	['GOOG', 'AAPL', 'AMZN', 'NFLX', 'FB', 'MSFT', 'INTC', 'ULTI']

# return an array of unique user ids as strings
def seed_user_ids
	user_ids = []
	(1..100).each do |x|
		user_ids << x.to_s
	end
	return user_ids
end

# create a random number of trade strings representing random trades.
def create_random_trade_strings(hash, id)
	(5..70).to_a.sample.times do
		# get random date in the past 180 days
		# this app pretends markets are open 7 / 365!!
		date = Date.today-rand(180)
		hash[id]['trades'] << {
			'date' => date.to_s, 
			'action' => ["BUY", "SELL"].sample, 
			'ticker' => TICKERS.sample
		}
	end
end

# add a random number of friends excluding current user
def add_random_friends(hash, id, all_ids)
	(10..40).to_a.sample.times do
		# reject own user id from being added to friends
		hash[id]['friends'] << all_ids.reject{|x| x == id}.sample
	end
	# remove duplicate values
	hash[id]['friends'].uniq!
end

# build and return a hash containing a random number of trade strings and friends for each user.
# will return hash with this format:
# {
#   "1"=>
#     {"trades"=>
#       [{"date"=>"2016-03-24", "action"=>"SELL", "ticker"=>"GOOG"},
#        {"date"=>"2016-06-11", "action"=>"BUY", "ticker"=>"INTC"},
#        {"date"=>"2016-06-15", "action"=>"SELL", "ticker"=>"GOOG"},
#        {"date"=>"2016-09-14", "action"=>"BUY", "ticker"=>"AMZN"}],
#      "friends"=>
#       ["69", "97", "84", "24", "42", "67", "47", "23", "76", "53", "50"]},
#   "100"=>
#     {"trades"=>
#       [{"date"=>"2016-04-13", "action"=>"BUY", "ticker"=>"NFLX"},
#        {"date"=>"2016-04-15", "action"=>"BUY", "ticker"=>"INTC"},
#        {"date"=>"2016-04-26", "action"=>"BUY", "ticker"=>"MSFT"},],
#      "friends"=>
#       ["25", "1", "16"]}
# }
def seed_mock_data
	mock_data_hash = {}
	user_ids = seed_user_ids
	user_ids.each do |id|
		mock_data_hash[id] = {'trades' => [], 'friends' => []}
		create_random_trade_strings(mock_data_hash, id)
		add_random_friends(mock_data_hash, id, user_ids)
	end
	# sort trades by date.
	mock_data_hash.each do |k, v|
		v['trades'].sort_by!{|hash| hash['date']}
	end
	return mock_data_hash
end