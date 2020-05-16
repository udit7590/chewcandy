class CreateMinOrderCriteria < ActiveRecord::Migration[5.2]
  def change
    create_table :min_order_criteria do |t|
      t.decimal :amount
      t.integer :quantity
    end
  end
end
