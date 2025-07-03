class Cinemasdef < ApplicationRecord
  self.table_name = "cinemasdef"

  has_many :cinema_favorites, dependent: :destroy
  has_many :favorited_by_users, through: :cinema_favorites, source: :user
end
