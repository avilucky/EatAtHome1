Feature: Allow EatAtHome user (cook) to delte a user imae
  
Background: users have been added to the database
  
  Given the following user has been added to the database
  | first_name                   | last_name | email | password | address_one | city      | state | zip   |
  | test                         | user      | a     | b        | hawkeye     | iowa city | IA    | 52246 |

  And I have logged on with email "a" and password "b"
  
  And the following user images have been added to the database
  | avatar                | user_id |
  | http://www.fake.com   | 1       |
  
Scenario:  Delete a food image
  Given I am on my profile page
  When I click on the delete image button
  Then I should see a message "Your photo was successfully deleted."