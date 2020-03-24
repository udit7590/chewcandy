class Discount < ActiveRecord::Base
  attr_accessor :criteria_ids
  acts_as_paranoid

  AMOUNT_UNITS = ['percentage', 'INR']

  has_many :criteria_discounts
  has_many :criteria, through: :criteria_discounts
  has_many :discounts_orders
  has_many :orders, through: :discounts_orders
end
