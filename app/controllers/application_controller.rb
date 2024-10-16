class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  def authenticate_user
    @user = authenticate_with_http_token do |token|
      User.find_by_token_for(:auth_token, token)
    end
    unless !!@user
      render json: { message: 'Please log in' }, status: :unauthorized
    end
  end

end
