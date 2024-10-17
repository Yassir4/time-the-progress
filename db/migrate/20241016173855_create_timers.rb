class CreateTimers < ActiveRecord::Migration[8.0]
  def change
    create_table :timers do |t|
      t.string :type
      t.datetime :time
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
