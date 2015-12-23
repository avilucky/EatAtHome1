class RemoveAvatarFromFoodItems < ActiveRecord::Migration
  def change
    remove_column :food_items, :avatar, :string
  end
end
