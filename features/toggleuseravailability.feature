Feature: Allow EatAtHome user (cook) to add a food item

Background: users have been added to the database
  
  Given the following user has been added to the database
  | first_name                   | last_name | email          | password | address_one | city      | state | zip   |
  | test                         | user      | a@test.com     | b        | hawkeye     | iowa city | IA    | 52246 |

  And I have logged on with email "a@test.com" and password "b"
  
Scenario:  Update a food item
  Given I am on show user page for user with email "a@test.com"
  When I click on the availability button
  Then I should see a message "Updated successfully"