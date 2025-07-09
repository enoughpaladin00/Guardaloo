# spec/system/favorite_cinemas_spec.rb
require 'rails_helper'

RSpec.describe "Favorite Cinemas", type: :system, js: true do
  let!(:user) do
    User.create!(
      first_name: 'Test',
      last_name: 'User',
      birth_date: '1990-01-01',
      username: 'testuser',
      email: 'test@example.com',
      password: 'password123',
      password_confirmation: 'password123'
    )
  end

  let!(:cinema_to_favorite) do
    Cinemasdef.create!(
      name: 'Cinema Test',
      address: 'Via Test 123',
      town: 'roma',
      province: 'roma',
      phone: '1234567890',
      tamburino_id: 1,
      lat: 41.9,
      lon: 12.5
    )
  end

  it "permits a logged-in user to add/remove a cinema from favorites and see it in favorites list" do
    # Login flow come da homepage
    visit root_path
    find('#login-popup-button').click

    within('#login-form-popup') do
      fill_in "email", with: user.email
      fill_in "password", with: "password123"
      click_button "Accedi"
    end

    expect(page).to have_current_path("/home", wait: 5)
    expect(page).to have_content("Prossimamente al Cinema")

    visit cinemas_path
    fill_in 'city-search', with: 'Roma'
    sleep 1
    click_button 'search-by-city-btn'


    expect(page).to have_content(cinema_to_favorite.name, wait: 5)


    within first('div.cinema-card') do
      expect(page).to have_css 'span.favorite-icon i.far.fa-bookmark'
      accept_alert do
        find('span.favorite-icon').click
      end
      expect(page).to have_css 'span.favorite-icon i.fas.fa-bookmark'
    end



    user.reload
    expect(user.favorite_cinemas_list).to include cinema_to_favorite

    within first('div.cinema-card') do
      accept_alert do
        find('span.favorite-icon').click
      end
      expect(page).to have_css 'span.favorite-icon i.far.fa-bookmark'
    end

    user.reload
    expect(user.favorite_cinemas_list).not_to include cinema_to_favorite
  end
end
