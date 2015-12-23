require 'spec_helper'
require 'rails_helper'

def test_food_item_hash
    hash = {}
    
    hash[:name] = "Pizza"
    hash[:category] = "Italian"
    hash[:portion] = {"0"=>"Portion123"}
    hash[:price] = {"0"=>"10.99"}
    hash[:avatar] = "image.jpg"
    hash[:user_id] = 101
    return hash
end

def test_user
    u = User.new(:first_name => 'a', :last_name => 'b', :password => 'c', :id => 101, :address_one => "hawkeye", :address_two => "court",
    :apt_num => "1234", :city => "Iowa City", :state => "IA", :zip => 50325)
    return u
end

def test_food_item
    fi = FoodItem.new(:name => 'a', :category => 'b', :description => 'c', :id => 1001)
    fi.food_item_portions.build(:portion => 'd', :price => 11.09, :id => 10001)
    fi.food_images.build(:avatar => 'http://abc.abc')
    return fi
end

describe FoodItemsController do
    before :each do
        @user = test_user
        @user.save(:validate => false)
        @food_item = test_food_item
        @food_item.save(:validate => false)
        @user.food_items << @food_item
        @user.save(:validate => false)
        @food_item.save(:validate => false)
        session[:user_id] = @user.id
    end
    after :each do
        DatabaseCleaner.clean
    end
    describe "validate food items path (create) happy path" do
        it 'should add food items to the DB' do
            hash = test_food_item_hash
            expect(User).to receive(:find).and_return(test_user)
            allow(User).to receive(:find_by_id).and_return(test_user)
            User.any_instance.stub(:address_is_valid).and_return(true) 
            post :create, {:food_items => hash}
            expect(flash[:notice].include?("was successfully created.")).to be_truthy
            expect(response).to redirect_to(user_path(test_user))
        end
    end
    describe "validate food items path (create) sad path, food_item validation fails" do
        it 'should add food items to the DB' do
            hash = test_food_item_hash
            hash[:name] = ''
            expect(User).to receive(:find).and_return(test_user)
            allow(User).to receive(:find_by_id).and_return(test_user)
            post :create, {:food_items => hash}
            expect(assigns(:errors) != nil).to be_truthy
            expect(response).to render_template('new')
        end
    end
    describe "validate food items path (create) sad path, food_item_portion validation fails" do
        it 'should add food items to the DB' do
            hash = test_food_item_hash
            hash[:portion] = {"0"=>""}
            expect(User).to receive(:find).and_return(test_user)
            allow(User).to receive(:find_by_id).and_return(test_user)
            User.any_instance.stub(:address_is_valid).and_return(true) 

            post :create, {:food_items => hash}
            expect(assigns(:errors) != nil).to be_truthy
            expect(response).to render_template('new')
        end
    end
    describe "validate food item path get (show template)" do
        render_views
        it 'should render show template' do
            allow(User).to receive(:find_by_id).and_return(test_user)
            expect(FoodItem).to receive(:find).and_return(@food_item)
            get :show, {:id => @food_item.id}
            expect(response).to render_template('show')
        end
    end
    describe "validate new food item path get (new template)" do
        render_views
        it 'should render new template' do
            allow(User).to receive(:find_by_id).and_return(test_user)
            get :new
            expect(response).to render_template('new')
        end
    end
    describe "validate edit food item path get (edit template)" do
        render_views
        it 'should render edit template' do
            allow(User).to receive(:find_by_id).and_return(test_user)
            allow(FoodItem).to receive(:find).and_return(@food_item)
            get :edit, {:id => @food_item.id}
            expect(response).to render_template('edit')
        end
    end
    describe "validate update food items path (update)" do
        it 'should update food items in the DB' do
            allow(User).to receive(:find_by_id).and_return(test_user)
            hash = test_food_item_hash
            hash[:name] = 'p'
            allow(FoodItem).to receive(:find).and_return(@food_item)
            put :update, {:id=> @food_item.id, :food_items => hash}
            expect(flash[:notice].include?("was successfully updated.")).to be_truthy
            expect(response).to redirect_to(food_item_path(@food_item))
        end
    end
    describe "validate food items path (update) sad path, food_item validation fails" do
        it 'should add food items to the DB' do
            hash = test_food_item_hash
            hash[:name] = ''
            allow(User).to receive(:find_by_id).and_return(test_user)
            allow(FoodItem).to receive(:find).and_return(@food_item)
            put :update, {:id=> @food_item.id, :food_items => hash}
            expect(assigns(:errors) != nil).to be_truthy
            expect(response).to render_template('edit')
        end
    end
    describe "validate food items path (update) sad path, food_item_portion validation fails" do
        it 'should add food items to the DB' do
            hash = test_food_item_hash
            hash[:portion] = {"0"=>""}
            allow(User).to receive(:find_by_id).and_return(test_user)
            allow(FoodItem).to receive(:find).and_return(@food_item)
            put :update, {:id=> @food_item.id, :food_items => hash}
            expect(assigns(:errors) != nil).to be_truthy
            expect(response).to render_template('edit')
        end
    end
    describe "validate delete food item path (delete)" do
        it 'should delete food item in the DB' do
            allow(User).to receive(:find_by_id).and_return(@user)
            allow(FoodItem).to receive(:find).and_return(@food_item)
            delete :destroy, {:id => @food_item.id}
            allow(FoodItem).to receive(:find).and_call_original
            expect(FoodItem.find_by_id(@food_item.id)).to eq(nil)
            expect(response).to redirect_to(user_path(test_user))
        end
    end
    describe "assert_matching_user" do
        it "should redirect home with a fake food item" do
            delete :destroy, {:id => 10102}
            expect(response).to redirect_to(root_path)
        end
        it "should redirect home if the user does not own it" do
            @user = User.new(:id => 1)
            @user.save(:validate => false)
            session[:user_id] = 1
            delete :destroy, {:id => @food_item.id}
            expect(response).to redirect_to(root_path)
            expect(flash[:notice]).to eq("You may only modify your own menu")
        end
        
    end
    describe "update_availability_only" do
        it "should update availability of the food item" do 
            put :update_availability_only, {:id => @food_item.id, :food_items => {:availability => false}}
            expect(!FoodItem.find(@food_item.id).availability).to be_truthy
        end
        it "should redirect to food item path" do
            put :update_availability_only, {:id => @food_item.id, :food_items => {:availability => false}}
            expect(response).to redirect_to(food_item_path(@food_item))
        end
        it "should return an error if unsuccessful" do
            allow(FoodItem).to receive(:find).and_return(@food_item)
            allow(@food_item).to receive(:update_attributes).and_return(false)
            put :update_availability_only, {:id => @food_item.id, :food_items => {:availability => false}}
            expect(flash[:notice]).to eq("Unable to update availability")
        end 
    end
    describe "index" do
        it "should call food item search with given params" do
            allow(Geocoder).to receive(:coordinates).and_return([1,1])
            params = {:name => "pizza", :location => "Iowa City"}
            expect(FoodItem).to receive(:search).with(params, [1,1]).and_return([])
            get :index, {:food_items => params}
        end
        it "should return an error with an invalid location" do
            allow(Geocoder).to receive(:coordinates).and_return(nil)
            params = {:name => "pizza", :location => "Iowa City"}
            get :index, {:food_items => params}
            expect(assigns(:errors)).to eq(["Location could not be found: please enter a valid address or city"])
        end
        it "should return no foods with an invalid location" do
            allow(Geocoder).to receive(:coordinates).and_return(nil)
            params = {:name => "pizza", :location => "Iowa City"}
            get :index, {:food_items => params}
            expect(assigns(:foods)).to eq([])
        end
    end
end