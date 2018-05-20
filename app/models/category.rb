class Category < ApplicationRecord
  has_many :books, dependent: :destroy

  validates :name, presence: true, length: { in: 2..40 }, uniqueness: true
end
