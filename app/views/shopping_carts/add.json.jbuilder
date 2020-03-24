json.item do
  json.product_id @added_item.product_id
  json.product_name @added_item.product.name
  json.quantity @added_item.quantity
  json.quantity_display @added_item.decorate.display_quantity
  json.amount @added_item.amount
end

json.cart do
  json.id @cart.id
  json.total_items @cart.shopping_cart_items.length
  json.total_quantity @cart.shopping_cart_items.sum(:quantity)
end
