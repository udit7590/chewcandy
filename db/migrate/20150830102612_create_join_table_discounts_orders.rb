class CreateJoinTableDiscountsOrders < ActiveRecord::Migration[5.2]
  def change
    create_join_table :discounts, :orders do |t|
      
      t.timestamps
      # t.index [:discount_id, :order_id]
      # t.index [:order_id, :discount_id]
    end
  end
end
