class Book < ApplicationRecord
  has_many :order_items, dependent: :destroy
  has_many :orders, through: :order_items
  has_many :reviews, dependent: :destroy
  has_many :images, as: :imageable, dependent: :destroy
  has_and_belongs_to_many :authors
  belongs_to :category, optional: true

  MAX_FULL_DESC_SHOW = 300
  BOOKS_PER_PAGE = 12
  paginates_per BOOKS_PER_PAGE

  SORT_PARAMS = {
    'newest' => { created_at: :desc },
    'popular' => { created_at: :asc },
    'lowprice' => { price: :asc },
    'highprice' => { price: :desc },
    'title-az' => { name: :asc },
    'title-za' => { name: :desc }
  }.freeze

  DEFAULT_SORT = 'newest'.freeze

  validates :name, :price, presence: true

  scope :bestsellers, ->(num = 4) do
    select('books.*')
      .from('order_items')
      .joins(
        'INNER JOIN orders ON orders.id = order_items.order_id AND orders.status != 0' \
        'RIGHT OUTER JOIN books ON books.id = order_items.book_id'
      ).group('books.id')
      .order('COUNT(order_items.book_id) DESC')
      .limit(num)
  end

  scope :latest, ->(num = 2) { last(num) }
  scope :select_category, ->(cat) { where(category: cat) if cat.present? }
  scope :select_sort, ->(val) { order(SORT_PARAMS[val]) if SORT_PARAMS.key?(val) }
  scope :search, ->(val) { where('lower(name) LIKE ?', "%#{val.downcase}%") if val.present? }
end
