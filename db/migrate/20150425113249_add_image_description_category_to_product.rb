class AddImageDescriptionCategoryToProduct < ActiveRecord::Migration
  def change
    add_attachment :products, :image
    add_column :products, :description, :text, limit: 3000
    add_column :products, :category, :string
  end
end
