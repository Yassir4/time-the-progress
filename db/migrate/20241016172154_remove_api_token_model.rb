class RemoveApiTokenModel < ActiveRecord::Migration[8.0]
  def change
    drop_table :api_keys
  end
end
