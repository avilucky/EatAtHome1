class FoodItemsController < ApplicationController

  before_filter :assert_login, :only => [:new, :create, :edit, :update, :destroy]
  before_filter :assert_matching_user, :only =>[:edit, :update, :destroy]
  
  def assert_matching_user
    item = FoodItem.find_by_id(params[:id])
    if item==nil 
      flash[:notice] = "Sorry, that food could not be found."
      redirect_to root_path
      return
    end
    if item.user.id!=@current_user.id
      flash[:notice] = "You may only modify your own menu"
      redirect_to root_path
    end
  end
  
  def food_item_params
    params.require(:food_items).permit(:name, :category, :description, :availability,
    :only_images, food_images_attributes:[:id,:post_id,:avatar]).tap do |whitelisted|
      whitelisted[:portion] = params[:food_items][:portion]
      whitelisted[:price] = params[:food_items][:price]
    end
  end

  def show
    @food_item = FoodItem.find(params[:id])
    @food_image = @food_item.food_images.all
  end
  
  def index
  end

  def new
    
    if @food_item_defaults==nil
      @food_item_defaults = {}
    end
    
    if @portion_defaults==nil
      @portion_defaults = {}
    end
    
    if @price_defaults==nil
      @price_defaults = {}
    end
    
    if @avatar_defaults == nil
      @avatar_defaults ={}
    end
    
  end
  
  def create
    user = User.find(session[:user_id])
    
    @food_item = user.food_items.build(:name => food_item_params[:name], :category => food_item_params[:category], 
                  :description => food_item_params[:description])
    
    @food_item.transaction do
      
      if @food_item.save
        
        food_item_params[:portion].keys.each do |portionKey|
          @food_item_portion = @food_item.food_item_portions.build(:portion => food_item_params[:portion][portionKey], 
                                :price => food_item_params[:price][portionKey])
          if not @food_item_portion.save
            @errors = @food_item_portion.errors.full_messages
            @food_item_defaults = food_item_params
            @portion_defaults = food_item_params[:portion]
            @price_defaults = food_item_params[:price]
            render 'new'
            raise ActiveRecord::Rollback
          end
        end
      else
        @errors = @food_item.errors.full_messages
        @food_item_defaults = food_item_params
        @portion_defaults = food_item_params[:portion]
        @price_defaults = food_item_params[:price]
        render 'new'
        raise ActiveRecord::Rollback
      end
      flash[:notice] = "#{@food_item.name} was successfully created."
      redirect_to user_path(get_current_user)
      return
    end
  end

  def edit
    @food_items = FoodItem.find(params[:id])
    
    if @food_item_defaults==nil
      @food_item_defaults = {}
    end
    
    if @portion_defaults==nil
      @portion_defaults = {}
    end
    
    if @price_defaults==nil
      @price_defaults = {}
    end
    
  end
  
  # simpler path that updates only whether a food item is available or not.
  def update_availability_only
    @food_item = FoodItem.find(params[:id])
     if @food_item.update_attributes(:availability => food_item_params[:availability])
          flash[:notice] = "Updated successfully"
      else
          flash[:notice] = "Unable to update availability"
     end
      redirect_to food_item_path(@food_item)

  end

  def update
    @food_item = FoodItem.find(params[:id])
    @food_item.name = food_item_params[:name] 
    @food_item.category = food_item_params[:category]
    @food_item.description = food_item_params[:description]
    
    @food_items = @food_item
    @food_item.transaction do
      
      if @food_item.save     
        
        @food_item.food_item_portions.destroy_all
        food_item_params[:portion].keys.each do |portionKey|
          @food_item_portion = @food_item.food_item_portions.build(:portion => food_item_params[:portion][portionKey], 
                                :price => food_item_params[:price][portionKey])
          if not @food_item_portion.save
            @errors = @food_item_portion.errors.full_messages
            @food_item_defaults = food_item_params
            @portion_defaults = food_item_params[:portion]
            @price_defaults = food_item_params[:price]
            render 'edit', :id => @food_item.id 
            raise ActiveRecord::Rollback
          end
        end
      else
        @errors = @food_item.errors.full_messages
        @food_item_defaults = food_item_params
        @portion_defaults = food_item_params[:portion]
        @price_defaults = food_item_params[:price]
        render 'edit', :id => @food_item.id
        raise ActiveRecord::Rollback
      end
      flash[:notice] = "#{@food_item.name} was successfully updated."
      redirect_to food_item_path(@food_item)
      return
    end
  end

  # Deletes both a food item and all associated protions
  def destroy
    @food_item = FoodItem.find(params[:id])
    food_item_name = @food_item.name
    @food_item.transaction do
      if not @food_item.food_item_portions.nil?
        @food_item.food_item_portions.destroy_all
      end
      @food_item.destroy!
      flash[:notice] = "#{food_item_name} was successfully deleted."
      redirect_to user_path(get_current_user)
    end
  end
  
  # This is the action associated with searching for food items. It requires
  # that some location be set, as we want to restrict users to searching in 
  # some geographical area. This is not necessary with a small dataset like ours,
  # but it would be critical in a real app that has many users.
  def index
    @defaults = {}
    if (params[:food_items]!=nil)
      @defaults = params[:food_items]
    end
    @coordinates = Geocoder.coordinates(@defaults["location"])
    if (not @coordinates)
      @errors = ["Location could not be found: please enter a valid address or city"]
      @foods = []
      return
    end
    @foods = FoodItem.search(@defaults, @coordinates)
  end
end
