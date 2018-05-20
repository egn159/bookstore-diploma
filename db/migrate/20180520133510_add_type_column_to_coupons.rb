class AddTypeColumnToCoupons < ActiveRecord::Migration[5.1]
  def change
    add_column :coupons, :type, :integer, default: 0
    add_column :coupons, :activated, :boolean, default: false
  end
end
