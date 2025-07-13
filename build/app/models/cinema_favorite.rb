class CinemaFavorite < ApplicationRecord
  belongs_to :user
  belongs_to :cinemasdef
  validates :cinemasdef_id, uniqueness: {scope: :user_id, message: "Questo cinema è già tra i preferiti"}
end
