class CreateJoinTableCriteriaDiscounts < ActiveRecord::Migration[5.2]
  def change
    create_join_table :discounts, :criteria do |t|
      
      t.timestamps
      # t.index [:discount_id, :criterium_id]
      # t.index [:criterium_id, :discount_id]
    end
  end

end
