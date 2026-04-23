class Api::AuthController < ApplicationController
  def register
    user = User.new(username: params[:username], password: params[:password])
      if user.save
        render json: { message: "User created!" }, status: :created
      else
        render json: { error: user.errors.full_messages.to_sentence }, status: :unprocessable_entity
      end
  end

  def login
    user = User.authenticate_by(username: params[:username], password: params[:password])

    if user
      token = JwtService.encode(user.id)
      render json: { token: token }
    else
      render json: { error: "Invalid Credentials" }, status: :unauthorized
    end
  end

  def index
    authorization_header = JwtService.authorization(request)
    return render json: { error: "Missing Token" }, status: :unauthorized unless authorization_header

    token = authorization_header.split(" ").last
    begin
      decoded = JwtService.decode(token)
      @current_user_id = decoded["user_id"]

      if @current_user_id != 1
        return render json: { error: "Forbidden" }, status: :forbidden
      end

      users = User.select(:id, :username)
      render json: users, status: :ok

    rescue JWT::ExpiredSignature
      render json: { error: "Expired Session" }, status: :unauthorized
    rescue JWT::DecodeError
      render json: { error: "Invalid Token" }, status: :unauthorized

    end
  end
end
