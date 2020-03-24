class AddAdminGuestToUser < ActiveRecord::Migration
  def change
    add_column :users, :guest, :boolean, default: false
    add_column :users, :admin, :boolean, default: false
  end
end
