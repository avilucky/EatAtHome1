class FoodItemPortion < ActiveRecord::Base
    belongs_to :food_item
    has_many :orders, dependent: :destroy
    
    # below defines the regex to validate price of the portion
    AMOUNT_REGEX = /\A\d+(?:\.\d{0,2})?\z/
    validates :portion, :presence => true
    validates :price, :presence => true, :format => {:with => AMOUNT_REGEX}, :numericality => {:greater_than_or_equal_to => 0.0}
end
