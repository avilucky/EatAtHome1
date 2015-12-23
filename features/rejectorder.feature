Feature: Allow EatAtHome user (seller) to reject an order

Background: users have been added to the database
  
  Given the following user has been added to the database
  | first_name                   | last_name | email                       | password | address_one | city      | state | zip   |
  | test                         | user      | EatAtHome.NoReply@gmail.com | b        | hawkeye     | iowa city | IA    | 52246 |
  | test1                        | user      | a1                          | b        | hawkeye     | iowa city | IA    | 52246 |

  And I have logged on with email "EatAtHome.NoReply@gmail.com" and password "b"

  Given the following food items have been added to the database
  | name                    | category | description | portion | price | user_id |
  | pizza                   | italian  | a           | b       | 10.98 | 1       |

  Given the following order have been added to the database
  | quantity                    | price_per_portion | status  | food_item_portion_id | customer_id | seller_id |
  | 4                           | 10.98             | pending | 1                    | 2           | 1         |
  
Scenario:  Reject an Order
Given I am on show order page
When I click on Reject button
Then I should see a message "Order rejected"