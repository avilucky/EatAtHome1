# completed acceptance definiations for deleting user account
Capybara.use_default_driver
World(Capybara::Email::DSL)

Given(/^the following follow table have been added to the database$/) do |table|
  table.hashes.each do |follow|
    # Each returned user will be a hash representing one row of the user_table
    # The keys will be the table headers and the values will be the row contents.
    # Entries can be directly to the database with ActiveRecord methods
    # Add the necessary Active Record call(s) to populate the database.
    f = Follow.new(follow)
    f.save(:validate => false)
  end
end

Given /^I am on my user update information page$/ do 
  visit update_form_path
end

When /^I have cliked on the delete button$/ do
    click_link 'Delete My Account'
    sleep 1 # make sure there is enough time for the javascript to process the dialog
end
 
# here there is an error connecting to the selenium-webdriver, expect this all the test passes 
And /^I confirmed the browser dialog$/ do
    #bypass_confirm_dialog
    true
end

Then /^My account has been deleted$/ do
    expect(User.find_by_email('a')).to eq nil
end
  
And /^I should go back to home page$/ do
    visit root_path
end

Given /^I am on the EatAtHome update form Page "a"$/ do 
  visit update_form_path
end
When(/^I have entered the first name "(.*?)", last name "(.*?)", address "(.*?)", city "(.*?)", state "(.*?)", and zip "(.*?)"$/) do |fname, lname, addr, city, state, zip|
  fill_in 'user_first_name', :with => fname
  fill_in 'user_last_name', :with => lname
  fill_in 'user_address_one', :with => addr
  fill_in 'user_city', :with => city
  fill_in 'user_zip', :with => zip
  select state, from: "user_state"
end

And(/^I have clicked on the update button$/) do
  click_button 'Update'
end

Then(/^I should see a confirmation message for user page$/) do
    expect(page).to have_content("Updated successfully")
end

Given(/^I am on show user page for user with email "(.*?)"$/) do |email|
  visit user_path(User.find_by_email(email))
end

#let!(:user) {create(:user)}

Given(/^I am on the login page and clicked forget password link$/) do
  visit login_form_path
  click_link "Forget Your Password"
end

When(/^I fill in the email text field with email "(.*?)" and click reset password button$/) do |email|
  fill_in "Email", with: email
  click_button "Reset Password"
  sleep(10)
end
  
Given(/^I am on food details page$/) do
  visit food_item_path(FoodItem.find(1))
end

When(/^I click on Follow button$/) do
  click_link "Follow Cook"
end

Then(/^I should see a message$/) do
  expect(page).to have_content("You followed")
end

Given(/^I am on food details page during search$/) do
  visit food_item_path(FoodItem.find(1))
end

When(/^I click on Unfollow button$/) do
  click_link "Unfollow Cook"
end

Then(/^I should see a unfollow message$/) do
  expect(page).to have_content("You unfollowed")
end