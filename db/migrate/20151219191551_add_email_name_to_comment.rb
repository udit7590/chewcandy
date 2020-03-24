class AddEmailNameToComment < ActiveRecord::Migration
  def change
    add_column :comments, :email, :string
    add_column :comments, :full_name, :string
  end
end
