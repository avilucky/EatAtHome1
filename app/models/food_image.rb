class FoodImage < ActiveRecord::Base
    belongs_to :food_item
    
    # returns the path to embed in an <img> tag to include this image,
    # which is computed based on the saved AWS path in the database
    def relative_path
        return self.avatar.match(/http[^|]*/)[0].to_s
    end
end
