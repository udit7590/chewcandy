class ShoppingCartItemDecorator < Draper::Decorator
  delegate_all

  def display_quantity
    "#{ quantity } #{ product.min_quantity_unit.pluralize }"
  end

  def display_amount
    "#{ amount } #{ taxes_inclusive_annotation(product) }"
  end

  def amount
    "#{ Currency.string } #{ object.amount }"
  end
end
