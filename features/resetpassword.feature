Feature: Reset My Password
  
  As a user
  I want to be able to reset my password
  So that I can login with a new password when I forget my old password
  
Background: users have been added to the database
  
  Given the following users have been added to the database
  | first_name                   | last_name | email              | password | address_one | city      | state | zip   | id | password_reset_token |
  | test                         | user      | test@gmail.com     | b        | hawkeye     | iowa city | IA    | 52246 | 1  | none                 |
  | another                      | user      | fake@gmail.com     | b        | hawkeye     | Des Moines| IA    | 50325 | 2  | test                 |
  
Scenario: Send password reset email
  Given I am on the forgot password page
  When I fill in the email text field with email "test@gmail.com"
  And I click reset password button
  Then I should see a message "Password reset instructions sent! Please check your email."

Scenario: Reset password
  Given I am on the reset password page with code "test"
  When I enter the password "fake"
  And I click the submit button
  Then I should see a message "Password updated."
