class CreateFestivalCriteria < ActiveRecord::Migration
  def change
    create_table :festival_criteria do |t|
      t.string :name
      
    end
  end
end
