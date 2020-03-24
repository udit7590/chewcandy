class AddPhoneToUser < ActiveRecord::Migration
  def change
    add_column :users, :phone_number, :string
    add_column :users, :phone_number_verified, :boolean, default: false
  end
end
