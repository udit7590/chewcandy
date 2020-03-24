class DiscountsOrder < ActiveRecord::Base
  belongs_to :discount
  belongs_to :order
end
