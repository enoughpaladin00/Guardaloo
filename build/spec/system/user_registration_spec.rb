require "rails_helper"

RSpec.describe "User registration", type: :system, js: true do
  it "registra un nuovo utente con successo dalla homepage" do
    visit root_path
    find('#register-popup-button').click

    within('#register-form-popup') do
      fill_in "user[first_name]", with: "Luca"
      fill_in "user[last_name]", with: "Bianchi"
      fill_in "user[birth_date]", with: "1995-05-01"
      fill_in "user[username]", with: "lucab"
      fill_in "user[email]", with: "luca@example.com"
      fill_in "user[password]", with: "password123"
      fill_in "user[password_confirmation]", with: "password123"
      click_button "Registrati"
    end

    expect(page).to have_current_path("/home", wait: 5)
    expect(page).to have_content(/prossimamente al cinema/i)
  end
end
