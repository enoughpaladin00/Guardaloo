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
end