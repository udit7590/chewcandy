class CreateRefunds < ActiveRecord::Migration[5.2]
  def change
    create_table :refunds do |t|
      t.references :user
      t.references :order
      t.references :subscription
      t.decimal :amount, precision: 12, scale: 2

      t.text :comments
      t.boolean :complete, default: false
      t.timestamps
    end
  end
end
