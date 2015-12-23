class AddFoodItemIdtoFoodReviews < ActiveRecord::Migration
  def change
     add_column :food_reviews, :food_item_id, :integer
  end
end
