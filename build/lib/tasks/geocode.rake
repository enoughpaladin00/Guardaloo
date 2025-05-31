namespace :geocode do
  desc "Geocode all cinemas"
  task cinemas: :environment do
    Cinema.where(latitude: nil, longitude: nil).find_each do |cinema|
      cinema.geocode
      cinema.save
      puts "Geocoded #{cinema.name}"
      sleep 0.1
    end
  end
end