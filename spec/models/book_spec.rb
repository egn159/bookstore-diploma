require 'rails_helper'

RSpec.describe Book, type: :model do
  let(:category) { create_list(:category, 2) }
  let!(:book1) { create(:book, price: 10, category: category[0]) }
  let!(:book2) { create(:book, price: 2, category: category[1]) }
  let!(:book3) { create(:book, price: 15, category: category[1]) }
  let!(:book4) { create(:book, price: 4, category: category[0]) }

  describe 'ActiveRecord associations' do
    it { is_expected.to have_many(:order_items).with_foreign_key('item_id') }
    it { is_expected.to have_many(:orders).through(:order_items) }
    it { is_expected.to have_many(:reviews) }
    it { is_expected.to belong_to(:category) }
    it { is_expected.to have_many(:images).dependent(:destroy) }
    it { is_expected.to have_and_belong_to_many(:authors) }
  end
  describe 'ActiveRecord validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:price) }
  end

  describe 'ActiveRecord scopes' do
    context 'scope :bestsellers' do
      it 'returns correct sorted books' do
        create_list(:order, 12, :with_given_book, book: book3)
        create_list(:order, 10, :with_given_book, book: book4, status: :in_queue)
        create_list(:order, 7, :with_given_book, book: book2, status: :in_queue)
        create_list(:order, 3, :with_given_book, book: book1, status: :in_queue)

        expect([book4, book2, book1, book3]).to eq(Book.bestsellers(4))
      end
    end
    context 'select_sort scope' do
      it 'sorts by newest' do
        expect([book4, book3, book2, book1]).to eq(Book.select_sort("newest"))
      end

      it 'sorts by popular' do
        expect([book1, book2, book3, book4]).to eq(Book.select_sort("popular"))
      end

      it 'sorts by lowprice' do
        expect([book2, book4, book1, book3]).to eq(Book.select_sort("lowprice"))
      end

      it 'sorts by highprice' do
        expect([book3, book1, book4, book2]).to eq(Book.select_sort("highprice"))
      end
    end

    context 'select_category' do
      it 'selects needed category' do
        expect([book1, book4]).to match_array(Book.select_category(category[0]))
      end
    end
  end
end
