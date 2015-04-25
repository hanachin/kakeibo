class BankAccountControllerController < ApplicationController
  def index
    @bank_account = BankAccount.new
  end
end
