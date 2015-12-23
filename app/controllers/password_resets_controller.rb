class PasswordResetsController < ApplicationController
    
    def new 
    end
    
    def create
        user=User.find_by(email: params[:email])
        if user
            if (user.verification_code!=nil)
                flash[:notice] = "You have not yet confirmed your account. Please do so before resetting your password."
                redirect_to(root_path)
                return
            end
            user.generate_password_reset_token!
            url= request.base_url + '/password_resets/' + user.password_reset_token + '/edit'
            UserMailer.password_reset(user, url)
            redirect_to root_path
            flash[:notice]="Password reset instructions sent! Please check your email."
        else
            flash.now[:notice]="Email not found"
            render action: 'new'
        end
    end
    
    def edit
        @user=User.find_by(password_reset_token: params[:id])
        if @user
        else
            flash[:notice] = "Password reset token not found."
            redirect_to root_path
        end
    end
    
    def update
        @user = User.find_by(password_reset_token: params[:id])
        if @user && @user.update_attributes(user_params)
            @user.update_attribute(:password_reset_token, nil)
            session[:user_id]=@user.id
            flash[:notice]="Password updated."
            redirect_to root_path
        else
            flash[:notice] = "Password reset token not found."
            redirect_to root_path
        end
    end
    
    private
    def user_params
        params.require(:user).permit(:password, :password_confirmation)
    end

end
