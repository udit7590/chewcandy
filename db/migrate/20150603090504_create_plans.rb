class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :type
      t.decimal :price, precision: 12, scale: 2 # Per box
      t.text :description
      t.timestamps
    end
  end
end
