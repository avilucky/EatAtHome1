require "rails_helper"

RSpec.describe FoodImagesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/food_images").to route_to("food_images#index")
    end

    it "routes to #new" do
      expect(:get => "/food_images/new").to route_to("food_images#new")
    end

    it "routes to #show" do
      expect(:get => "/food_images/1").to route_to("food_images#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/food_images/1/edit").to route_to("food_images#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/food_images").to route_to("food_images#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/food_images/1").to route_to("food_images#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/food_images/1").to route_to("food_images#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/food_images/1").to route_to("food_images#destroy", :id => "1")
    end

  end
end
