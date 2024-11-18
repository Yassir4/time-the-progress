class User < ApplicationRecord
  validates :email_address, uniqueness: true

  has_many :learnings
  has_many :works
  has_many :timers

  has_secure_password

  has_secure_token :token, length: 80


  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
