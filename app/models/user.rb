class User < ApplicationRecord
  has_one :api_keys
  has_secure_password

  # TODO: add expiration
  generates_token_for :auth_token

  normalizes :email_address, with: ->(e) { e.strip.downcase }  
end
