Feature: Write review for my orders
  
  As a user, 
  I want to be able to write reviews for food I ordered
  So than people get to know how is the food made by the cook
  
Background: users have been added to the database
  
  Given the following user has been added to the database
  | first_name                   | last_name | email | password | address_one | city      | state | zip   |
  | test                         | user      | a     | b        | hawkeye     | iowa city | IA    | 52246 |
  
  Given the following user has been added to the database
  | first_name                   | last_name | email | password | address_one | city      | state | zip   |
  | test                         | user      | c     | d        | hawkeye     | iowa city | IA    | 52246 |
   
  Given the following food items have been added to the database
  | name                    | category | description | portion | price | user_id |
  | pizza                   | italian  | a           | b       | 10.98 | 2       |
  
  Given the following order has been added to the database
  | customer_id             | seller_id | food_item_portion_id | price_per_portion | quantity|
  | 1                       | 2         | 1                    | 10.98             | 1       |
  
  Given I have logged on with email "a" and password "b"
 
Scenario: Write a food review
  Given I am on my user information page
  When I click on Write Review link
  Then I should go to the new review page
  When I fill in the form with rating 5 and comments a and click save
  Then I should be redirected to the food item page
  When I click to see all the reviews of the food item
  Then I should be redirected to the index page
