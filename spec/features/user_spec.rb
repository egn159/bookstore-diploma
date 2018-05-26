describe 'User test', type: :feature do
  let!(:user) { create(:user, email: 'tsets@ss.ss', password: '12345678q') }

  it 'signs me in' do
    login('tsets@ss.ss', '12345678q')
    expect(page).to have_content I18n.t('devise.sessions.signed_in')
    expect(page).to have_link I18n.t('pages.myaccount')
  end

  it 'signs me out' do
    login('tsets@ss.ss', '12345678q')
    first(:link, I18n.t('action.logout')).click
    expect(page).to have_content I18n.t('devise.sessions.signed_out')
  end

  it 'open forgot password page' do
    visit new_user_password_path
    expect(page).to have_content I18n.t('password.new.forgotpass')
    expect(page).to have_content I18n.t('password.new.howtoresetphrase')
  end

  it 'open sign up page' do
    visit new_user_registration_path
    expect(page).to have_content I18n.t('devise.registrations.new.have_an_account')
    expect(page).to have_content I18n.t('devise.registrations.new.sign_up')
  end
end
