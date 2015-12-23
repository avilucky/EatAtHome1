Feature: Allow EatAtHome user (cook) to add a user image

Background: users have been added to the database
  
  Given the following user has been added to the database
  | first_name                   | last_name | email | password | address_one | city      | state | zip   |
  | test                         | user      | a     | b        | hawkeye     | iowa city | IA    | 52246 |

  And I have logged on with email "a" and password "b"
  
Scenario:  Add a user image
  Given I am on add a personal image page 
  When I add the user image file at "./app/assets/images/no_image.jpg"
  And I click on the add user image button
  Then I should see a message "Your photo was successfully created."