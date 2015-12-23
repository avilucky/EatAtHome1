class UserImage < ActiveRecord::Base
    belongs_to :user
    
    def relative_path
        return self.avatar.match(/http[^|]*/)[0].to_s
    end
end
