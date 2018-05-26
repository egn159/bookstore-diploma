describe 'reviews', type: :feature do
  let(:review) { attributes_for(:review) }

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
      create(:user, email: 'tsets@ss.ss', password: '12345678q')
      login('tsets@ss.ss', '12345678q')
      visit book_path(@book)
    end

    it 'doesn\'t see that you must be logged in' do
      expect(page).not_to have_content I18n.t('users.mustlogin')
    end

    it 'cannot post invalid review' do
      fill_in 'review[title]', with: review[:title]
      fill_in 'review[text]', with: ''
      find('input[name=commit][value=Post]').click
      expect(page).to have_content I18n.t('reviews.createfail')
    end

    it 'post a review' do
      fill_in 'review[title]', with: review[:title]
      fill_in 'review[text]', with: review[:text]
      find('input[name=commit][value=Post]').click
      expect(page).to have_content I18n.t('reviews.createsuccess')
    end
  end
end
