class CreateShoppingCart < ActiveRecord::Migration[5.2]
  def change
    create_table :shopping_carts do |t|
      t.references :user
      t.boolean :active
      t.timestamps
    end
  end
end
