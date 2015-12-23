class CreateFoodItems < ActiveRecord::Migration
  def change
    create_table :food_items do |t|
      t.string :name
      t.string :category
      t.string :description
      t.references 'user'
    end
  end
end
