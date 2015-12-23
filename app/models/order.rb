class Order < ActiveRecord::Base
 
 enum status: [:pending, :accepted, :rejected, :cancelled]
 #belongs_to :user
 #has_many   :user
 belongs_to :customer, :class_name => 'User'
 belongs_to :seller, :class_name => 'User'
 belongs_to :food_item_portion
 AMOUNT_REGEX = /\A\d+(?:\.\d{0,2})?\z/
 QUANTITY_REGEX = /\A\d+\z/
 validates :price_per_portion, :presence => true, :format => {:with => AMOUNT_REGEX}, :numericality => {:greater_than_or_equal_to => 0.0}
 validates :quantity, :presence => true, :format => {:with => QUANTITY_REGEX}, :numericality => {:greater_than_or_equal_to => 1, :less_than => 100}
 validates :status, :presence => true
 validates :customer, :presence => true
 validates :seller, :presence => true
end