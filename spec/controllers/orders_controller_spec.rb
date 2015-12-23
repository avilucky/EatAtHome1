require 'spec_helper'
require 'rails_helper'

def test_order_hash
    hash = {}
    
    hash[:food_item_portion] = 1
    hash[:quantity] = 20
    return hash
end

def test_user_hash
    hash = {}
    for key in [:first_name, :last_name, :email, :password, :address_one, 
    :address_two, :apt_num, :city, :state, :zip] do
        hash[key] = 'a'
    end
    hash[:last_name] = 'b'
    hash[:password] = 'c'
    hash[:email] = "test@email.com"
    hash[:zip] = '50325'
    return hash
end

def test_user_seller
    u = User.new(test_user_hash)
    return u
end

def test_user_buyer
    hash = test_user_hash
    hash[:email] = "other@email.com"
    u = User.new(hash)
    return u
end

def test_order
    o = Order.new(:quantity => 2, :status => "pending")
    return o
end

def test_food_item
    fi = FoodItem.new(:name => 'a', :category => 'b', :description => 'c')
    fi.food_images.build(:avatar => 'a')
    return fi
end

def test_food_item_portion
    fip = FoodItemPortion.new(:portion => 'd', :price => 11.09)
    return fip;
end

describe OrdersController do
    before :each do
        @userb = test_user_buyer
        @userb.save
        @user = test_user_seller
        @food_item = test_food_item
        @food_item_portion = test_food_item_portion
        @food_item.food_item_portions << @food_item_portion
        @food_item.save
        @food_item_portion.save
        @user.food_items << @food_item
        @user.save
        @food_item.save
        @food_item_portion.save
        @order = test_order
        @user.orders_as_seller << @order
        @userb.orders_as_customer << @order
        @food_item_portion.orders << @order
        @order.price_per_portion = @food_item_portion.price
        @order.save
        session[:user_id] = @userb.id
    end
    after :each do
        DatabaseCleaner.clean
    end
    describe "validate order path (create) happy path" do
        it 'should order food item and data to the DB' do
            hash = test_order_hash
            expect(FoodItemPortion).to receive(:find).and_return(@food_item_portion)
            allow(User).to receive(:find_by_id).and_return(@userb)
            allow(UserMailer).to receive(:send_order_details).and_return(nil)
            post :order, {:order => hash}
            expect(flash[:notice].include?("Order placed successfully")).to be_truthy
            expect(response).to render_template('orders/show')
        end
    end
    describe "validate order path (create) sad path, quantity validation fails" do
        it 'should display the error message for quantity' do
            hash = test_order_hash
            expect(FoodItemPortion).to receive(:find).and_return(@food_item_portion)
            allow(User).to receive(:find_by_id).and_return(@userb)
            hash[:quantity] = ''
            post :order, {:order => hash}
            expect(assigns(:errors) != nil).to be_truthy
            expect(response).to render_template('food_items/show')
        end
    end
    describe "order food" do
        it "should display an error message for unavailable items" do
            hash = test_order_hash
            allow(FoodItemPortion).to receive(:find).and_return(@food_item_portion)
            @food_item_portion.food_item.availability = false
            @food_item_portion.food_item.save(:validate => false)
            allow(User).to receive(:find_by_id).and_return(@userb)
            hash[:quantity] = ''
            post :order, {:order => hash}
            expect(flash[:notice]).to eq("Sorry, this item is current unavailable")
        end
    end
    describe "validate change status happy path" do
        it 'should update status to cancelled' do
            expect(Order).to receive(:find).and_return(@order)
            allow(User).to receive(:find_by_id).and_return(@userb)
            post :change_status, {:id=>@order.id,:status=>"cancelled"}
            expect(flash[:notice].include?("Order cancelled")).to be_truthy
            expect(response).to redirect_to(order_path(@order))
        end
        it 'should update status to accepted' do
            @order.update_attributes(:status => "pending")
            expect(Order).to receive(:find).and_return(@order)
            allow(User).to receive(:find_by_id).and_return(@user)
            session[:user_id] = @user.id
            post :change_status, {:id=>@order.id,:status=>"accepted"}
            expect(flash[:notice].include?("Order accepted")).to be_truthy
            expect(response).to redirect_to(order_path(@order))
        end
        it 'should update status to rejected' do
            @order.update_attributes(:status => "pending")
            expect(Order).to receive(:find).and_return(@order)
            allow(User).to receive(:find_by_id).and_return(@user)
            session[:user_id] = @user.id
            post :change_status, {:id=>@order.id,:status=>"rejected"}
            expect(flash[:notice].include?("Order rejected")).to be_truthy
            expect(response).to redirect_to(order_path(@order))
        end
    end
    describe "validate change status sad path" do
        it 'should not update status and throw error that status not pending' do
            @order.update_attributes(:status => "accepted")
            expect(Order).to receive(:find).and_return(@order)
            allow(User).to receive(:find_by_id).and_return(@user)
            session[:user_id] = @user.id
            post :change_status, {:id=>@order.id,:status=>"rejected"}
            expect(flash[:notice].include?("Order not in pending state.")).to be_truthy
            expect(response).to redirect_to(order_path(@order))
        end
    end
    describe "validate order path get (show template)" do
        render_views
        it 'should render show template' do
            allow(User).to receive(:find_by_id).and_return(@userb)
            expect(Order).to receive(:find).and_return(@order)
            get :show, {:id => @order.id}
            expect(response).to render_template('show')
        end
    end
end
