class AddAvatarToFoodItems < ActiveRecord::Migration
  def change
    add_column :food_items, :avatar, :string
  end
end
