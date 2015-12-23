class CreateUser < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :password_digest
      
      t.string :address_one
      t.string :address_two
      t.string :apt_num
      t.string :city
      t.string :state
      t.string :zip
      
      t.string :verification_code
      
    end
  end
end
