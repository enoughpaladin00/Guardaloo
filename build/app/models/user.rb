class User < ApplicationRecord

    has_secure_password
    
    has_one_attached :avatar #riga per aggiungere il supporto immagine

    has_many :posts, dependent: :destroy
    has_many :comments, dependent: :destroy
    has_many :bookmarks, dependent: :destroy

    validates :email, presence:true, uniqueness:true
    validates :username, presence: true, uniqueness: true
    validates :first_name, :last_name, presence: true
    validates :birth_date, presence: true, unless: -> { provider.present? }
    validates :password, presence: true, length: { minimum: 6 }, on: :create
    validates :password, length: { minimum: 6 }, allow_nil: true, on: :update

    def bookmarked?(tmdb_id)
        bookmarks.exists?(tmdb_id: tmdb_id)
    end

    def self.from_omniauth(auth)
        user = find_by(provider: auth['provider'], uid: auth['uid'])
        user ||= find_by(email: auth['info']['email'])

        if user.nil?
            user = User.new(
                email: auth['info']['email'],
                first_name: auth['info']['first_name'],
                last_name: auth['info']['last_name'],
                username: auth['info']['email'].split('@').first,
                password: SecureRandom.hex(15)
            )
        end
        user.provider = auth['provider']
        user.uid = auth['uid']
        user.save!
        user
    end
end
