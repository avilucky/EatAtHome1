class User < ActiveRecord::Base
    has_secure_password
    
    ZIP_REGEX = /\A[0-9]{5}\z/
    EMAIL_REGEX = /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/
    validates :first_name, :presence => true
    validates :last_name, :presence => true
    validates :email, :presence => true, :format => {:with => EMAIL_REGEX}, :uniqueness => {case_sensitive:false}
    validates :address_one, :presence => true
    validates :city, :presence => true
    validates :state, :presence => true
    validates :zip, :presence => true, :format => {:with => ZIP_REGEX}
    
    validate :address_is_valid
    
    def address_is_valid
        @coordinates = Geocoder.coordinates(full_address)
        if not @coordinates
            errors.add(:address, "Sorry, this address to not seem to be valid: please double check it")
        end
    end
    
    #save coordinates for a user based on their address
    geocoded_by :full_address
    after_validation :geocode
    
    reverse_geocoded_by :latitude, :longitude

    # concatenation of first and last name. If either is nil, just returns
    # the other alone
    def full_name
        if (last_name==nil)
            return first_name
        end
        if (first_name==nil)
            return last_name
        end
        return first_name + " " + last_name
    end
    
    # Returns the users full address as a string
    def full_address
        addr = self.address_one
        if (self.apt_num)
            addr+= (" "+self.apt_num)
        end
        if (self.address_two) 
            addr+="\n"
            addr+=self.address_two
        end
        addr+="\n"
        addr+=self.city+", "+self.state+", "+self.zip
    end
    
    # Generates and also saves a password reset token for this user
    def generate_password_reset_token!
        update_attribute(:password_reset_token, SecureRandom.urlsafe_base64)
    end
    
    # Determines whether this user has an associated profile picture
    def has_image
        return self.user_images.size>0
    end
    
    def following?(ouser)
        self.following.include?(ouser)
    end
 
    
    has_many :food_items, dependent: :destroy
    has_many :orders_as_customer, :class_name => 'Order', :foreign_key => 'customer_id', dependent: :destroy
    has_many :orders_as_seller, :class_name => 'Order', :foreign_key => 'seller_id', dependent: :destroy
    has_many :food_reviews, dependent: :destroy
    has_many :user_images, dependent: :destroy
    has_many :follows, :class_name => 'Follow', :foreign_key => "user_id", dependent: :destroy
    has_many :followers,:through => :follows, source: :user
    has_many :following,:through => :follows, source: :cook
    
end
