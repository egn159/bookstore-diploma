class ChangeColumnsReview < ActiveRecord::Migration[5.1]
  def change
    change_table :reviews do |t|
      t.remove :accepted
      t.integer :status, null: false, default: 0
    end
  end
end
