class CreateOrder < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.references :user
      t.references :shopping_cart
      t.string :state
      t.decimal :total_product_amount, precision: 12, scale: 2
      t.decimal :total_quantity, precision: 12, scale: 2
      t.decimal :total_tax_amount, precision: 12, scale: 2
      t.decimal :total_shipping_cost, precision: 12, scale: 2
      t.string :payment_method # IN COD, CC, DB, Paypal, etc
      t.boolean :verified, default: false
      t.timestamps
    end
  end
end
