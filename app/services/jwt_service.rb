class JwtService
  SECRET_KEY = Rails.application.credentials.secret_key_base

  def self.encode(user_id)
    payload = {
      user_id: user_id,
      exp: 24.hour.from_now.to_i
    }

    JWT.encode(payload, SECRET_KEY)
  end

  def self.decode(token)
    JWT.decode(token, SECRET_KEY)[0]
  end

  def self.authorization(request)
    request.headers["Authorization"]
  end
end



# def encode_jwt(user_id)
#     payload = {
#       user_id: user_id,
#       exp: 24.hours.from_now.to_i
#     }

#     JWT.encode(payload, secret_key)
#   end

#   def secret_key
#     Rails.application.credentials.secret_key_base
#   end
