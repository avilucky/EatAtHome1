Given(/^the following order have been added to the database$/) do |table|
  table.hashes.each do |order|
    # Each returned order will be a hash representing one row of the order_table
    # The keys will be the table headers and the values will be the row contents.
    # Entries can be directly to the database with ActiveRecord methods
    # Add the necessary Active Record call(s) to populate the database.
    o = Order.new(:quantity => order["quantity"], :status => order["status"], :price_per_portion => order["price_per_portion"], :food_item_portion_id => order["food_item_portion_id"], :customer_id => order["customer_id"], :seller_id => order["seller_id"])
    o.save
    @order_id = o.id
    
  end
end

Given /^I am on show order page$/ do
  visit order_path({:id=>@order_id})
 end
 
 When /^I click on Accept button$/ do
  click_button 'Accept Order'
 end
 
 When /^I click on Reject button$/ do
  click_button 'Reject Order'
 end
 
 When /^I order a food item with portion "(.*?)" and quantity "(.*?)"$/ do |portion, quantity|
  fill_in 'order[quantity]', :with => quantity
  select  portion, :from => 'order[food_item_portion]'
  click_button 'Place Order'
 end
 
 Given /^I am on user profile page$/ do
  visit user_path({:id => 1})
 end
 
 When(/^I clicked on the transaction tab$/) do
  page.find('#tabs-3').click
 end
 
 Then(/^I should see a listing for order number$/) do
    Order.all.each do |ord|
    expect(page).to have_content(ord.id)
 end
end 

Given /^I am on display order page$/ do
  visit order_path({:id=>@order_id})
 end
And(/^I should see the status to be pending$/) do
 expect(page).to have_content("pending")
end
When /^I click on Cancel button$/ do
  click_button 'Cancel Order'
 end

Given /^I am on user profile$/ do
  visit user_path({:id => 1})
 end
 
 When(/^I clicked on transaction tab$/) do
  page.find('#tabs-3').click
 end
 
 And(/^I clicked on More Info link$/)do
  click_link "More info"
 end
 Then(/^I should see details of order$/) do
    Order.all.each do |ord| 
    expect(page).to have_content(ord.status)
 end
end 