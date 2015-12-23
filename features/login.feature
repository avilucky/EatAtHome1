Feature: login to the site given an existing user
 
  As a user
  So that I can access my profile information and modify my account
  I want to be able to login to the site

Background: users have been added to the database
  
  Given the following user has been added to the database
  | first_name                   | last_name | email | password |
  | test                         | user      | a     | b        |

  And I am on the EatAtHome Login Page

Scenario: Login with the correct email and password
  Given I am on the EatAtHome Login Page
  When I have entered the email "a" and the password "b"
  And I have clicked on the login button
  Then I should see a welcome message for user "test user"

Scenario: Login with the incorrect email and password
  Given I am on the EatAtHome Login Page
  When I have entered the email "" and the password ""
  And I have clicked on the login button
  Then I should see a login error message

