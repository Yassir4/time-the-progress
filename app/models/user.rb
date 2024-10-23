class User < ApplicationRecord
  has_many :learnings
  has_many :works
  has_many :timers

  has_secure_password

  generates_token_for :auth_token

  normalizes :email_address, with: ->(e) { e.strip.downcase }  
end
