class AddCouponCodeToCart < ActiveRecord::Migration
  def change
    add_column :shopping_carts, :coupon_code, :string
  end
end
