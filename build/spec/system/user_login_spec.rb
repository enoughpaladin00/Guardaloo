require "rails_helper"

RSpec.describe "User login", type: :system do
  before do
    User.create!(
      first_name: "Mario",
      last_name: "Rossi",
      birth_date: "1990-01-01",
      username: "mariorossi",
      email: "mario@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
  end

  it "permette il login dalla homepage" do
    visit root_path
    find('#login-popup-button').click

    within('#login-form-popup') do
      fill_in "email", with: "mario@example.com"
      fill_in "password", with: "password123"
      click_button "Accedi"
    end

    expect(page).to have_current_path("/home", wait: 5)
    expect(page).to have_content(/prossimamente al cinema/i)
  end

  it "mostra un errore se le credenziali sono errate" do
    visit root_path
    find('#login-popup-button').click

    within('#login-form-popup') do
      fill_in "email", with: "wrong@wrong.com"
      fill_in "password", with: "wrong123"
      click_button "Accedi"
    end

    expect(page).to have_current_path("/", wait: 5)
    expect(page).to have_content(/email o password errati/i)
  end
end
