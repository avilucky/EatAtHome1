class CreateFollows < ActiveRecord::Migration
  def change
    create_table :follows do |t|
      t.integer :user_id
      t.integer :cook_id
      t.timestamps null: false
    end
    add_foreign_key :follows, :users, column: :cook_id, primary_key: :id
    add_foreign_key :follows, :users, column: :user_id, primary_key: :id
    add_index :follows, [:cook_id, :user_id], unique: true
  end
end
