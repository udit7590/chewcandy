class AddTaxInclusiveToProduct < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :tax_inclusive, :boolean, default: false
  end
end
