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

### Error handling
  # 1. A new account cannot be created with initial negative balance - this will `raise` an `ArgumentError` (Google this)
  # 1. The `withdraw` method does not allow the account to go negative - Will `puts` a warning message and then return the original un-modified balance


  # Wave 2: CSV Files!
  #
  # Primary Requirements
  #
  # Update the Account class to be able to handle all of these fields from the CSV file used as input.
  # For example, manually choose the data from the first line of the CSV file and ensure you can create a new instance of your Account using that data
  # Add the following class methods to your existing Account class
  # self.all - returns a collection of Account instances, representing all of the Accounts described in the CSV. See below for the CSV file specifications
  # self.find(id) - returns an instance of Account where the value of the id field in the CSV matches the passed parameter
  # CSV Data File for Bank::Account
  #
  # The data, in order in the CSV, consists of:
  #
  # ID - (Fixnum) a unique identifier for that Account
  # Balance - (Fixnum) the account balance amount, in cents (i.e., 150 would be $1.50)
  # OpenDate - (Datetime) when the account was opened

module Bank

  class Account
  # Class has constants to simplify changing minimum initial balances and fees.
  WITHDRAWAL_FEE = 0
  MIN_INIT_BALANCE = 0
  MIN_NEG_BALANCE = 0
  MIN_NEG_MSG = "Withdrawal cannot be completed with available funds."

    attr_reader :balance

    def initialize(accountdata)
    @owner = accountdata[:owner] # string
    @id = accountdata[:id] # fixnum
    @init_balance = accountdata[:init_balance].to_f #float
      if @init_balance < self.class::MIN_INIT_BALANCE
        raise ArgumentError.new("Account cannot be initialized with a balance less than #{self.class::MIN_INIT_BALANCE}.")
      end
    @balance = accountdata[:balance].to_f # float
    # set @balance to value of @init_balance
    @balance = @init_balance
    end

    # Withdraw method accepts a single parameter which represents the amount of the withdrawal. Method should return the updated account balance.
    def withdraw(withdrawal)
      if @balance - (withdrawal + self.class::WITHDRAWAL_FEE)>= self.class::MIN_NEG_BALANCE
        @balance -= (withdrawal + self.class::WITHDRAWAL_FEE)
      else puts self.class::MIN_NEG_MSG
        balance
      end
    end

    # Deposit method accepts a single parameter which represents the amount of the deposit. Method should return the updated account balance.
    def deposit(deposit)
      @balance += deposit
      balance
    end

    # Test to see if differentiating @init_balance and @balance worked.
    # def initial_balance
    #   return @init_balance
    # end

    # Add an owner (instance of Owner class, below) to an already existing account.
    def add_owner(owner)
      @owner = owner
    end

    # Pulled tracing the pathway and putting the csv data into an array, into its own method.
    def read_csv(file)
      require 'csv'
      allaccountscsv = CSV.read(file, 'r')
      return read_csv
    end

    # Be able to pull data from a specific line in the csv to an existing account.
    def acct_from_csv(csv_index)
      read_csv("./support/accounts.csv")
      @id = allaccountscsv[csv_index][0]
      @balance = allaccountscsv[csv_index][1]
      @open_date = allaccountscsv[csv_index][2]
    end

    # Class method traces file pathway and puts csv data into array.
    def self.read_csv(file)
      require 'csv'
      read_csv = CSV.read(file, 'r')
    end

# Create array of hashes from csv.
    def self.csv_to_accounts
    require "awesome_print"
    allaccounts = []
      read_csv("./support/accounts.csv").each do |entry|
        account = self.new(id: entry[0], balance: entry[1], open_date: entry[2])
        allaccounts << account
        end
      ap allaccounts
    end

#Create array of arrays from csv.
    def self.csv_to_accounts_2
    require "awesome_print"
    allaccounts = []
      (read_csv("./support/accounts.csv")).each do |entry|
        @id = entry[0]
        @balance = entry[1]
        @open_date = entry[2]
        allaccounts << entry
      end
      ap allaccounts
    end

    def self.find(id)
      id = id.to_s #lets the user enter id as a string/fixnum/float, and method still works.
      # find the entry in the csv where id matches the user-requested id
      read_csv("./support/accounts.csv").each do |entry|
        if entry[0] == id
          return entry
        end
      end
    end
  end


  class SavingsAccount < Account
    # The initial balance cannot be less than $10. If it is, this will raise an ArgumentError
    # Override constants from base class Account.
    WITHDRAWAL_FEE = 2
    MIN_INIT_BALANCE = 10
    MIN_NEG_BALANCE = 10
    MIN_NEG_MSG = "Savings account balance remain above $#{MIN_NEG_BALANCE}. Insufficient funds for this withdrawal."

    #add_interest(rate): Calculate the interest on the balance and add the interest to the balance. Return the interest that was calculated and added to the balance (not the updated balance).
    # Input rate is assumed to be a percentage (i.e. 0.25).
    # The formula for calculating interest is balance * rate/100
    # Example: If the interest rate is 0.25% and the balance is $10,000, then the interest that is returned is $25 and the new balance becomes $10,025.

    # Defining interest_rate in isolated, easily changed method.
    def interest_rate
      interest_rate = (0.25)
    end

    # Calculating interest on a specific balance.
    def calc_interest
      @balance * (interest_rate / 100)
    end

    # Adding calculated interest to balance.
    def add_interest
      @balance += calc_interest
    end
  end


  class CheckingAccount < Account
  # Override constant from base class Account.
  WITHDRAWAL_FEE = 1

  # Set local constants.
  CHECK_LIMIT = 3
  CHECK_FEE = 2

    # Initialize from Account, add instance variable @checktally.
    def initialize(accountdata)
    super
    @checktally = 0
    end

    # #withdraw_using_check(amount): The input amount gets taken out of the account as a result of a check withdrawal. Returns the updated account balance.
    # Allows the account to go into overdraft up to -$10 but not any lower
    # The user is allowed three free check uses in one month, but any subsequent use adds a $2 transaction fee
    def checking_min_balance(withdrawal)
      checking_min_balance = ((@balance - withdrawal) >= -10)
    end

    def check_tally
      @checktally += 1
    end

    def withdraw_using_check(withdrawal)
      if @checktally >= CHECK_LIMIT && checking_min_balance(withdrawal)
        @balance -= (withdrawal + CHECK_FEE)
        check_tally
        return @balance
      elsif @checktally < CHECK_LIMIT && checking_min_balance(withdrawal)
        @balance -= withdrawal
        check_tally
        return @balance
        puts
      elsif (checking_min_balance(withdrawal) == false)
        puts "Checking account must maintain minimum balance of $-10. Withdrawal cannot be completed with available funds."
      end
    end

    #Resets the number of checks used to zero.
    def reset_checks
      @checktally = 0
    end
  end



  class Owner
    def initialize
      @ownerID = ownerhash[:ownerID]
      @last_name = ownerhash[:last_name]
      @first_name = ownerhash[:first_name]
      @street_address = ownerhash[:street_address]
      @city = ownerhash[:city]
      @state = ownerhash[:state]
    end

    def self.read_csv(file)
      require "CSV"
      read_csv = CSV.read(file, 'r')
    end

    def self.owner_csv
      allowners = []
      read_csv("./support/owners.csv").each do |column|
        ownerinfo = {
          ownerID: column[0],
          last_name: column[1],
          first_name: column[2],
          street_address: column[3],
          city: column[4],
          state: column[5]}
          allowners << ownerinfo
      end
    end


    # Wave 2 Optionals.
    #
    # The data, in order in the CSV, consists of:
    # ID - (Fixnum) a unique identifier for that Owner
    # Last Name - (String) the owner's last name
    # First Name - (String) the owner's first name
    # Street Addess - (String) the owner's street address
    # City - (String) the owner's city
    # State - (String) the owner's state
    #
    # Add the instance method accounts to the Owner class. This method should return a collection of Account instances that belong to the specific owner. To create the relationship between the accounts and the owners use an account_owners.csv file. The data for this file, in order in the CSV, consists of:
    #
    # Account ID - (Fixnum) a unique identifier corresponding to an Account instance.
    # Owner ID - (Fixnum) a unique identifier corresponding to an Owner instance.

    # Step 1... Associate account_owners.csv and owners.csv
    # Step 2... Add method to return all accounts that belong to a specific owner.

    # def self.link_csvs_by_id(ownerID)
    #
    #   ownerinfo[:ownerID] == ownerID
    #   assoc_accts = []
    #   owner = read_csv("./support/accounts.csv")[ownerID]
    #   read_csv("./support/accounts.csv").each do |acct|
    #   if acct[0] == read_csv("./support/accounts.csv")[n][ownerID]
    #     assoc_accts << acct
    #     end
    #   end
    # end
    #
    # def owner_from_csv
    # end


  end
end
