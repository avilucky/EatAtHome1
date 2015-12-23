require 'spec_helper'
require 'rails_helper'

def test_food_item
    fi = FoodItem.new(:name => 'a', :category => 'b', :description => 'c')
    return fi
end

def str_gt_short_size
    characters = ('a'..'z').to_a + ('A'..'Z').to_a
    # Prior to 1.9, use .choice, not .sample
    return (0..150).map{characters.sample}.join
end

describe FoodItem do
    describe "validate short_description return" do
        it 'should return the same size short description if description is within SHORT_SIZE_LIMIT' do
            food_item_t = test_food_item
            expect(food_item_t.short_description).to eq('c')
        end
        it 'should return the short description (ShortSizeLimit length) if description is not within SHORT_SIZE_LIMIT' do
            food_item_t = test_food_item
            short_desc = str_gt_short_size
            food_item_t.description = short_desc
            expect(food_item_t.short_description).to eq(short_desc[0,100]+"...")
        end
    end
    describe "has images" do
        before :each do
            @food = FoodItem.new(:name => 'a', :category => 'b', :description => 'c', :user_id => 1)
            
        end
        it "should return false with no images" do
            expect(!@food.has_image).to be_truthy
        end
        it "should return true with images" do
            @food.food_images << FoodImage.new()
            expect(@food.has_image).to be_truthy
        end
    end
    describe "search" do
        before :each do
            @users = [User.new(:city => "Iowa City", :id => 1), User.new(:city => "Coralville", :id => 2)]
            @users.each do |u|
                u.save(:validate => false)
            end
            
            @foods = [
                FoodItem.new(:name => 'a', :category => 'b', :description => 'c', :user_id => 1),
                FoodItem.new(:name => 'd', :category => 'e', :description => 'f', :user_id => 2)]
            
            @foods.each do |f|
                f.save(:validate => false)
            end
            @img = FoodImage.new(:food_item_id => 1, :avatar => "test")
            @img.save
            
        end
        it 'returns all foods with an empty hash' do
            foods = FoodItem.search({}, [])
            expect(foods.length).to eq(@foods.length)
        end
        it 'does not return unavailable items' do
            FoodItem.all.each do |f|
                f.availability = false
                f.save!(:validate => false)
            end
            foods = FoodItem.search({}, [])
            expect(foods.length).to eq(0)
        end
        it 'does not return items from unavailable users' do
            User.all.each do |u|
                u.availability = false
                u.save!(:validate => false)
            end
            
            foods = FoodItem.search({}, [])
            expect(foods.length).to eq(0)
        end
        it 'filters all foods by name' do
            foods = FoodItem.search({:name => 'a'}, [])
            expect(foods.length).to eq(1)
            foods.each do |f|
                expect(f.name).to eq('a')
            end
        end
        it 'filters all foods by category' do
            foods = FoodItem.search({:category => 'b'}, [])
            expect(foods.length).to eq(1)
            foods.each do |f|
                expect(f.category).to eq('b')
            end
        end
        it 'filters out all foods by distance' do
            User.any_instance.stub(:distance_from).and_return(20) 
            foods = FoodItem.search({:city => 'Iowa City', :radius => 10}, [])
            expect(foods.length).to eq(0)
        end
        it 'does not filter close foods' do
            User.any_instance.stub(:distance_from).and_return(5) 
            foods = FoodItem.search({:city => 'Iowa City', :radius => 10}, [])
            
            expect(foods.length).to eq(2)
        end
        it 'should filter foods by images' do
            foods = FoodItem.search({:only_images => '1'}, [])
            expect(foods.length).to eq(1)
            foods.each do |f|
                expect(f.has_image).to be_truthy
            end
        end
    end
    describe "rating" do
        before :each do
            @food = FoodItem.new(:name => 'a', :category => 'b', :description => 'c', :user_id => 1)
        end
        it "should return 0.0 as rating for a food item with no ratings" do
            @food.set_rating
            expect(@food.rating).to eq(0.0)
        end
        it "should return true with images" do
            @food_review = @food.food_reviews.build(:rating => 3, :comment => "k", :user_id => 1)
            @food.set_rating
            expect(@food.rating).to be > 0.0
        end
    end
    describe "sort by rating" do
        before :each do
            @food = FoodItem.new(:name => 'a', :category => 'b', :description => 'c', :user_id => 1)
        end
        it "should return the only element that is passed to the method" do
            send_food_items = Array.new
            send_food_items << @food
            food_items = FoodItem.sortList send_food_items,0
            expect(food_items[0]).to eq(@food)
            expect(food_items.length).to eq(1)
        end
        it "should sort the list in correct order" do
            @food1 = FoodItem.new(:name => 'a', :category => 'b', :description => 'c', :user_id => 1)
            @food2 = FoodItem.new(:name => 'a', :category => 'b', :description => 'c', :user_id => 1)
            @food_review = @food.food_reviews.build(:rating => 3, :comment => "k", :user_id => 1)
            @food_review1 = @food1.food_reviews.build(:rating => 4, :comment => "k", :user_id => 1)
            @food_review2 = @food2.food_reviews.build(:rating => 5, :comment => "k", :user_id => 1)
            send_food_items = Array.new
            send_food_items << @food
            send_food_items << @food2
            send_food_items << @food1
            @food.set_rating
            @food1.set_rating
            @food2.set_rating
            food_items = FoodItem.sortList send_food_items,1
            expect(food_items[0]).to eq(@food2)
            expect(food_items[1]).to eq(@food1)
            expect(food_items[2]).to eq(@food)
            expect(food_items.length).to eq(3)
        end
    end
end