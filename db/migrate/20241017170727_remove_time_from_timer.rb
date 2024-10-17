class RemoveTimeFromTimer < ActiveRecord::Migration[8.0]
  def change
    remove_column :timers, :time, :datetime
  end
end
