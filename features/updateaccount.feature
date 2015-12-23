Feature: update my user account
  
  As a user
  I want to be able to update my account
  So that I can update all my information 

Background: users have been added to the database
  Given the following user has been added to the database
  | first_name                   | last_name | email           | password | address_one | city      | state | zip   |
  | test                         | user      | a@gmail.com     | b        | hawkeye     | iowa city | IA    | 52246 |
  
  And I have logged on with email "a@gmail.com" and password "b"
  And I am on my user update information page

Scenario: update successfully using the update form
  When I have entered the first name "test", last name "user", address "hawkeye lane", city "Iowa City", state "Iowa", and zip "52246"
  And I have clicked on the update button
  Then I should see a confirmation message for user page
