class AddPackagingAmountRenameShippingCostToShippingAmountInShoppingCartItem < ActiveRecord::Migration[5.2]
  def change
    add_column :shopping_cart_items, :packaging_amount, :decimal, precision: 12, scale: 2
    rename_column :shopping_cart_items, :shipping_cost, :shipping_amount
  end
end
