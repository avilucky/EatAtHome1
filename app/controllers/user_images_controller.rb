require 'fileutils'
require 'aws-sdk'
class UserImagesController < ApplicationController
  
  def self.extension_white_list
    %w(.jpg .jpeg .gif .png .JPG)
  end
  
  def self.valid_extension(name)
    extension_white_list.each do |ext|
      if name.end_with?(ext)
        return true
      end
    end
    return false
  end
  
  before_filter :assert_login, :only => [:destroy, :create, :new]
  
  before_action :set_user_image, only: [:show, :destroy]
  
  def user_image_params
    params.require(:user_images).permit(:user_id, :img)
  end

  # GET /user_images/new
  def new
    @user = User.find(params[:user_id])
    @user_image = @user.user_images.build
  end

  # POST /user_images
  # POST /user_images.json
  def create
    @user= User.find(params[:user_id])
    p = user_image_params
    img = p[:img]
    if (!UserImagesController.valid_extension(img.original_filename))
      flash[:notice] = "The given file does not appear to be a valid image."
      redirect_to new_user_user_image_path(@user)
      return
    end
    p.delete(:img)
    @user_image= @user.user_images.build(p)
    if @user_image.save
        obj = S3_BUCKET.objects[@user_image.id.to_s+"___"+img.original_filename]
        obj.write(img.read, acl: :public_read)
        @user_image.avatar = obj.public_url
        @user_image.save!
      flash[:notice] = 'Your photo was successfully created.'
    else
        flash[:notice] = 'Your image could not be created'
    end
    redirect_to user_path(@user)
  end

  # DELETE /food_images/1
  # DELETE /food_images/1.json
  def destroy
    @user= User.find(params[:user_id])
    @user_image.destroy
    flash[:notice] = 'Your photo was successfully deleted.'
    redirect_to user_path(@user)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_image
      @user_image = UserImage.find(params[:id])
    end
end
