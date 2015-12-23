Given(/^the following users? (?:has|have) been added to the database$/) do |table|
  table.hashes.each do |user|
    # Each returned user will be a hash representing one row of the user_table
    # The keys will be the table headers and the values will be the row contents.
    # Entries can be directly to the database with ActiveRecord methods
    # Add the necessary Active Record call(s) to populate the database.
    u = User.new(user)
    u.save(:validate => false)
  end
end

Given(/^I am on the EatAtHome Login Page$/) do
  visit login_form_path
end

When(/^I have entered the email "(.*?)" and the password "(.*?)"$/) do |email, password|
    fill_in 'sessions_email', :with => email
    fill_in 'sessions_password', :with => password
end

When(/^I have clicked on the login button$/) do
  click_button 'Login'
end

Then(/^I should see a welcome message$/) do
  expect(page).to have_content("Welcome")
end

Then(/^I should see a welcome message for user "(.*?)"$/) do |name|
  expect(page).to have_content("Welcome "+name)
end

Then(/^I should see a login error message$/) do
  expect(page).to have_content("Email / password combination is not valid")
end

Capybara.javascript_driver = :selenium

Given(/^I have logged on with email "(.*?)" and password "(.*?)"$/) do |email, password|
  visit login_form_path
  fill_in 'sessions_email', :with => email
  fill_in 'sessions_password', :with => password
  click_button 'Login'
  expect(page).to have_content("Welcome")
end

Capybara.use_default_driver

Given(/^I am on the EatAtHome Home Page$/) do
  visit root_path
end

When(/^I have clicked on the logout button$/) do
  click_link 'logout'
end

Then(/^I should see the login option$/) do
  expect(page).to have_content("Login")
end

Given(/^I am on the EatAtHome signup Page$/) do
  visit signup_form_path
end

When(/^I have entered the email "(.*?)", password "(.*?)", first name "(.*?)", last name "(.*?)", address "(.*?)", city "(.*?)", state "(.*?)", and zip "(.*?)"$/) do |email, password, fname, lname, addr, city, state, zip|
  fill_in 'sessions_email', :with => email
  fill_in 'sessions_password', :with => password
  fill_in 'sessions_first_name', :with => fname
  fill_in 'sessions_last_name', :with => lname
  fill_in 'sessions_password_confirm', :with => password
  fill_in 'sessions_address_one', :with => addr
  fill_in 'sessions_city', :with => city
  fill_in 'sessions_zip', :with => zip
  select state, from: "sessions_state"
end

When(/^I have clicked on the signup button$/) do
  click_button 'Sign up'
end

Then(/^I should see a confirmation message for user$/) do
    expect(page).to have_content("You have successfully signed up! Please check your email for a message from us to confirm your account")
end