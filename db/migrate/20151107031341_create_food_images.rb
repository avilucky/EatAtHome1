class CreateFoodImages < ActiveRecord::Migration
  def change
    create_table :food_images do |t|
      t.integer :food_item_id
      t.string :avatar

      t.timestamps null: false
    end
  end
end
