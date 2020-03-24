class AddTaxInclusiveToProduct < ActiveRecord::Migration
  def change
    add_column :products, :tax_inclusive, :boolean, default: false
  end
end
