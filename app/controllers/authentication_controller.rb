class AuthenticationController < ApplicationController
  include ActionController::HttpAuthentication::Basic::ControllerMethods

  def signin
    params = user_signin_params
    @user = User.find_by email_address: params[:email_address]
    if @user
      if @user&.authenticate(params[:password])
        @user.regenerate_token
        user_response and return
        return
      end
      render json: { errors: "wrong password or email" }, status: :unauthorized
    end
  end

  def signup
    @user = User.create(user_signup_params)
     if @user.valid?
      @user.regenerate_token
      user_response and return
     else
      render json: { error: @user.errors }, status: :unauthorized
     end
  end

  private

  def user_signup_params
    params.require(:user).permit(:name, :password, :email_address)
  end

  def user_signin_params
    params.require(:user).permit(:password, :email_address)
  end

  def user_response
    render json: { user: @user }, except: [ :password_digest, :created_at, :updated_at ], status: 200
  end
end
