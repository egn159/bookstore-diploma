class CreditCard < ApplicationRecord
  validates :number, :name, :expires, :cvv, presence: true
  validates :number, length: { is: 16 }, numericality: { only_integer: true }
  validates :name, length: { in: 2..49 }, format: { with: /\A[a-zA-Z\s]+\z/ }
  validates :expires, format: { with: /\A(0[1-9]|10|11|12)\/\d\d\z/ }
  validates :cvv, length: { is: 3 }, numericality: { only_integer: true }

  belongs_to :order
end
