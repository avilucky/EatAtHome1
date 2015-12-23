Feature: Allow EatAtHome user (cook) to update a food item

Background: users have been added to the database
  
  Given the following user has been added to the database
  | first_name                   | last_name | email | password | address_one | city      | state | zip   |
  | test                         | user      | a     | b        | hawkeye     | iowa city | IA    | 52246 |

  And I have logged on with email "a" and password "b"
  
  
  
Scenario:  Add a food item
  Given I am on new food item page
  When I have added a food item with name "Pizza", category "Italian", description "Veg/Non-Veg", portion "10 inches" and price "10.98"
  Then I should see a message "Pizza was successfully created."
  
Scenario:  Add a food item with invalid food item detail
  Given I am on new food item page
  When I have added a food item with name "", category "Italian", description "Veg/Non-Veg", portion "10 inches" and price "10.98"
  Then I should see a message "Name can't be blank"

Scenario:  Add a food item with invalid food item portion detail
  Given I am on new food item page
  When I have added a food item with name "Pizza", category "Italian", description "Veg/Non-Veg", portion "10 inches" and price "10.9898"
  Then I should see a message "Price is invalid"