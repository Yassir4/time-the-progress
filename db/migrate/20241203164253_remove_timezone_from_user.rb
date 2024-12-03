class RemoveTimezoneFromUser < ActiveRecord::Migration[8.0]
  def change
    remove_column :users, :time_zone, :string
  end
end
