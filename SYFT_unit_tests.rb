require 'minitest/autorun'
require './seed.rb'
require './user_methods.rb'
require './SYFT.rb'

class SyftTest < MiniTest::Unit::TestCase
	describe SyftTest do

		# if this was a real application, i would also test cases where
		# users have no friends and where users have no trades.

		before do
			@seed_data_hash = seed_mock_data
		end

		describe "get_friends_list_for_user" do
	    it "returns an array of strings" do
	    	friends_list = get_friends_list_for_user("1", @seed_data_hash)
	    	assert_instance_of(Array, friends_list)
	    	assert_instance_of(String, friends_list[0])
	    end
	  end

		describe "get_trade_transactions_for_user" do
	    it "returns an array of strings" do
	  		transactions = get_trade_transactions_for_user("2", @seed_data_hash)
	    	assert_instance_of(Array, transactions)
	    	assert_instance_of(String, transactions[0])
	    end
	  end

		describe "get_trade_transactions_for_user" do
	    it "returns an array of strings ordered by date descending" do
	    	transactions = get_trade_transactions_for_user("3", @seed_data_hash)
	    	assert_operator(
	    		transactions[0].split(',')[0],
	    	  :>, 
	    	  transactions[1].split(',')[0]
	    	)
	    end
	  end

		describe "get_friends_trades_past_week" do
	    it "does not include trades older than one week" do
	  		trades_past_week = get_friends_trades_past_week("4", @seed_data_hash)
	  		refute(
	  			trades_past_week.any? {
	  				|trade| Date.parse(trade.split(',')[0]) <= Date.today - 7
	  			}
	  		)
	  	end
	  end

		describe "populate_friends_trades_hash" do
	    it "returns properly formatted hash" do
	    	trades_past_week = ["2016-09-16,BUY,GOOG", "2016-09-16,SELL,AMZN"]
	  		trades_hash = populate_friends_trades_hash(trades_past_week)
	  		assert_equal(trades_hash["GOOG"], {"BUY"=>1, "SELL"=>0})
	  		assert_equal(trades_hash["AMZN"], {"BUY"=>0, "SELL"=>1})
	  	end
	  end

		describe "create_ranked_alert" do
	    it "returns alerts ranked highest to lowest" do
	    	trades_past_week = get_friends_trades_past_week("4", @seed_data_hash)
	    	trades_hash = populate_friends_trades_hash(trades_past_week)
	  		ranked_alerts = create_ranked_alert(trades_hash)
	  		assert_operator(
	    		ranked_alerts.first.split(',')[0], :>=, ranked_alerts.last.split(',')[0]
	    	)
	  	end
	  end

		describe "create_ranked_alert" do
	    it "returns alerts representing correct BUY - SELL values" do
				trades_past_week = [
					"2016-09-16,BUY,GOOG", 
					"2016-09-16,SELL,AMZN",
					"2016-09-16,BUY,GOOG",
					"2016-09-16,SELL,AMZN",
					"2016-09-16,SELL,GOOG", 
					"2016-09-16,BUY,AMZN"
				]
				trades_hash = populate_friends_trades_hash(trades_past_week)
				ranked_alerts = create_ranked_alert(trades_hash)
				assert_equal(ranked_alerts[0].split(',')[0], "1")
				assert_equal(ranked_alerts[0].split(',')[1], "SELL")
				assert_equal(ranked_alerts[1].split(',')[0], "1")
				assert_equal(ranked_alerts[1].split(',')[1], "BUY")
	    end
	  end

	  describe "create_ranked_alert" do
	    it "rejects zero values" do
				trades_past_week = [
					"2016-09-16,BUY,GOOG", 
					"2016-09-16,SELL,GOOG", 
					"2016-09-16,SELL,AMZN",
					"2016-09-16,SELL,AMZN",
					"2016-09-16,BUY,AMZN"
				]
				trades_hash = populate_friends_trades_hash(trades_past_week)
				ranked_alerts = create_ranked_alert(trades_hash)
				assert_equal(ranked_alerts[0].split(',')[0], "1")
				assert_equal(ranked_alerts[0].split(',')[1], "SELL")
				assert_nil(ranked_alerts[1])
	    end
	  end

	end
end