require 'jwt'

class JsonWebToken
  SECRET = ENV['JWT_SECRET']

  def self.encode(payload)
    raise StandardError.new("The payload must be a hash") unless payload.is_a?(Hash)

    JWT.encode(payload, SECRET, "HS256")
  end

  def self.decode(token)
    raise StandardError.new("The token must be a string") unless token.is_a?(String)

    JWT.decode(token, SECRET, true, { algorithm: "HS256" })
  end
end