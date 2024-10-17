class User < ApplicationRecord
  has_many :timers
  # has_many :learning, through: :timers
  has_secure_password

  # TODO: add expiration
  generates_token_for :auth_token

  normalizes :email_address, with: ->(e) { e.strip.downcase }  
end
