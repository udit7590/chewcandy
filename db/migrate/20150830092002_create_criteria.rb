class CreateCriteria < ActiveRecord::Migration
  def change
    create_table :criteria  do |t|
      # Use Multiple table inheritance
      t.actable

      # Unique name given by user
      t.string :name

      t.boolean :one_time
      t.datetime :valid_from
      t.datetime :valid_till
      t.timestamps
    end
  end
end
