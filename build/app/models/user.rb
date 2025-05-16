class User < ApplicationRecord
    has_secure_password

    validates :email, presence:true, uniqueness:true
    validates :username, presence: true, uniqueness: true
    validates :first_name, :last_name, :birth_date, presence: true
    validates :password, length: {minimum: 6}
end