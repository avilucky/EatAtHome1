Given(/^I am on the forgot password page$/) do
  visit login_form_path
  click_link "Forget Your Password"
end

When(/^I fill in the email text field with email "(.*?)"$/) do |email|
  fill_in "Email", :with => email
end

When(/^I click reset password button$/) do
    click_button "Reset Password"
end

Given(/^I am on the reset password page with code "(.*?)"$/) do |code|
  visit edit_password_reset_path(code)
end

When(/^I enter the password "(.*?)"$/) do |password|
  fill_in "Password", :with => password
  fill_in "Password (again)", :with => password
end

When(/^I click the submit button$/) do
  click_button 'Change Password'
end