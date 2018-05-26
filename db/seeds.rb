require 'ffaker'

def generate_category
  Category.create!(name: FFaker::Book.genre[0...20])
end

def generate_author
  Author.create!(name: FFaker::Book.author)
end

def generate_book
  b = Book.create!(
    name: FFaker::Book.title,
    price: rand(1.0..99.00).round(2),
    short_desc: FFaker::Book.description(1),
    category: Category.find(rand(1..5)),
    full_desc: FFaker::Book.description(rand(2..5)),
    width: rand(100..250),
    height: rand(100..250),
    depth: rand(10..250),
    materials: FFaker::CheesyLingo.words(rand(1..3)).join(', '),
    published: rand(1950..2017)
  )

  add_image_to_book(b)
  add_authors_to_book(b)
end

def add_image_to_book(book, add = false)
  return if !Rails.env.production? && !add
  book.images << Image.new(remote_image_url: FFaker::Book.cover(nil, "328x506"))
end

def add_authors_to_book(book)
  rand(1..5).times do
    a = {}
    loop do
      a = Author.find(rand(1..30))
      break unless book.authors.include?(a)
    end
    book.authors << a
  end
end

def create_admin_user
  user = User.new(email: "admin@loc.loc", is_admin: true, password: "123456q")
  user.skip_confirmation!
  user.save!
end

def create_coupon(name = "Test", code = "test-coupon")
  Coupon.create(
    name: name,
    min_sum_to_activate: 0,
    discount: rand(1...5),
    code: code,
    expires: Time.now + 365.days
  )
end

def create_delivery_methods
  delivery_methods = [
    { name: 'Pick Up In-Store', delay: '5 to 20 days', cost: 13 },
    { name: 'Delivery Next Day!', delay: '3 to 7 days', cost: 15 },
    { name: 'Expressit', delay: '2 to 3 days', cost: 20 }
  ]
  delivery_methods.each do |item|
    DeliveryMethod.create!(item)
  end
end
if ENV['generate_books']
  5.times { generate_category }
  30.times { generate_author }
  50.times { generate_book }
end

create_admin_user
create_coupon("New year coupon", "zzafg-8")
create_delivery_methods
