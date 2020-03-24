class ShoppingCart < ActiveRecord::Base
  has_many :shopping_cart_items, dependent: :destroy
  belongs_to :user
  has_one :order

  delegate :discount_amount, to: :coupon

  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }

  def add(product_id, quantity)
    product = Product.find_by(id: product_id)
    return false unless product # We can also raise exception here!

    existing_cart_item = shopping_cart_items.where(product_id: product_id).first
    if existing_cart_item.present?
      existing_cart_item.add(quantity)
    else
      shopping_cart_items.create(product_id: product_id, quantity: quantity)
    end
  end

  def remove(product_id)
    product = Product.find_by(id: product_id)
    return false unless product

    shopping_cart_items.where(product_id: product_id).first.destroy
  end

  def empty
    shopping_cart_items.destroy_all
  end

  def empty?
    shopping_cart_items.length < 1
  end

  def inactivate!
    update!(active: false)
  end

  def inactive?
    !active
  end

  def total_amount
    shopping_cart_items.sum(:amount).to_f
  end

  alias_method :total_product_amount, :total_amount

  def quantity
    shopping_cart_items.present? ? shopping_cart_items.sum(:quantity) : 0
  end

  def valid_for_checkout?
    if total_amount >= 150.0
      true
    else
      errors[:base] << 'Your order amount should be a minimum of INR 150.0'
      false
    end
  end

  def currency
    :inr
  end

  def display_currency
    'INR '
  end

  def taxes
    shopping_cart_items.sum(:tax_amount).to_f
  end

  def display_taxes
    display_currency + taxes.to_s
  end

  def shipping_amount
    Constants::SHIPPING_AMOUNT
  end

  def display_shipping_amount
    display_currency + shipping_amount.to_s
  end

  def calculate_payable_amount
    total_amount.to_f + taxes + shipping_amount - coupon.discount_amount
  end

  def display_payable_amount
    display_currency + calculate_payable_amount.to_s
  end

  def coupon
    Coupon.new(coupon_code, self)
  end

end
