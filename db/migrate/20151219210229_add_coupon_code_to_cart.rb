class AddCouponCodeToCart < ActiveRecord::Migration[5.2]
  def change
    add_column :shopping_carts, :coupon_code, :string
  end
end
