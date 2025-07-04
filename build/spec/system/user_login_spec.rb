require 'rails_helper'

RSpec.describe "User login", type: :system do
  let!(:user) do
    User.create!(
      first_name: 'Mario',
      last_name: 'Rossi',
      birth_date: '1990-01-01',
      username: 'mariorossi',
      email: 'mario.rossi@example.com',
      password: 'password123',
      password_confirmation: 'password123'
    )
  end

  before do
    driven_by(:firefox_headless)
  end

  it "permits a user to log in successfully" do
    visit root_path

    within '#login-form-page' do
      fill_in 'Email', with: 'mario.rossi@example.com'
      fill_in 'Password', with: 'password123'
      click_button 'Accedi'
    end

    expect(page).to have_current_path('/home', wait:10)
    expect(page).to have_content('Prossimamente al cinema')
  end

  it "shows an error with incorrect credentials" do
    visit root_path

    within '#login-form-page' do
      fill_in 'Email', with: 'mario.rossi@example.com'
      fill_in 'Password', with: 'wrongpassword'
      click_button 'Accedi'
    end

    expect(page).to have_current_path(root_path)
    expect(page).to have_content('Email o password errati', wait:5)
  end
end
