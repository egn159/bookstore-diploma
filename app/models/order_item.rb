class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :book

  after_destroy do |item|
    item&.order&.check_need_coupon
  end
end
