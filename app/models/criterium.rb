class Criterium < ActiveRecord::Base
  actable

  has_many :criteria_discounts
  has_many :discounts, through: :criteria_discounts

  validates_presence_of :name

  TYPES = [FestivalCriterium, MinOrderCriterium, PreviousOrderCriterium]

  def fulfills?
    currently_valid?    
  end

  def currently_valid?(current_time = DateTime.now)
    valid = true
    valid = current_time >= valid_from if valid_from.present?
    valid = current_time <= valid_till if valid_till.present?
    valid
  end

  def single_use?
    one_time?
  end
end
