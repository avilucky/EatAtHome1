class Follow < ActiveRecord::Base
   belongs_to :cook, :class_name => 'User'
   belongs_to :user, :class_name => 'User'
   validates :cook, :presence => true
   validates :user, :presence => true
   
   
end
