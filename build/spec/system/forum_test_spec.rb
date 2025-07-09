require "rails_helper"

RSpec.describe "Forum system", type: :system, js: true do
  let(:user) do
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

  def login_as(user)
    visit root_path
    find('#login-popup-button').click

    within('#login-form-popup') do
      fill_in "email", with: user.email
      fill_in "password", with: user.password
      click_button "Accedi"
    end

    expect(page).to have_current_path("/home", wait: 5)
  end

  it "permette a un utente loggato di creare un post e visualizzarlo" do
    login_as(user)


    find(".profile_logo").hover
    find('#forum').click

    click_on "Scrivi un nuovo Post"

    fill_in "Titolo", with: "Titolo di prova"
    find('#Contenuto').set('Testo del mio nuovo post')
    find("#movie_title_input").set("Titanic")
    sleep 2
    all('.movie-suggestion-item', minimum: 1).first.click

    click_button "Pubblica"

    expect(page).to have_content("Titolo di prova")
  end
end
