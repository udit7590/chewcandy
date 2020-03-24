class ProductDecorator < Draper::Decorator
  delegate_all

  def rate_string
    Currency.string + price.to_s + " per #{ min_quantity } #{ min_quantity_unit }"
  end
end
