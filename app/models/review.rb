class Review < ApplicationRecord
  belongs_to :user
  belongs_to :book

  validates_presence_of :title, :text, :rating
  validates :title, :text, format: { with: /\A[0-9A-z!#$%&'\-*,+=?^_`{|}~. ]+\z/ }
  validates :rating, inclusion: { in: 1..5 }
  validates_length_of :text, maximum: 1000
  validates_length_of :title, maximum: 80

  enum status: %i[unprocessed approved rejected]
end
