class CreateUserImages < ActiveRecord::Migration
  def change
    create_table :user_images do |t|
      t.integer :user_id
      t.string :avatar

      t.timestamps null: false
    end
  end
end
