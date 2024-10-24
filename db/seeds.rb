second_work_round_time_diff_hours = 1
learning_round_time_diff_hours = 2

time = Time.now
User.create(email_address: 'yassor@mail.com', password: '123456', name: 'yassir')
7.times do |i|
  newTime = time + i.day

  90.times do |j|
    User.first.works.create(created_at: newTime + j.minutes)
  end
  newTime += 90.minutes

  90.times do |l|
    User.first.works.create(created_at: newTime + second_work_round_time_diff_hours.hours + l.minutes)
  end

  newTime += 90.minutes
  240.times do |d|
    User.first.learnings.create(created_at: newTime + learning_round_time_diff_hours.hours + d.minutes)
  end
end