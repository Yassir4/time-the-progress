class TimerController < ApplicationController
  before_action :authenticate_user, only: [ :create, :index ]


  def index
    cursor = timer_params[:cursor].to_i || 0
    timers = @user.timers.where("created_at BETWEEN ? AND ?", get_week(cursor).first.beginning_of_day, get_week(cursor).last.end_of_day).order(created_at: :asc)
    result = {}
    if !timers.empty?
      result = timers.group_by { |timer|
        timer.created_at.to_date
      }
    end

    result = get_week(cursor).each_with_object({}) do |day, acc|
      current_day = day.to_date
      acc[current_day] = result[current_day] || []
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
    params.permit(:type, :cursor, :total_time, :time_zone)
  end

  def get_week(cursor = 0)
    start_of_week = Time.zone.now.in_time_zone(timer_params[:time_zone]).at_beginning_of_week - (cursor * 7).days
    days = []

    (0..6).each do |offset|
      days.push(start_of_week + offset.days)
    end
    days
  end

  def has_next_page(cursor = 0)
    if @user.timers.order(:created_at).empty?
      return false
    end
    get_week(cursor + 1).first >= @user.timers.order(:created_at).limit(1)&.first.created_at
  end

  def encode_intervals(intervals)
    ActiveSupport::JSON.encode(intervals)
  end

  def decode_intervals(intervals)
    ActiveSupport::JSON.decode(intervals || '[]')
  end
end
