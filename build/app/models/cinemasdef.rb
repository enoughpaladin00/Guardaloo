class Cinemasdef < ApplicationRecord
  self.table_name = "cinemasdef"

  has_many :favorites, dependent: :destroy # All'eliminazione di un cinema, vengono eliminati anche i preferiti a esso associati
  has_many :favorited_by_users, through: :favorites, source: :user
end
