class AddDefaultValueToMinActivatePriceCoupon < ActiveRecord::Migration[5.1]
  def change
    change_column :coupons, :min_sum_to_activate, :float, default: 0
  end
end
