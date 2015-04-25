class BankAccount
  attr_reader :deposit_and_withdrawl

  def initialize
    @deposit_and_withdrawl = DepositAndWithdrawal.new
  end

  def daily_balance_history
    history = {}

    @deposit_and_withdrawl.each_with_object(history) do |d_or_w, history|
      history[d_or_w.date] = d_or_w.amount
    end

    history_range = Range.new(*history.keys.minmax)

    h = []
    for date in history_range
      current_amount = history[date] || current_amount
      h << {date: date, amount: current_amount}
    end
    h
  end
end
