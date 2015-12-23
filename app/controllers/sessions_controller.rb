require 'states'
class SessionsController < ApplicationController

  def session_params
    params.require(:sessions).permit(:first_name, :last_name, :email, :password, :password_confirm, :address_one, 
    :address_two, :apt_num, :city, :state, :zip)
  end
  
  # returns a string error message if there is an error, or nil
  # if there is no error
  def self.validate_signup_params(param_hash)
    if param_hash[:password]!=param_hash[:password_confirm]
      return "The passwords do not match. Please double check and try again"
    end
    return nil
  end

  def new
    # default: render 'new' template
  end

  def login_form
    if get_current_user!=nil
      redirect_to root_path
    end
  end
  
  def signup_form
    @defaults = flash[:signup_defaults]
    if @defaults==nil
      @defaults = {}
    end
    @states = StatesHelper.states
  end
  
  def signup
    valid = SessionsController.validate_signup_params(session_params)
    if (valid!=nil) 
      flash[:notice] = valid
      flash[:signup_defaults] = session_params
      redirect_to signup_form_path
      return
    end
    s = session_params
    s[:verification_code] = SecureRandom.urlsafe_base64()
    s.delete("password_confirm")
    u = User.new(s)
    if u.save
      url = request.base_url+"/signup_confirm?id="+s[:verification_code]
      UserMailer.send_welcome(u, url)
      flash[:notice] = "You have successfully signed up! Please check your email for a message from us to confirm your account"
      redirect_to root_path
    else
      @errors = u.errors.full_messages
      @defaults = session_params
      @states = StatesHelper.states
      render 'signup_form'
    end
  end
  
  def signup_confirm
    code = params[:id]
    u = User.find_by_verification_code(code)
    if u==nil
      flash[:notice] = "Unknown user verification code. Please confirm that you have visited the URL sent in your welcome email"
    else
      u.verification_code = nil
      u.save!
      flash[:notice] = "Your email address has been confirmed! You may now login."
    end

    redirect_to root_path
  end

  def login
    user = User.find_by_email(session_params[:email])
    if !user or !user.authenticate(session_params[:password])	
      flash[:notice] = "Email / password combination is not valid"
      redirect_to login_form_path
      return
    end
    if user.verification_code!=nil
      flash[:notice] = "Your email address has not been confirmed. Please follow the instructions in the welcome email you received to activate your account."
      redirect_to root_path
      return
    end
    flash[:notice] = "Welcome "+user.full_name
    session[:user_id] = user.id
    redirect_to root_path
  end
  
  def destroy
    session.delete(:user_id)
    redirect_to root_path
  end

end
