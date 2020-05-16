class AddPackagingAmountRenameShippingCostInOrder < ActiveRecord::Migration[5.2]
  def change
    add_column    :orders, :total_packaging_amount, :decimal, precision: 12, scale: 2
    rename_column :orders, :total_shipping_cost, :total_shipping_amount
  end
end
