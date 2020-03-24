class AddCancelledToSubscription < ActiveRecord::Migration
  def change
     add_column :subscriptions, :cancelled, :boolean, default: false
  end
end
