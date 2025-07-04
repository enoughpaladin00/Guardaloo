class Movie < ApplicationRecord
  has_many :bookmarks, dependent: :destroy
  has_many :users, through: :bookmarks
end
