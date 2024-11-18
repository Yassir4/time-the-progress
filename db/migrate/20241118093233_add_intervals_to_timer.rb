class AddIntervalsToTimer < ActiveRecord::Migration[8.0]
  def change
    add_column :timers, :intervals, :text
  end
end
