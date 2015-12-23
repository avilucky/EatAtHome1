class FoodItem < ActiveRecord::Base
  
    belongs_to :user
    has_many :food_item_portions, dependent: :destroy
    has_many :food_images, dependent: :destroy
    has_many :food_reviews, dependent: :destroy
    
    accepts_nested_attributes_for :food_images
    
    SHORT_SIZE_LIMIT=100

    validates :name, :presence => true
    validates :category, :presence => true
    
    # Returns the description of this item truncated to 100 characters.
    # This is used for display on the search page, for example, where space
    # is limited.
    def short_description
        if self.description.size<SHORT_SIZE_LIMIT
            return self.description
        end
        return self.description[0,SHORT_SIZE_LIMIT]+"..."
    end
    
    # Returns a list of FoodItem records given a hash of values to search by
    # Any hash entries that are not present are simply not used as filters
    # The exception is location, which is required
    # Only available food items are shown
    def self.search(hash, coordinates)
        hash.default =""
        items = FoodItem.where(:availability => true).joins("JOIN users ON (food_items.user_id=users.id AND (users.availability OR users.availability='t'))")
        .joins("LEFT OUTER JOIN food_images ON food_images.food_item_id=food_items.id"
        ).where("name LIKE :name AND category LIKE :category AND (food_images.avatar IS NOT NULL OR :images!='1')",
        name: "%#{hash[:name]}%",
        category: "%#{hash[:category]}%",
        images: hash[:only_images].to_s).distinct
        finalItems = []
        items.each do |item|
            item.set_rating
            if ((!hash.has_key?(:radius) or (item.user.distance_from(coordinates) <= hash[:radius].to_i)) and (!hash.has_key?(:rating) or (item.rating >= hash[:rating].to_i)))
                finalItems << item
            end
        end
        return FoodItem.sortList finalItems,hash[:do_sort]
    end
    
    # Checks whether this item has any associated images.
    def has_image
        return self.food_images.size>0
    end
    
    def has_rating
        return (self.food_reviews!=nil and self.food_reviews.length > 0)
    end
    
    def rating
        @food_rating
    end
    
    # computes average rating out of 5. If the food has no reviews, 0.0 is the socre
    def set_rating
        food_reviews = self.food_reviews
        if self.has_rating
            totrating = 0
            food_reviews.each do |food_review|
                totrating = totrating + food_review.rating
            end
            avg_rating = totrating.to_f/food_reviews.length
            @food_rating = avg_rating.round(2)
            return
        end
        @food_rating = 0.0
    end
    
    def self.sortList food_items, do_sort
        if not do_sort.nil? and do_sort.to_s == "1" and not food_items.nil? and food_items.length > 0
            for i in 0..(food_items.length-2)
                for j in 1..(food_items.length-1)
                    if food_items[i].rating < food_items[j].rating
                        food_items[i], food_items[j] = food_items[j], food_items[i]
                    end
                end
            end 
        end
        return food_items
    end
end
