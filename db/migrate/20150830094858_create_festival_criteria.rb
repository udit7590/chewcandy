class CreateFestivalCriteria < ActiveRecord::Migration[5.2]
  def change
    create_table :festival_criteria do |t|
      t.string :name
      
    end
  end
end
