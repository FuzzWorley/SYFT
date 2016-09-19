require 'pp'
require 'date'
require './seed.rb'
require './user_methods.rb'

# sets a variable equal to a mock data hash table.
seed_data_hash = seed_mock_data

# takes a user_id string and mock data hash for parameters
# get a user's friends' trades for the past week
# returns an array of strings with this format "2016-09-10,SELL,AAPL"
def get_friends_trades_past_week(user_id, data_hash)
  friends = get_friends_list_for_user(user_id, data_hash)
  friends_trades = friends.map! {|friend| 
    get_trade_transactions_for_user(friend, data_hash)
  }
  if friends_trades.flatten!
    friends_trades.flatten!.reject!{|trade_string| 
      Date.parse(trade_string.split(',')[0]) <= Date.today - 7
    }
  end
  return friends_trades
end

# takes an array of trade_strings with this format "2016-09-10,SELL,GOOG" as a parameter
# create hash structure to store count of BUY and SELL for each ticker
# and populate with values of friends' trades
def populate_friends_trades_hash(friends_trades)
  friends_trades_hash = Hash[friends_trades.map{|trade| [trade.split(",")[2], {"BUY" => 0, "SELL" => 0}]}]
  friends_trades.each do |trade|
    friends_trades_hash[trade.split(",")[2]][trade.split(",")[1]] += 1
  end
  return friends_trades_hash
end

# takes a hash of trades from populate_friends_trades or any hash with this format:
# {"AAPL"=>{"BUY"=>3, "SELL"=>2},
#  "GOOG"=>{"BUY"=>3, "SELL"=>0}}
# and returns an array of alert strings ordered by highest number of net orders of the same type.
def create_ranked_alert(trades_hash)
  alerts = []
  trades_hash.each do |ticker, action_hash|
    alerts << [ticker, action_hash["BUY"] - action_hash["SELL"]]
  end
  alerts.sort_by!{|arr| arr[1].abs}.reverse!.reject!{|arr| arr[1] == 0}
  alert_strings = alerts.map! do |arr|
    arr[1] > 0 ? "#{arr[1]},BUY,#{arr[0]}" : "#{arr[1].abs},SELL,#{arr[0]}"
  end
  return alert_strings
end

# takes a user id string and a seeded data hash as input
# and outputs strings with the following format: “5,SELL,GOOG”
# order by highest number of friends selling
def run_program(user_id, seed_data_hash)
  friends_trades = get_friends_trades_past_week(user_id, seed_data_hash)
  friends_trades_hash = populate_friends_trades_hash(friends_trades)
  create_ranked_alert(friends_trades_hash).each {|str| puts str}
end

# uncomment line below if you want to see mock data
# pp seed_mock_data
run_program("1", seed_data_hash)
