class User < ApplicationRecord
    has_secure_password
    
    has_one_attached :avatar #riga per aggiungere il supporto immagine

    validates :email, presence:true, uniqueness:true
    validates :username, presence: true, uniqueness: true
    validates :first_name, :last_name, :birth_date, presence: true
    validates :password, length: {minimum: 6}

    def self.from_omniauth(auth)
        find_or_create_by(email: auth['info']['email']) do |user|
            user.first_name = auth['info']['first_name']
            user.last_name = auth['info']['last_name']
            user.username = auth['info']['email'].split('@').first
            user.password = SecureRandom.hex(15)
        end           
    end
end