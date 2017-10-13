describe "Actions with order", :type => :feature do

  before :each do
    @book = FactoryGirl.create(:book)
    FactoryGirl.create(:user, email: "tsets@ss.ss", password: "12345678q")
    login("tsets@ss.ss", "12345678q")
    visit root_path
  end

  context 'adding item to cart' do
    it 'show message' do
      click_link 'Buy Now'
      expect(page).to have_content I18n.t('order_item.create_success')
    end

    context 'from book page' do
      before :each do
        visit book_path(@book)
      end

      it 'add item' do
        click_button "Add to Cart"
        expect(page).to have_content I18n.t('order_item.create_success')
      end

      it 'add 3 items' do
        myval = '3'
        find('form.egn_book_cart [name=quantity]').set(myval)
        click_button 'Add to Cart'
        expect(first('.container a.shop-link .shop-quantity').text).to eq myval
      end
    end
  end

  describe 'cart' do
    before :each do
      click_link 'Buy Now'
      FactoryGirl.create(:coupon, code: "testcoupon")
    end

    it 'change item quantity' do
      first('.container a.shop-link').click
      find('div.hidden-xs .input-group a.input-link:has(.fa.fa-plus)').click
      expect(find('div.hidden-xs input.quantity-input').value).to eq '2'
    end

    context 'coupon' do
      it "activate" do
        visit cart_page_path
        fill_in 'order[coupon_id]', with: 'testcoupon'
        click_button 'Update cart'
        expect(page).to have_content I18n.t('coupon.activatesuccess')
      end
    end
  end
end
