class CreateApiKeys < ActiveRecord::Migration[8.0]
  def change
    create_table :api_keys do |t|
      t.belongs_to :user, null: false
      t.string :bearer_type, null: false
      t.string :token, null: false
      t.timestamps null: false
    end

    add_index :api_keys, [:user_id, :bearer_type]
    add_index :api_keys, :token, unique: true
  end
end
