# returns a list of user IDs (strings that uniquely identify a user)
# representing the friends of a user.
def get_friends_list_for_user(user_id, data_hash)
	return data_hash[user_id]['friends']
end

# returns a list of trades represented by a string: 
# “<date>,<BUY|SELL>,<ticker>”, e.g. “2014-01-01,BUY,GOOG”,
# ordered by trade date with the most recent trade first in the list.
def get_trade_transactions_for_user(user_id, data_hash)
	trade_strings = []
	data_hash[user_id]['trades'].each do |hash|
		trade_strings << "#{hash['date']},#{hash['action']},#{hash['ticker']}"
	end
	return trade_strings.sort_by!{|trade_string| trade_string.split(',')[0]}.reverse!
end