class CriteriaDiscounts < ActiveRecord::Base
  belongs_to :discount
  belongs_to :criterium
end
