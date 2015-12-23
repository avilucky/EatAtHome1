class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.references :customer
      t.references :seller
      t.references 'food_item_portion'
      t.decimal  :price_per_portion
      t.integer  :quantity
      t.column   :status, :integer, default: 0, null: false
      t.datetime :accepted_time
 
    
    end
  end
end
