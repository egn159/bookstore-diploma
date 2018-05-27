require 'csv'

#:encoding => 'ISO-8859-1'

#<Book id: nil, name: nil, price: nil, created_at: nil, updated_at: nil, short_desc: nil, category_id: nil, full_desc: nil, width: nil, height: nil, depth: nil, published: nil, materials: nil>
#<Category id: 6, name: "lol", created_at: "2018-05-13 11:11:34", updated_at: "2018-05-13 11:11:34">
#<Author id: nil, created_at: nil, updated_at: nil, name: nil>

task :load_csv_dump => [ :environment ] do

  puts 'Clear Categories, Authors, Books'
  [Category, Author, Book].each { |model| model.destroy_all }

  puts 'Loading CSV dump'
  csv_text = File.read(Rails.root.join('lib', 'tasks', 'seeds', 'database.csv'))
  csv = CSV.parse(csv_text, headers: true)

  puts 'CSV parsing'
  csv.each_with_index do |row, i|
    p "Book #{i}"
    b = Book.new
    p "Generate authors#{i}"
    unless row['authors']&.index(',').nil?
      authors = row['authors'].split(',')
      authors.each do |author|
        a = Author.find_or_create_by!(name: author)
        b.authors << a
      end
    end
    b.authors << Author.find_or_create_by!(name: row['authors']) if b.authors.empty?
    p "Set name #{i}"
    b.name = row['title']
    p "Set price #{i}"
    b.price = (row['price'].to_i.zero?) ? rand(1.0..20.00).round(2): row['price']
    p "Set desc #{i}"
    b.full_desc = row['description'] unless row['description'].nil?
    p "Set short desc #{i}"
    b.short_desc = b.full_desc[0..100] unless b.full_desc.nil?
    b.short_desc << '...' unless b.full_desc == b.short_desc && b.short_desc.nil?

    p "Set dimensions #{i}"
    unless row['dimensions'].nil?
      row['dimensions'] = row['dimensions'].gsub(/\u00a0/, '')
      dim = row['dimensions'].split('x').map(&:to_f)
      b.width = dim[0]
      b.height = dim[1]
      b.depth = dim[2]
    end
    #binding.pry
    p "Set published #{i}"
    b.published = row['published'] unless row['published'].nil?
    p "LOAD images #{i}"
    b.images << Image.new(remote_image_url: row['image_url']) unless row['image_url'].nil?
    p "create category #{i}"

    b.category = Category.find_or_create_by!(name: row['main_category'])
    p 'BOOK:'
    p b.inspect
    b.save!
    p "Book #{i} created"
    p "================================="
  end
end
