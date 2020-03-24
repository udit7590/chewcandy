json.item do
  json.product_id @removed_item.product_id
  json.product_name @removed_item.product.name
end

json.cart do
  json.id @cart.id
  json.total_items @cart.shopping_cart_items.length
  json.total_quantity @cart.shopping_cart_items.sum(:quantity)
end
