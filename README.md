Stocks Your Friends Are Trading(SYFT)
=====================================

A small program that creates a mock data hash table of users, their trades, and their friends and returns ranked list of alerts for a users' friends' trades.

## Dependencies

You will need to have [Ruby 1.9 or later](https://www.ruby-lang.org/en/) installed. The libraries for MiniTest, Date, and Pretty Print are included in the Ruby standard library.

## Running the application

- **Main App**  
  Run `ruby SYFT.rb` from the root of this directory.

- **Unit Tests**  
  Run `ruby SYFT_unit_tests.rb` from the root of this directory.

- **Print Mock Data**  
  If you want to see the mock data that is being created, uncomment the line `pp seed_mock_data` in SFYT.rb before running.

- **Changing Mock Data**  
  In `seed.rb` you can change the `TICKERS` array to include any symbols you wish. You can also change any of the integers in the ranges to accomodate different # of users, # of friends, # of trades, or date range. Be aware that this application will crash if there isn't at least one user or if the number of friends doesn't reflect the user base size.