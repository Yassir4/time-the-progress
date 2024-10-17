class TimerController < ApplicationController
  before_action :authenticate_user, only: [:create]
  
  def create
    type = timer_params[:type]
    if type == 'learning'
      Learning.create(user: @user)
      render status: :created
    else type == 'work'
      Work.create(user: @user)
      render status: :created
    end
  end

  private

  def timer_params
    params.permit(:type)
  end

end
