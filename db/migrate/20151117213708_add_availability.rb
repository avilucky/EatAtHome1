class AddAvailability < ActiveRecord::Migration
  def change
    add_column :food_items, :availability, :boolean, :default => true
    add_column :users, :availability, :boolean, :default => true
  end
  def down
    drop_column :food_items, :availability
    drop_column :users, :uavailability
  end
end
