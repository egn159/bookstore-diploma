require 'csv'


task :load_published_from_dump => [ :environment ] do

  #puts 'Clear Categories, Authors, Books'
  #[Category, Author, Book].each { |model| model.destroy_all }

  puts 'Loading CSV dump'
  csv_text = File.read(Rails.root.join('lib', 'tasks', 'seeds', 'database.csv'))
  csv = CSV.parse(csv_text, headers: true)

  puts 'CSV parsing'
  csv.each_with_index do |row, i|
    p "Book #{i}"
    b = Book.find_by(name: row['title'])
    next if b.nil?
    p "Set published #{i}"
    b.published = row['date_string'] unless row['date_string'].nil?
    p 'BOOK:'
    p b.inspect
    b.save!
    p "Book #{i} saved"

  end
end
