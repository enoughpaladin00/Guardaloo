class Bookmark < ApplicationRecord
  belongs_to :user
  validates :tmdb_id, presence: true
end
