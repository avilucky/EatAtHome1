require 'states'
class UsersController < ApplicationController
    

    before_filter :set_current_user
    
    before_filter :assert_login, :only => [:destroy, :update, :update_form]


   def user_params
      params.require(:user).permit(:first_name, :availability, :last_name,:address_one, 
       :address_two, :apt_num, :city, :state, :zip)
   end
    
   def destroy
        @user = User.find_by_id(params[:id]) 
        @user.destroy
        flash[:notice] = "User Account Deleted."
        redirect_to root_path
   end
    
   def show
        id = params[:id] 
        @user = User.find(id)
        
   end

   def update
     @user = get_current_user
     @states = StatesHelper.states
     if @user.update_attributes(user_params)
          flash[:notice] = "Updated successfully"
          redirect_to user_path(@current_user)
      else
          @errors = @user.errors.full_messages
          render 'update_form'
     end
   end
    
   def update_form
      @user = get_current_user
      @states = StatesHelper.states
   end
   
   def follow
       id = params[:id]
       @user = User.find(id)
       if @user == @current_user
           flash[:notice] = "Cannot follow yourself"
           redirect_to food_item_path(params[:food_id])
       else
           @follow = Follow.create(:cook_id=> @user.id, :user_id=> @current_user.id)
           @follow.save
           flash[:notice] = "You followed #{@user.full_name}"
           redirect_to food_item_path(params[:food_id])
       end
       return
   end
   
   def unfollow
       id = params[:id]
       @user = User.find(id)
       follow = Follow.find_by(:cook => @user, :user => @current_user)
       if not follow.nil?
           follow.destroy
       end
       flash[:notice] = "You unfollowed #{@user.full_name}"
       if not params[:food_id].nil?
        redirect_to food_item_path(params[:food_id])
       else
        redirect_to root_path
       end
       return
   end
    
end