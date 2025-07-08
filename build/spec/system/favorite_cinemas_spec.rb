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
      town: 'Città Test',
      province: 'Prov Test',
      phone: '1234567890',
      tamburino_id: 1,
      lat: 41.9,
      lon: 12.5
    )
  end

  it "permits a logged-in user to add/remove a cinema favorite" do
    visit login_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'password123'
    click_button 'Accedi'
    expect(page).to have_content 'Logout'

    visit cinemas_path

    # Mock geolocalizzazione subito dopo il visit
    page.execute_script(<<~JS)
      navigator.geolocation.getCurrentPosition = function(success) {
        success({ coords: { latitude: 41.9, longitude: 12.5 } });
      };
    JS

    expect(page).to have_content cinema_to_favorite.name

    within first('div.cinema-card') do
      # Inizialmente non è nei preferiti
      expect(page).to have_css 'span.favorite-icon i.far.fa-bookmark'
      find('span.favorite-icon').click
      expect(page).to have_css 'span.favorite-icon i.fas.fa-bookmark'
    end

    user.reload
    expect(user.favorite_cinemas_list).to include cinema_to_favorite

    within first('div.cinema-card') do
      find('span.favorite-icon').click
      expect(page).to have_css 'span.favorite-icon i.far.fa-bookmark'
    end

    user.reload
    expect(user.favorite_cinemas_list).not_to include cinema_to_favorite
  end
end
