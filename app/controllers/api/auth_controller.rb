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
    user = User.find_by(username: params[:username])
    if user&.authenticate(params[:password])
      render json: { message: "Succesfully Login", user: { id: user.id, username: user.username } }, status: :ok
    else
      render json: { error: "Invalid credential!" }, status: :unauthorized
    end
  end
end
