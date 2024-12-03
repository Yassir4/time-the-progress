second_work_round_time_diff_hours = 1
learning_round_time_diff_hours = 2

# User.create(email_address: 'yassir@mail.com', password: '123456', name: 'yassir')

def encode_intervals(intervals)
  ActiveSupport::JSON.encode(intervals)
end

def decode_intervals(intervals)
  ActiveSupport::JSON.decode(intervals || '[]')
end

time = Time.now
1.times do |i|
  User.first.works.create(created_at: time, intervals: '[]', total_time: 0)

  90.times do |j|
    timer = User.first.works.first
    decoded_intervals = decode_intervals(timer.intervals).push(time + j.minutes)
    timer.update(total_time: j * 60, intervals: encode_intervals(decoded_intervals))
  end
  time += 90.minutes
  
  time += 40.minutes
  90.times do |l|
    timer = User.first.works.first
    decoded_intervals = decode_intervals(timer.intervals).push(time + l.minutes)
    timer.update(total_time: l * 60, intervals: encode_intervals(decoded_intervals))
  end
  time += 90.minutes

  time += 50.minutes
  90.times do |l|
    timer = User.first.works.first
    decoded_intervals = decode_intervals(timer.intervals).push(time + l.minutes)
    timer.update(total_time: l * 60, intervals: encode_intervals(decoded_intervals))
  end
  time += 90.minutes

  time += 120.minutes
  User.first.learnings.create(created_at: time, intervals: '[]', total_time: 0)
  240.times do |d|
    timer = User.first.learnings.first
    decoded_intervals = decode_intervals(timer.intervals).push(time + d.minutes)
    timer.update(total_time: d * 60, intervals: encode_intervals(decoded_intervals))
  end
end