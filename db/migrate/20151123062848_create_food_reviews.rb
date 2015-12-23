class CreateFoodReviews < ActiveRecord::Migration
  def change
    create_table :food_reviews do |t|
      t.integer :rating
      t.text :comment

      t.timestamps null: false
    end
  end
end
