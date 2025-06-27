require 'rails_helper'
RSpec.describe 'Login con Google', type: :system do
  before do
    driven_by(:selenium_chrome_headless) # usa :rack_test se vuoi senza JS, ma per OAuth serve JS o browser reale
    mock_auth_google
  end

  it 'permette all’utente di effettuare il login tramite Google' do
    visit root_path

    click_link 'Accedi con Google'

    expect(page).to have_current_path('/home')
    expect(page).to have_content('Accesso effettuato con Google')
  end
end
