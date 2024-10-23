class TimerController < ApplicationController
  before_action :authenticate_user, only: [:create, :index]


  def index
    start_of_week = Date.today.at_beginning_of_week
    today = Date.today
    timers = @user.timers.where(created_at: start_of_week..Date.today.at_end_of_week).order(created_at: :asc)
    result = timers.group_by { |timer|
      timer.created_at.to_date
    } 
    render json: result.as_json(methods: :type), status: 200
  end

  def create
    type = timer_params[:type]
    if type == 'learning'
      Learning.create(user: @user)
      render json: {status: 200}
    else type == 'work'
      Work.create(user: @user)
      render json: {status: 200}
    end
  end

  private

  def timer_params
    params.permit(:type)
  end

end
