# Completed step definitions for basic features: add food item, update food item and delete food item

Given(/^the following food items have been added to the database$/) do |table|
  table.hashes.each do |food_item|
    # Each returned food_item will be a hash representing one row of the food_item_table
    # The keys will be the table headers and the values will be the row contents.
    # Entries can be directly to the database with ActiveRecord methods
    # Add the necessary Active Record call(s) to populate the database.
    fi = FoodItem.new(:name => food_item["name"], :category => food_item["category"], :description => food_item["description"], :user_id => food_item[:user_id])
    fi.save
    fip = fi.food_item_portions.build(:portion => food_item["portion"], :price => food_item["price"])
    fip.save
    @test_food_item_id = fi.id
    @test_food_item_portion_id = fip.id
  end
end

And(/^the following review has been added to the database$/) do |table|
  table.hashes.each do |review|
    # Each returned food_item will be a hash representing one row of the food_item_table
    # The keys will be the table headers and the values will be the row contents.
    # Entries can be directly to the database with ActiveRecord methods
    # Add the necessary Active Record call(s) to populate the database.
    fr = FoodReview.new(:user_id => review["user_id"], :food_item_id => review["food_item_id"], :rating => review["rating"], :comment => review["comment"])
    fr.save
    @test_rating = fr.id
  end
end

When(/^I click on the delete image button$/) do
  page.find(".image_delete").click
end

Given(/^the following food images have been added to the database$/) do |table|
 table.hashes.each do |food_image|
    # Each returned food_item will be a hash representing one row of the food_item_table
    # The keys will be the table headers and the values will be the row contents.
    # Entries can be directly to the database with ActiveRecord methods
    # Add the necessary Active Record call(s) to populate the database.
    fi = FoodImage.new(food_image)
    fi.save!
  end
end

Given /^I am on new food item page$/ do
  visit new_food_item_path
 end


 When /^I have added a food item with name "(.*?)", category "(.*?)", description "(.*?)", portion "(.*?)" and price "(.*?)"$/ do |name, category, descritption, portion, price|
  fill_in 'food_items_name', :with => name
  fill_in 'food_items_category', :with => category
  fill_in 'food_items_description', :with => descritption
  fill_in 'food_items_portion[0]', :with => portion
  fill_in 'food_items_price[0]', :with => price
  click_button 'Save'
 end
 
 Given /^I am on edit food item page$/ do
  visit "/food_items/#{@test_food_item_id}/edit"
 end

 When /^I have updated a food item with name "(.*?)", category "(.*?)", description "(.*?)", portion "(.*?)" and price "(.*?)"$/ do |name, category, descritption, portion, price|
  fill_in 'food_items_name', :with => name
  fill_in 'food_items_category', :with => category
  fill_in 'food_items_description', :with => descritption
  fill_in 'food_items_portion[0]', :with => portion
  fill_in 'food_items_price[0]', :with => price
  click_button 'Update Food Item'
 end

 Given /^I am on show food item page$/ do
  visit "/food_items/#{@test_food_item_id}"
 end

 When /^I click on delete button$/ do
  click_button 'Delete'
 end
 
When(/^I click on the availability button$/) do
  click_button 'toggle_avail'
end
 
Given(/^I am on the search food item page$/) do
  visit food_items_path
end

When(/^I enter the term "(.*?)" into the food "(.*?)" field$/) do |term, field|
  fill_in 'food_items_'+field, :with => term
end

When(/^I click on the food item search button$/) do
  click_button 'Search'
end

def expectFindItem(food_name, truth) 
  found = false
  all(".food_detail_name").each do |row|
     if (row.has_content?(food_name))
         found = true
         break
     end
   end
   if (truth)
     expect(found).to be_truthy
   else
       expect(!found).to be_truthy
   end
end

Then(/^I should see a listing for "(.*?)"$/) do |food_name|
    expectFindItem(food_name, true)
end

Then(/^I should not see a listing for "(.*?)"$/) do |food_name|
  expectFindItem(food_name, false)
end

Then(/^I should see all the food items$/) do
  FoodItem.all.each do |food|
      expect(page).to have_content(food.name)
  end
end

When(/^I click on the food images filter$/) do
  check('food_items_only_images')
end


Given(/^I am on add image page for food "(.*?)"$/) do |id|
  visit new_food_item_food_image_path(FoodItem.find(id.to_i))
end

When(/^I add the image file at "(.*?)"$/) do |img|
  attach_file('food_images_img', File.absolute_path(img))
end

When(/^I click on the add image button$/) do
  click_button "Save"
end

When(/^I select "(.*?)" rating in rating criteria$/) do |rating_selection|
  select rating_selection, :from => 'food_items_rating'
end

When(/^I check Sort by Rating$/) do
  check 'food_items_do_sort'
end

Then(/^I should see listing for "(.*?)" before "(.*?)"$/) do |food_name1, food_name2|
  found = false
  all(".food_detail_name").each do |row|
     if (found and row.has_content?(food_name2))
         found = true
         break
     end
     if (row.has_content?(food_name1))
         found = true
     end
  end
  expect(found).to be_truthy
end

Then /^(?:|I )should see a message "([^"]*)"$/ do |text|
    expect(page).to have_content(text)
end