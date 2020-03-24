class Currency

  DEFAULT = :inr
  AVAILABLE = [:inr]

  def self.string(currency = DEFAULT)
    currency.to_s.upcase + ' '
  end

end
