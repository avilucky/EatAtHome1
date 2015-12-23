class AddUserIdToFoodReviews < ActiveRecord::Migration
  def change
    add_column :food_reviews, :user_id, :integer
  end
end
