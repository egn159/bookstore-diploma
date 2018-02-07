describe "reviews", :type => :feature do
  before :each do
    @book = create(:book)
  end

  context 'unlogged user' do
    it 'see that you must be logged in' do
      visit book_path(@book)
      expect(page).to have_content I18n.t('users.mustlogin')
    end
  end

  context 'logged in user' do
    before :each do
      create(:user, email: "tsets@ss.ss", password: "12345678q")
      login("tsets@ss.ss", "12345678q")
      visit book_path(@book)
    end

    it 'doesn\'t see that you must be logged in' do
      expect(page).not_to have_content I18n.t('users.mustlogin')
    end

    it 'post a review' do
      fill_in 'review[title]', with: 'MyTest'
      fill_in 'review[text]', with: 'Lorem ipsum dolor sit amet'
      page.select '5', :from => 'review[rating]'
      find('input[name=commit][value=Post]').click
      expect(page).to have_content I18n.t('reviews.createsuccess')
    end
  end

end
