class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_filter :set_current_user
  
  # sets the current user variable to the user that is currently logged in, or
  # nil if nobody is logged in
  def set_current_user
    @current_user ||=session[:user_id] && User.find_by_id(session[:user_id])
  end
  
  # returns nil if nobody is logged in
  def get_current_user
    if (!session.has_key?(:user_id))
      return nil
    end
    return User.find_by_id(session[:user_id])
  end
  
  # before filter for ensuring only logged in users can access protected
  # resources
  def assert_login
    u = get_current_user
    if u==nil
      flash[:notice] = "Please log in to access this feature"
      redirect_to login_form_path
    end      
  end
end
