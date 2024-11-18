class TimerController < ApplicationController
  before_action :authenticate_user, only: [ :create, :index ]


  def index
    cursor = timer_params[:cursor].to_i || 0

    timers = @user.timers.where("created_at BETWEEN ? AND ?", get_week(cursor).first.beginning_of_day, get_week(cursor).last.end_of_day).order(created_at: :asc)

    result = timers.group_by { |timer|
      timer.created_at.to_date
    }

    result = get_week(cursor).each_with_object({}) do |day, acc|
      acc[day] = result[day] || []
    end

    render json: {
        timers: result.as_json(methods: :type),
        hasNextPage: has_next_page(cursor)
      }, status: 200
  end

  def create
    type = timer_params[:type]
    total_time = timer_params[:total_time] || 0

    if type == "learning"
      timer = @user.timers.where(type: 'Learning', created_at: Date.today.all_day).first
      if timer.nil?
        Learning.create(user: @user, total_time: total_time, intervals: encode_intervals([Time.now]))
      else
        decoded_intervals = decode_intervals(timer.intervals)

        encoded_intervals = encode_intervals(decoded_intervals.push(Time.now))
        timer.update(total_time: total_time, intervals: encoded_intervals)
      end
      render json: { status: 200 }
    else type == "work"
      timer = @user.timers.where(type: 'Work', created_at: Date.today.all_day).first
      if timer.nil?
        Work.create(user: @user, total_time: total_time, intervals: encode_intervals([Time.now]))
      else
        decoded_intervals = decode_intervals(timer.intervals)

        encoded_intervals = encode_intervals(decoded_intervals.push(Time.now))
        timer.update(total_time: total_time, intervals: encoded_intervals)
      end
      render json: { status: 200 }
    end
  end

  def updated

  end
  private

  def timer_params
    params.permit(:type, :cursor, :total_time)
  end

  def get_week(cursor = 0)
    start_of_week = Date.today.at_beginning_of_week - (cursor * 7)
    end_of_week = Date.today.at_end_of_week - (cursor * 7)
    (start_of_week..end_of_week).to_a
  end

  def has_next_page(cursor = 0)
    get_week(cursor + 1).first >= @user.timers.order(:created_at).limit(1).first.created_at
  end

  def encode_intervals(intervals)
    ActiveSupport::JSON.encode(intervals)
  end

  def decode_intervals(intervals)
    puts'-----------'
    puts intervals
    ActiveSupport::JSON.decode(intervals || '[]')
  end
end
