class FoodReview < ActiveRecord::Base
    belongs_to :user
    belongs_to :food_item
    
    validates :rating, :comment, presence: true
    # we rate on a scale of 1-5 stars
    validates :rating, numericality:{
        only_integer: true, 
        greater_than_or_equal_to: 1, 
        less_than_or_equal_to: 5,
        message: "can only be a whole number between 1 and 5"
    }
end
