class CreateFoodItemPortions < ActiveRecord::Migration
  def change
    create_table :food_item_portions do |t|
      t.string :portion
      t.decimal :price, precision:10, scale:2  
      t.references 'food_item'
    end
  end
end
