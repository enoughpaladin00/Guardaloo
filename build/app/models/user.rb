class User < ApplicationRecord
    has_secure_password

    validates :email, presence:true, uniqueness:true
    validates :username, presence: true, uniqueness: true
    validates :first_name, :last_name, :birth_date, presence: true
    validates :password, length: {minimum: 6}

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