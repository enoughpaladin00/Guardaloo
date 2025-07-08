require "rails_helper"

RSpec.describe "Registrazione utente", type: :system, js: true do
  include Rails.application.routes.url_helpers
  include Capybara::DSL
  include ActionView::Helpers::TranslationHelper # se usi I18n

  it "permette a un utente di registrarsi con successo" do
    visit root_path
    find(".auth-tab.register-button").click
    expect(page).to have_selector("#register-form-page", visible: true)

    email = "utente_#{SecureRandom.hex(4)}@example.com"

    within "#register-form-page" do
      all("input[placeholder='Nome']").first.fill_in(with: "Mario")
      all("input[placeholder='Cognome']").first.fill_in(with: "Rossi")
      fill_in "Data di nascita", with: "1990-01-01"
      fill_in "Username", with: "mariorossi#{rand(1000)}"
      fill_in "Email", with: email
      fill_in "Password", with: "password123"
      fill_in "Conferma Password", with: "password123"
      click_button "Registrati"
    end

    # In caso di errore, mostra la pagina per il debug
    if page.current_path == root_path
      save_and_open_page
    end

    expect(page).to have_current_path(home_path, wait: 10)
  end
end
