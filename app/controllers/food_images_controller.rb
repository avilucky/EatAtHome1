require 'fileutils'
require 'aws-sdk'
class FoodImagesController < ApplicationController
  
  def self.extension_white_list
    %w(.jpg .jpeg .gif .png .JPG)
  end
  # Ensures any uploaded image actually has an image suffix. This does not
  # protect against things like a user changing the extension, but it is a
  # good basic check
  def self.valid_extension(name)
    extension_white_list.each do |ext|
      if name.end_with?(ext)
        return true
      end
    end
    return false
  end
  before_filter :assert_login, :only => [:destroy, :create, :new]
  
  before_filter :assert_matching_user, :only =>[:new, :create, :destroy]
  
  #ensures that the logged in user is the one who owns the food being operated on
  def assert_matching_user
    items = []
    if FoodItem.find_by_id(params[:food_item_id])!=nil
      items << FoodItem.find_by_id(params[:food_item_id])
    end
    if FoodImage.find_by_id(params[:id])!=nil
      items << FoodImage.find_by_id(params[:id]).food_item
    end
    
    found = false
    items.each do |item|
      if !(item==nil)
        if !(item.user.id==@current_user.id)
          flash[:notice] = "You may only modify your own menu"
          redirect_to root_path
          return
        end
        found = true
      end
      
    end
    if !found
      flash[:notice] = "Sorry, that food could not be found."
      redirect_to root_path
      return
    end
  end
  
  before_action :set_food_image, only: [:show, :destroy]
  
  def food_image_params
    params.require(:food_images).permit(:food_item_id, :img)
  end

  # GET /food_images/new
  def new
    @food_item = FoodItem.find(params[:food_item_id])
    @food_image = @food_item.food_images.build
  end

  # POST /food_images
  # POST /food_images.json
  def create
    @food_item= FoodItem.find(params[:food_item_id])
    p = food_image_params
    img = p[:img]
    if (!FoodImagesController.valid_extension(img.original_filename))
      flash[:notice] = "The given file does not appear to be a valid image."
      redirect_to new_food_item_food_image_path(@food_item)
      return
    end
    p.delete(:img)
    @food_image= @food_item.food_images.build(p)
    if @food_image.save
        obj = S3_BUCKET.objects[@food_image.id.to_s+"___"+img.original_filename]
        obj.write(img.read, acl: :public_read)
        @food_image.avatar = obj.public_url
        @food_image.save!
      flash[:notice] = 'Food image was successfully created.'
    else
        flash[:notice] = 'Food image could not be created'
    end
    redirect_to food_item_path(@food_item)
  end

  # DELETE /food_images/1
  # DELETE /food_images/1.json
  def destroy
    @food_image.destroy
    flash[:notice] = 'Food image was successfully deleted.'
    redirect_to food_item_path(@food_image.food_item)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_food_image
      @food_image = FoodImage.find(params[:id])
    end
end
