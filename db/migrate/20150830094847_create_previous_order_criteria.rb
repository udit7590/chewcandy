class CreatePreviousOrderCriteria < ActiveRecord::Migration
  def change
    create_table :previous_order_criteria do |t|
      t.decimal :minimum_previous_orders_amount
      t.integer :number_of_minimum_orders_quantity
      t.integer :number_of_minimum_orders

      # When a campaign launched due during which if order placed, dicount will be valid
      t.boolean :special_period, default: false
      t.datetime :orders_from
      t.datetime :orders_till
    end
  end
end
