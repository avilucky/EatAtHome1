class AlterOrders < ActiveRecord::Migration
  def change
    add_foreign_key :orders, :users, column: :customer_id, primary_key: :id
    add_foreign_key :orders, :users, column: :seller_id, primary_key: :id
  end
end