Feature: login to the site given an existing user
 
  As a user
  So that I can exit the site or login as another user
  I want to be able to logout of the site

Background: users have been added to the database
  
  Given the following user has been added to the database
  | first_name                   | last_name | email | password |
  | test                         | user      | a     | b        |

  And I have logged on with email "a" and password "b"
  
Scenario: Logout successfully
  Given I am on the EatAtHome Home Page
  When I have clicked on the logout button
  Then I should see the login option
