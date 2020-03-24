class AddSlugToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :number, :string, index: true
  end
end
