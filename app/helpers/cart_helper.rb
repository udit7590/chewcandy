module CartHelper
  def item_quantity_display(item)
    "#{ item.quantity } #{ item.product.min_quantity_unit.pluralize }"
  end

  def item_amount_display(item)
    "INR #{ item.amount } #{ taxes_inclusive_annotation(item.product) }"
  end
end