Geocoder.configure(
  timeout: 5,
  lookup: :google,
  api_key: ENV['GOOGLE_MAPS_API_KEY'],
  units: :km
)