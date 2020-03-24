class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :primary # false: Shipping, true: Billing
      t.references :user
      t.string :country
      t.string :state
      t.string :city
      t.integer :pincode
      t.text :full_address

      # When the admin verifies the address
      t.datetime :verified_at
      
      t.timestamps
    end
  end
end
