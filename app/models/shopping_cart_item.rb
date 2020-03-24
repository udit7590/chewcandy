class ShoppingCartItem < ActiveRecord::Base
  include AnnotationsHelper

  belongs_to :product
  belongs_to :shopping_cart

  before_save :calculate_total_product_amount, :calculate_total_tax_amount, :calculate_shipping_amount

  validate :check_min_quantity_of_product_added, :check_max_quantity_of_product_added, :quantity_multiple_of_10

  def amount_with_tax_and_shipping
    amount.to_f + tax_amount.to_f + shipping_amount.to_f
  end

  def change_cart_id(cart_id)
    target_shopping_cart = ShoppingCart.find_by(id: cart_id)
    return false unless target_shopping_cart

    existing_cart_item = target_shopping_cart.shopping_cart_items.where(product_id: product_id).first
    if existing_cart_item.present?
      existing_cart_item.add(quantity)
      destroy
    else
      update!(shopping_cart_id: cart_id)
    end
    true
  end

  # returns self
  def add(quantity)
    self.quantity += quantity
    save
    self
  end

  protected

    def calculate_total_product_amount
      self.amount = (quantity / product.min_quantity) * product.price
    end

    def calculate_total_tax_amount
      self.tax_amount = product.tax_inclusive? ? 0.0 : (amount * Constants::VAT_RATE)
    end

    def calculate_shipping_amount
      shipping_amount.present? ? self.shipping_amount += 0 : self.shipping_amount = 0
    end

    def quantity_multiple_of_10
      errors[:quantity] << "should for #{ product.name } be a multiple of 10" if ((quantity.to_i % 10).nonzero? && product.unit == Product::GRAM)
    end

    def check_min_quantity_of_product_added
      errors[:quantity] << "added for #{ product.name } should be minimum #{ product.min_quantity } #{ product.min_quantity_unit }" if (quantity < product.min_quantity)
    end

    def check_max_quantity_of_product_added
      errors[:quantity] << "added for #{ product.name } should be maximum #{ product.max_quantity } #{ product.unit.pluralize }" if (quantity > product.max_quantity)
    end

end
