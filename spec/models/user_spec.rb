require 'spec_helper'
require 'rails_helper'

describe User do
    describe "full name" do
        it "should be a concatenation of first and last name" do 
            u = User.new({:first_name => "test", :last_name => "user"})
            expect(u.full_name).to eq("test user")
        end
        it "should return the first name if the last name is nil" do
            u = User.new({:first_name => "test"})
            expect(u.full_name).to eq("test")
        end
        it "should return the last name if the last name is nil" do
            u = User.new({:last_name => "test"})
            expect(u.full_name).to eq("test")
        end
    end
    describe "validate address" do
        it "should return an error with an invalid address" do
            expect(Geocoder).to receive(:coordinates).and_return(nil)
            u = User.new()
            allow(u).to receive(:full_address).and_return("")
            u.address_is_valid
            expect(u.errors.empty?).to eq(false)
        end
        it "should not return an error with a valid address" do
            expect(Geocoder).to receive(:coordinates).and_return([1,1])
            u = User.new()
            allow(u).to receive(:full_address).and_return("")
            u.address_is_valid
            expect(u.errors.empty?).to eq(true)
        end
    end
    describe "full address" do
        it "should return the full address" do
            u = User.new({:address_one => "hawkeye", :address_two => "court", :apt_num => "123", :city => "iowa city", "state" => "IA", :zip => "50325"})
            expect(u.full_address).to eq("hawkeye 123\ncourt\niowa city, IA, 50325")
        end
        it "should exclude address_two if not present" do
            u = User.new({:address_one => "hawkeye", :apt_num => "123", :city => "iowa city", "state" => "IA", :zip => "50325"})
            expect(u.full_address).to eq("hawkeye 123\niowa city, IA, 50325")
        end
    end
    
    describe "#generate_password_reset_token!" do
        let!(:user) {create(:user)}
        it "changes the password_reset_token attribute" do
            expect{user.generate_password_reset_token!}.to change{user.password_reset_token}
        end
    end
    describe "has_image" do
        it "returns false with no images" do 
            u = User.new()
            expect(u.has_image).to eq(false)
        end
        it "returns true with some image" do
            u = User.new()
            u.user_images << UserImage.new()
            expect(u.has_image).to eq(true)
        end
    end
end