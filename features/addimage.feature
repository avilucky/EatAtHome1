Feature: Allow EatAtHome user (cook) to add a food item

Background: users have been added to the database
  
  Given the following user has been added to the database
  | first_name                   | last_name | email | password | address_one | city      | state | zip   |
  | test                         | user      | a     | b        | hawkeye     | iowa city | IA    | 52246 |

  And I have logged on with email "a" and password "b"

  Given the following food items have been added to the database
  | name                    | category | description | portion | price | user_id | availability | id |
  | pizza                   | italian  | a           | b       | 10.98 | 1       | true         | 1  |
  
Scenario:  Add a food image
  Given I am on add image page for food "1"
  When I add the image file at "./app/assets/images/no_image.jpg"
  And I click on the add image button
  Then I should see a message "Food image was successfully created."