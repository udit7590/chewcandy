class CreateSubscriptionDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :subscription_details do |t|
      t.references :subscription

      t.integer :units
      t.datetime :last_dispatched_at
      t.datetime :last_delivered_at
      t.datetime :last_payment_received_at
      t.decimal :last_payment_received, precision: 12, scale: 2
      t.timestamps
    end
  end
end
