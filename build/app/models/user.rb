class User < ApplicationRecord
    has_secure_password

    has_one_attached :avatar

    has_many :posts, dependent: :destroy
    has_many :comments, dependent: :destroy

    # Per i cinema preferiti
    has_many :cinema_favorites, dependent: :destroy
    has_many :favorite_cinemas_list, through: :cinema_favorites, source: :cinemasdef


    has_many :bookmarks, dependent: :destroy
    validates :email, presence: true, uniqueness: true
    validates :username, presence: true, uniqueness: true
    validates :first_name, :last_name, presence: true
    validates :birth_date, presence: true, unless: -> { provider.present? }
    validates :password, presence: true, length: { minimum: 6 }, on: :create
    validates :password, length: { minimum: 6 }, allow_nil: true, on: :update

    # Metodo per i film preferiti (alias di bookmarks)
    def favorite_movies
      bookmarks
    end

    def bookmarked?(tmdb_id)
      bookmarks.exists?(tmdb_id: tmdb_id)
    end

    def self.from_omniauth(auth)
      user = find_by(provider: auth["provider"], uid: auth["uid"])
      user ||= find_by(email: auth["info"]["email"])

      if user.nil?
        user = User.new(
          email: auth["info"]["email"],
          first_name: auth["info"]["first_name"],
          last_name: auth["info"]["last_name"],
          username: auth["info"]["email"].split("@").first,
          password: SecureRandom.hex(15)
        )
      end
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.save!
      user
    end

    # Ruoli disponibili
    ROLES = %w[user moderator admin]

    validates :role, inclusion: { in: ROLES }, allow_nil: true

    def admin?
      role == "admin"
    end

    def moderator?
      role == "moderator"
    end

    def user?
      role == "user"
    end
end
