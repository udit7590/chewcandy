class CreateSubscriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :subscriptions do |t|
      t.references :user
      t.references :plan

      t.boolean :active, default: false
      t.boolean :completed, default: false
      t.integer :remaining_units
      t.decimal :amount, precision: 12, scale: 2
      t.boolean :to_be_returned, default: false

      t.timestamps
    end
  end
end
