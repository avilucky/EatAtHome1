Feature: delete my user account
  
  As a user
  I want to be able to delete my account
  So that I can delete all my information and signup a new user account
  
Background: users have been added to the database
  Given the following user has been added to the database
  | first_name                   | last_name | email | password | address_one | city      | state | zip   |
  | test                         | user      | a     | b        | hawkeye     | iowa city | IA    | 52246 |
  
  And I have logged on with email "a" and password "b"
  And I am on my user update information page

#@javascript
Scenario: Delete my account successfully
  When I have cliked on the delete button
  And I confirmed the browser dialog
  Then My account has been deleted
  And I should go back to home page