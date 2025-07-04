require 'rails_helper'

RSpec.describe "User registration", type: :system do
  before do
    driven_by(:firefox_headless)
  end

  it "permits a user to register successfully" do
    visit root_path

    find('.register-button', match: :first).click

    within '#register-form-page' do
      fill_in 'Nome', with: 'Mario'
      fill_in 'Cognome', with: 'Rossi'
      fill_in 'Data di nascita', with: '1990-01-01'
      fill_in 'Username', with: 'mariorossi'
      fill_in 'Email', with: 'mario.rossi@example.com'
      fill_in 'Password', with: 'password123'
      fill_in 'Conferma Password', with: 'password123'
      click_button 'Registrati'
    end

    expect(page).to have_current_path('/home', wait:10)
    expect(page).to have_content('Prossimamente al cinema')
  end
end
