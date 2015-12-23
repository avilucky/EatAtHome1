require 'mail'
class UserMailer
  def self.configure
    options = { :address              => "smtp.gmail.com",
            :port                 => 587,
            :user_name            => 'EatAtHome.NoReply@gmail.com',
            :password             => '4iodasdf3',
            :authentication       => 'plain',
            :enable_starttls_auto => true  }



    Mail.defaults do
        delivery_method :smtp, options
    end
  end
  
  def self.send_welcome(user, url)
      UserMailer.configure
      Mail.deliver do
        to user.email
        from 'EatAtHome.NoReply@gmail.com'
        subject 'Welcome to EatAtHome '+user.first_name+'! Please Confirm Your Email Address.'
        body 'Welcome to EatAtHome'+user.first_name+'! To confirm your email address, please click on the link below.
        
        '+url+'
        
        Once you have confirmed your address, you will be able to begin using the site.'
    end
  end
  
  def self.send_order_details(food_item, url)
      UserMailer.configure
      Mail.deliver do
        to food_item.user.email
        from 'EatAtHome.NoReply@gmail.com'
        subject 'Order for '+food_item.name+' has been placed'
        body 'Hello'+food_item.user.first_name+', To accept/reject the order, please click on the link below.
        
        '+url+'
        
        Regards,
        Eat At Home'
      end
  end
  
  def self.password_reset(user, url)
    
    UserMailer.configure
    Mail.deliver do 
      to user.email
      from 'EatAtHome.NoReply@gmail.com'
      subject  'Reset Your Password'
      body 'Hello ' + user.first_name + ', To reset your password, please click on the link below.
      
      '+url+'
      
      Regards,
      Eat At Home'
      
    end
  end

end