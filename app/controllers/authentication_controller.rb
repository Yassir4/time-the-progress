class AuthenticationController < ApplicationController
  include ActionController::HttpAuthentication::Basic::ControllerMethods
  
  def signin
    authenticate_with_http_basic do |email, password| 
      @user = User.find_by email_address: email 

      if @user&.authenticate(password) 
        token = @user.generate_token_for(:auth_token)
        @user.update(token: token)
        render json: {user: @user}, status: :created and return
      end
    end
    render status: :unauthorized
  end
  
  def signup
    @user = User.create(user_params)
     if @user.valid? 
      token = @user.generate_token_for(:auth_token)
      @user.update(token: token)
      render json: {user: @user}, status: :created and return
     else
      render json: {error: 'not valid'}, status: :unauthorized
     end
   end
   
   private

   def user_params
     params.require(:user).permit(:name, :password, :email_address)
   end

  # def delete

  # end

end