class AddCancelledToSubscription < ActiveRecord::Migration[5.2]
  def change
     add_column :subscriptions, :cancelled, :boolean, default: false
  end
end
