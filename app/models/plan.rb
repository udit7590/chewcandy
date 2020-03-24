class Plan < ActiveRecord::Base
  self.inheritance_column = :_type_disabled

  scope :monthly, -> { where(type: 'monthly', active: true).last }
  scope :half_yearly, -> { where(type: 'half_yearly', active: true).last }
  scope :yearly, -> { where(type: 'yearly', active: true).last }

  def amount
    units * price
  end

  def amount_including_taxes
    (amount + taxes).to_f
  end

  def taxes
    (amount * Constants::VAT_RATE).to_f
  end

  def amount_for(units_delivered)
    units_delivered * price
  end

  def amount_difference(units_delivered)
    (amount_including_taxes / units) - amount_for(units_delivered)
  end
end
