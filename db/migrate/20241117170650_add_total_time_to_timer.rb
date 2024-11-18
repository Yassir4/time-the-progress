class AddTotalTimeToTimer < ActiveRecord::Migration[8.0]
  def change
    add_column :timers, :total_time, :float
  end
end
