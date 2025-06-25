
class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :cinemasdef

  validates :user_id, uniqueness: { scope: :cinemasdef_id, message: "Il cinema è già nei preferiti!" }
end