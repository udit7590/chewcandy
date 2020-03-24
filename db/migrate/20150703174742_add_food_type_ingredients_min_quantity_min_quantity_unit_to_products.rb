class AddFoodTypeIngredientsMinQuantityMinQuantityUnitToProducts < ActiveRecord::Migration
  def change
    add_column :products, :ingredients, :text, limit: 1000
    add_column :products, :food_type, :string, default: 'vegetarian' # In vegetarian / non_vegetarian
    add_column :products, :min_quantity, :integer, default: 10
    add_column :products, :min_quantity_unit, :string, default: 'gram' # In gram and piece
  end
end
