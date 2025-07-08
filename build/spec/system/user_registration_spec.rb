require 'rails_helper'

RSpec.describe "Registrations", type: :request do
  it "creates a user and returns a redirect_url" do
    post "/register", params: {
      user: {
        first_name: "Mario",
        last_name: "Rossi",
        birth_date: "1990-01-01",
        username: "mariorossi",
        email: "mario@example.com",
        password: "password123",
        password_confirmation: "password123"
      }
    }.to_json,
    headers: {
      "Content-Type" => "application/json",
      "ACCEPT" => "application/json"
    }

    expect(response).to have_http_status(:ok)
    json = JSON.parse(response.body)
    expect(json["success"]).to eq(true)
    expect(json["redirect_url"]).to eq("/home")
  end
end
