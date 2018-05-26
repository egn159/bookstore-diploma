class Coupon < ApplicationRecord
  has_many :orders, dependent: :nullify
  validates :code, presence: true, uniqueness: true
  validates :discount, presence: true

  enum coupon_type: %i[reusable one_time]

  def self.generate_review_coupon
    code = 'review_' << rand(36**10).to_s(36).upcase
    Coupon.create(name: 'Review bonus', min_sum_to_activate: 25,
                  expires: DateTime.now + 7.days, discount: 1,
                  code: code, coupon_type: :one_time)
  end

  #we will generate coupon depending on total_price
  def self.generate_first_order_coupon(total_price)
    case total_price
    when 1...25 then bonus = 1
    when 25...50 then bonus = 2
    when 50..100 then bonus = 3
    else bonus = 5 if total_price > 100
    end
    code = 'gift_' << rand(36**10).to_s(36).upcase
    min_sum = bonus * 20
    Coupon.create(name: 'First order', min_sum_to_activate: min_sum,
                  expires: DateTime.now + 7.days, discount: bonus, code: code, coupon_type: :one_time)
  end
end
