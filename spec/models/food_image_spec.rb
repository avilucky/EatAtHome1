require 'spec_helper'
require 'rails_helper'

describe FoodImage do
    describe "relative path" do
        it "returns path after images directory" do
            i = FoodImage.new(:avatar => "http://www.fake.com|fake")
            expect(i.relative_path).to eq("http://www.fake.com")
        end
    end
end