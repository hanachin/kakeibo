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

  def monthly_expences_history
    history = daily_balance_history.map {|h| [h[:date], h[:amount]]}.to_h

    start_at, end_at = history.keys.minmax
    current_date = start_at.next_month
    end_at = end_at.prev_month

    h = []
    while current_date <= end_at
      bm = current_date.prev_month
      em = current_date.end_of_month
      s = Date.new(bm.year, bm.month, 24)
      e = Date.new(em.year, em.month, 24)
      month_range = s..e
      min_date, max_date = month_range.minmax_by {|d| history[d] }
      expences = history[max_date] - history[min_date]
      h << {month: current_date.beginning_of_month, expences: expences}
      current_date = current_date.next_month
    end
    h
  end
end
