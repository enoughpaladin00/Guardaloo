class Cinema < ApplicationRecord
  geocoded_by :address
  after_validation :geocode, if: :address_changed?

  validates :name, presence: true, uniqueness: true
  validates :address, presence: true

  def self.find_or_geocode(cinema_data)
    cinema = find_by(name: cinema_data[:name])
    return cinema if cinema

    new_cinema = new(
      name: cinema_data[:name],
      address: cinema_data[:address]
    )
    new_cinema.geocode
    new_cinema.save if new_cinema.valid?
    new_cinema
  end


  def find_nearby_cinemas(lat, lng, radius_km = 100)
    Cinema.select(
      "cinemas.*, (
        6371 * acos(
          cos(radians(#{lat})) *
          cos(radians(latitude)) *
          cos(radians(longitude) - radians(#{lng})) +
          sin(radians(#{lat})) *
          sin(radians(latitude))
        )
      ) AS distance"
    )
    .having("distance < ?", radius_km)
    .order("distance")
    .limit(10)
  end
end
