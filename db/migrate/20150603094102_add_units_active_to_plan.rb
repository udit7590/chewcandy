class AddUnitsActiveToPlan < ActiveRecord::Migration
  def change
    add_column :plans, :units, :integer # Number of boxes to be delivered in the plan
    add_column :plans, :active, :boolean, default: false
  end
end
