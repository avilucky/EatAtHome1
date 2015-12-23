require 'spec_helper'
require 'rails_helper'

describe FoodImagesController do
    before :each do
        @user = User.new({:id => 1})
        @user.save(:validate => false)
        session[:user_id] = 1
        @food_item = FoodItem.new({:id => 1, :user_id => 1})
        @food_item.save(:validate => false)
        @food_image = FoodImage.new(:id =>1, :food_item_id => 1)
        @food_image.save(:validate => false)
    end
    describe "assert matching user" do
        it "should redirect home with an invalid food item" do
            post :create, {:food_item_id => 10}
            expect(response).to redirect_to(root_path)
        end
        it "should redirect home with an invalid image" do
            delete :destroy, {:id => 10}
            expect(response).to redirect_to(root_path)
        end
        it "should say not found with an invalid food item" do
            post :create, {:food_item_id => 10}
            expect(flash[:notice]).to eq("Sorry, that food could not be found.")
        end
        describe "user is not owner" do
            before :each do
                @user = User.new({:id => 2})
                @user.save(:validate => false)
                session[:user_id] = 2
            end
            it "should redirect home" do
                post :create, {:food_item_id => 1}
                expect(response).to redirect_to(root_path)
            end
            it "should say invalid permissions" do
                post :create, {:food_item_id => 1}
                expect(flash[:notice]).to eq("You may only modify your own menu")
            end
        end
        
    end
    describe "validate suffix" do
        it 'should validate image suffixes' do
            expect(FoodImagesController.valid_extension("test.png")).to be_truthy
            expect(FoodImagesController.valid_extension("test.jpg")).to be_truthy

            expect(FoodImagesController.valid_extension("test.jpeg")).to be_truthy
            expect(FoodImagesController.valid_extension("test.gif")).to be_truthy

        end
        it 'should not validate non-image suffixes' do
            expect(!FoodImagesController.valid_extension("test.png.fake")).to be_truthy
            expect(!FoodImagesController.valid_extension("test.no")).to be_truthy

            expect(!FoodImagesController.valid_extension("test.jpegpng")).to be_truthy
            expect(!FoodImagesController.valid_extension("tes")).to be_truthy
        end
    end
    describe "create" do
        before :each do
            allow_any_instance_of(AWS::S3::S3Object).to receive(:write)
            img = fixture_file_upload('files/no_image.jpg', 'image/jpg')
            @food_image_params = {:img => img}
        end
        it "should produce an error with an invalid filename" do
            allow(FoodImagesController).to receive(:valid_extension).and_return(false)
            post :create, {:food_item_id => 1, :food_images => @food_image_params}
            expect(flash[:notice]).to eq("The given file does not appear to be a valid image.")
        end
        it "should indicate failure if the image could not be saved" do
            allow_any_instance_of(FoodImage).to receive(:save).and_return(false)
            post :create, {:food_item_id => 1, :food_images => @food_image_params}
            expect(flash[:notice]).to eq("Food image could not be created")
        end
        it "should return success" do
            post :create, {:food_item_id => 1, :food_images => @food_image_params}
            expect(flash[:notice]).to eq("Food image was successfully created.")
        end
    end
    describe "destroy" do
        it "should remove the food image from the database" do
            delete :destroy, {:id => 1}
            expect(FoodImage.find_by_id(1)).to eq(nil)
        end
    end
    describe "new" do
        it "should set food item" do
            get :new, {:food_item_id => 1}
            expect(assigns(:food_item)).to eq(FoodItem.find(1))
        end
    end
end