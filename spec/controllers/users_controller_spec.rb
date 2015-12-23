require 'spec_helper'
require 'rails_helper'
require 'factory_girl'
require 'states'
def test_hash
    hash = {}
    for key in [:first_name, :last_name, :email, :password, :address_one, 
    :address_two, :apt_num, :city, :state, :zip] do
        hash[key] = 'a'
    end
    hash[:last_name] = 'b'
    hash[:password] = 'c'
    hash[:id] = 101
    hash[:email] = "test@email.com"
    hash[:zip] = '50325'
    return hash
end

def test_user
    u = User.new(:first_name => 'a', :last_name => 'b', :password => 'c', :id => 101)
    return u
end
def test_user_profile
    u = User.new(:first_name => 'a', :last_name =>'b',:address_one => 'c',:email => 'a@gmail.com',:password => 'd',:id => 102)
    return u
end

def follow_user
    f = Follow.new(:cook_id => test_user.id,:user_id => test_user_profile.id)
    return f
end

def test_follow_user_profile
    hash ={}
    
    hash[:cook] = 101
    hash[:user] = 102
    return hash
end

def test_food_item
    fi = FoodItem.new(:name => 'a', :category => 'b', :description => 'c', :id => 1001)
    fi.food_item_portions.build(:portion => 'd', :price => 11.09, :id => 10001)
    fi.food_images.build(:avatar => 'a')
    return fi
end


describe UsersController do
    describe "delete account" do
        
        before :each do
            @user=User.new({:password => "test"})
            @user.save(:validate => false)
            session[:user_id] = @user.id
            @user_profile = test_user_profile
        end
        after :each do
            DatabaseCleaner.clean
        end
        it "should destroy the user account from the database" do
            delete :destroy, {:id=> @user.to_param}
            expect(User.find_by_id(@user.id)==nil).to be_truthy
        end
        
        it "should redirect_to the home page" do
            delete :destroy, {:id=>@user.to_param}
            expect(response).to redirect_to(root_path)
        end
        
    end 
    
    describe "update form" do
        before :each do
            @user_profile = test_user_profile
            @user_profile.save(:validate => false)
            session[:user_id] = @user_profile.id
        end
        it "assigns a list of states to the states variable" do
            get :update_form, {}
            expect(assigns(:states)).to eq StatesHelper.states
        end
        it "assigns the user value in the field " do
            get :update_form, {}
            expect(response.body.should have_content(:first_name))
        end
    end

    describe "update" do
        before :each do
            @user_profile = test_user_profile
            @user_profile.save(:validate => false)
            session[:user_id] = @user_profile.id
        end
        after :each do
            DatabaseCleaner.clean
        end
        it 'should redirect to login if not logged in' do
            session.delete(:user_id)
            put :update, {:id => @user_profile.id,:user =>hash }
            expect(response).to redirect_to(login_form_path)
        end
        it 'should update user information in the DB' do
            allow(User).to receive(:find_by_id).and_return(@user_profile)
            hash = test_hash.except!(:id)
            hash[:last_name] = 'k'
            put :update, {:id => @user_profile.id,:user =>hash }
            expect(User.find_by_id(@user_profile.id).last_name).to eq('k')
        end
        it 'should show a success notification' do
            allow(User).to receive(:find_by_id).and_return(@user_profile)
            hash = test_hash.except!(:id)
            put :update, {:id => @user_profile.id,:user =>hash }
            expect(flash[:notice]).to eq("Updated successfully")
        end
        it "should set errors when the user is invalid" do
            profile = @user_profile
            profile.email = 'k'
            allow(User).to receive(:find_by_id).and_return(profile)
            hash = test_hash.except!(:id)
            put :update, {:id => @user_profile.id,:user =>hash }
            expect(assigns(:errors).length).to eq(1)
        end
    end
    describe "show" do
        before :each do
            @user= test_user_profile
            @user.save(:validate => false)
            session[:user_id] = @user.id
        end
        it 'should assign the user variable to the current user' do
            get :show, {:id => @user.id}
            expect(assigns(:user)).to eq(@user)
        end
    end
    
    describe "follow" do
        before :each do
            @cook = test_user
            @cook.save(:validate => false)
            @food_item = test_food_item
            @food_item.save(:validate => false)
            @cook.food_items << @food_item
            @cook.save(:validate => false)
            @food_item.save(:validate => false)
            session[:user_id] = @cook.id
            @buyer = test_user_profile
            @buyer.save(:validate => false)
            session[:user_id] = @buyer.id
        end
        after :each do
                DatabaseCleaner.clean
        end
        it 'should follow the cook' do
            hash = test_follow_user_profile
            allow(User).to receive(:find_by_id).and_return(@buyer)
            allow(User).to receive(:find).and_return(@cook)
            get :follow, {:id => @cook.id, :food_id => @food_item.id}
            expect(response).to redirect_to(food_item_path(@food_item.id))
        end
        it 'should not follow itself' do
            hash = test_follow_user_profile
            allow(User).to receive(:find_by_id).and_return(@cook)
            allow(User).to receive(:find).and_return(@cook)
            get :follow, {:id => @cook.id, :food_id => @food_item.id}
            expect(flash[:notice]).to eq("Cannot follow yourself")
            expect(response).to redirect_to(food_item_path(@food_item.id))
        end
    end
    describe "Unfollow" do
        before :each do
            @cook = test_user
            @cook.save(:validate => false)
            @food_item = test_food_item
            @food_item.save(:validate => false)
            @cook.food_items << @food_item
            @cook.save(:validate => false)
            @food_item.save(:validate => false)
            session[:user_id] = @cook.id
            @buyer = test_user_profile
            @buyer.save(:validate => false)
            session[:user_id] = @buyer.id
            @follow = follow_user
            @follow.save(:validate => false)
        end
        after :each do
                DatabaseCleaner.clean
        end
        it 'should unfollow the cook' do
            allow(User).to receive(:find_by_id).and_return(@buyer)
            allow(User).to receive(:find).and_return(@cook)
            get :unfollow, {:id => @cook.id, :food_id => @food_item.id}
            expect(response).to redirect_to(food_item_path(@food_item.id))
        end
        
        it 'should unfollow the cook in following tab' do
            allow(User).to receive(:find_by_id).and_return(@buyer)
            allow(User).to receive(:find).and_return(@cook)
            get :unfollow, {:id => @cook.id}
             expect(response).to redirect_to(root_path)
        end
            
    end
end