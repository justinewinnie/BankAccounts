# Bank Accounts 2.29.16 Justine Winnie
### Primary Functionality
# 1. Create a `Bank` module which will contain your `Account` class and any future bank account logic.
# 1. Create an `Account` class which should have the following functionality:
#   - A new account should be created with an __ID__ and an __initial balance__
#   - Should have a `withdraw` method that accepts a single parameter which represents the    amount of money that will be withdrawn. This method should return the updated account balance.
#   - Should have a `deposit` method that accepts a single parameter which represents the amount of money that will be deposited. This method should return the updated account balance.
#   - Should be able to access the current `balance` of an account at any time.

    # Example code:
      # module Gym
      #   class Push
      #     def up
      #       40
      #     end
      #   end
      # end
      # require "gym"

module Bank
  class Account
    # initialize method creates instance of Account class with @instance variables @id and @init_balance
    def initialize(Accountdata)
    @id = Accountdata[:id] # float? provided from csv?
    @init_balance = Accountdata[:init_balance] #float
    end

    # withdraw method accepts a single parameter which represents the amount of the withdrawal. method should return the updated account balance.
    def withdraw

    end

    # deposit method accepts a single parameter which represents the amount of the deposit. method should return the updated account balance.
    def deposit

    end
  end
end
