class CreateEnquiry < ActiveRecord::Migration
  def change
    create_table :enquiries do |t|
      t.references :user
      t.string :from_email
      t.string :from_name
      t.string :about
      t.text :message, limit: 2000
      t.timestamps
    end
  end
end
