class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :name
      t.decimal :price, precision: 12, scale: 2 # Per 10 gms
      t.integer :stock # In Gms
      t.integer :discount # In %
      t.timestamps
    end
  end
end
