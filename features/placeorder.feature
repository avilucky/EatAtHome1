Feature: Allow EatAtHome user (cook) to add a food item

Background: users have been added to the database
  
  Given the following user has been added to the database
  | first_name                   | last_name | email                       | password | address_one | city      | state | zip   |
  | test                         | user      | EatAtHome.NoReply@gmail.com | b        | hawkeye     | iowa city | IA    | 52246 |
  | test1                        | user      | a1                          | b        | hawkeye     | iowa city | IA    | 52246 |

  And I have logged on with email "a1" and password "b"

  Given the following food items have been added to the database
  | name                    | category | description | portion | price | user_id |
  | pizza                   | italian  | a           | b       | 10.98 | 1       |
  
  
Scenario:  Order a food item portion
  Given I am on show food item page
  When I order a food item with portion "b" and quantity "2"
  Then I should see a message "Order placed successfully"
  
Scenario:  Order a food item portion fail for validation of quantity
  Given I am on show food item page
  When I order a food item with portion "b" and quantity ""
  Then I should see a message "Quantity can't be blank"