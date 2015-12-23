Given(/^the following order has been added to the database$/) do |table|
  table.hashes.each do |order|
    # Each returned user will be a hash representing one row of the user_table
    # The keys will be the table headers and the values will be the row contents.
    # Entries can be directly to the database with ActiveRecord methods
    # Add the necessary Active Record call(s) to populate the database.
    o = Order.new(order)
    o.save(:validate => false)
  end
end

Given (/^I am on my user information page$/) do
    visit user_path(User.find(1))
end

When (/^I click on Write Review link$/) do
    click_link 'Write review'
end

Then (/^I should go to the new review page$/) do
    visit new_food_item_food_review_path(:food_item_id=>1)
end

When (/^I fill in the form with rating 5 and comments a and click save$/) do
    find("option[value='5']").click
    fill_in "Comment", :with=>'a'
    click_button "Save"
end

Then (/^I should be redirected to the food item page$/) do
    visit food_item_path(FoodItem.find(1))
end

When (/^I click to see all the reviews of the food item$/) do
    click_link "See All Reviews"
end

Then (/^I should be redirected to the index page$/) do
    visit food_item_food_reviews_path(:food_item_id=>1)
end