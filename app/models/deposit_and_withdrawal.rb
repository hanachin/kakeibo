class DepositAndWithdrawal

  include Enumerable
  include Mem

  class Row < OpenStruct
    def initialize(csv_row)
      row = csv_row.to_h

      row.delete(nil)

      %w[預り高 支払高 現在高(貸付高)].each do |yen_column|
        if row[yen_column]
          row[yen_column] = row[yen_column].gsub(/\\|,/, '').to_i
        end
      end

      if row['取扱年月日']
        row['取扱年月日'] = Date.parse(row['取扱年月日'])
      end

      super(row)
    end

    def date
      self['取扱年月日']
    end

    def amount
      self['現在高(貸付高)']
    end

    def empty?
      to_h.values.all?(&:nil?)
    end
  end

  def each
    rows.each {|r| yield r }
  end

  private

  memoize\
  def csv
    CSV.parse(csv_content, headers: :first_row)
  end

  memoize\
  def csv_content
    File.read(csv_path, encoding: 'Shift_JIS:UTF-8')
  end

  memoize\
  def csv_path
    Rails.root.join('deposit_and_withdrawal.csv')
  end

  memoize\
  def rows
    csv.map {|r| Row.new(r) }.reject(&:empty?)
  end
end
