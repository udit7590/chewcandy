class CreateDiscounts < ActiveRecord::Migration
  def change
    create_table :discounts do |t|
      t.references :user
      t.string :email

      t.string :code

      t.decimal :amount
      t.string :unit
      t.decimal :max_amount

      t.boolean :active

      t.datetime :deleted_at, index: true
      t.integer :created_by
      t.integer :updated_by
      t.timestamps
    end
  end
end
