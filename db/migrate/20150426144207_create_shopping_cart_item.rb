class CreateShoppingCartItem < ActiveRecord::Migration[5.2]
  def change
    create_table :shopping_cart_items do |t|
      t.references :product
      t.references :shopping_cart
      t.integer :quantity #In gms
      t.decimal :amount, precision: 12, scale: 2
      t.decimal :tax_amount, precision: 12, scale: 2
      t.decimal :shipping_cost, precision: 12, scale: 2
      t.timestamps
    end
  end
end
