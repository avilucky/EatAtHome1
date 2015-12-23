require 'spec_helper'
require 'rails_helper'

describe UserImagesController do
    
    before :each do
        @user = User.new({:id => 1})
        @user.save(:validate => false)
        session[:user_id] = 1
        @user_image = UserImage.new(:id =>1, :user_id => 1)
        @user_image.save(:validate => false)
    end

    describe "validate suffix" do
        it 'should validate user image suffixes' do
            expect(UserImagesController.valid_extension("test.png")).to be_truthy
            expect(UserImagesController.valid_extension("test.jpg")).to be_truthy
            expect(UserImagesController.valid_extension("test.jpeg")).to be_truthy
            expect(UserImagesController.valid_extension("test.gif")).to be_truthy
            expect(UserImagesController.valid_extension("test.JPG")).to be_truthy

        end
        it 'should not validate non-image suffixes' do
            expect(!UserImagesController.valid_extension("test.png.fake")).to be_truthy
            expect(!UserImagesController.valid_extension("test.no")).to be_truthy

            expect(!UserImagesController.valid_extension("test.jpegpng")).to be_truthy
            expect(!UserImagesController.valid_extension("tes")).to be_truthy
        end
    end
    
    describe "create" do
        before :each do
            allow_any_instance_of(AWS::S3::S3Object).to receive(:write)
            img = fixture_file_upload('files/no_image.jpg', 'image/jpg')
            @user_image_params= {:img => img}
        end
        it "should produce an error with an invalid filename" do
            allow(UserImagesController).to receive(:valid_extension).and_return(false)
            post :create, {:user_id => 1, :user_images => @user_image_params}
            expect(flash[:notice]).to eq("The given file does not appear to be a valid image.")
        end
        it "should indicate failure if the image could not be saved" do
            allow_any_instance_of(UserImage).to receive(:save).and_return(false)
            post :create, {:user_id => 1, :user_images => @user_image_params}
            expect(flash[:notice]).to eq("Your image could not be created")
        end
        it "should return success" do
            post :create, {:user_id => 1, :user_images => @user_image_params}
            expect(flash[:notice]).to eq("Your photo was successfully created.")
        end
    end
    describe "destroy" do
        it "should remove the user image from the database" do
            delete :destroy, {:user_id=>1, :id => 1}
            expect(UserImage.find_by_id(1)).to eq(nil)
        end
    end
    describe "new" do
        it "should set user " do
            get :new, {:user_id => 1}
            expect(assigns(:user)).to eq(User.find(1))
        end
    end
end