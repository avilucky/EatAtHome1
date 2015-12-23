Feature: Search for food items using different fields

Background: users have been added to the database
  
  Given the following users have been added to the database
  | first_name                   | last_name | email | password | address_one | city      | state | zip   | id | latitude | longitude   |
  | test                         | user      | a     | b        | hawkeye     | iowa city | IA    | 52246 | 1  | 41.66706 | -91.5722641 |
  | another                      | user      | b     | b        | hawkeye     | Des Moines| IA    | 50325 | 2  | 41.66706 | -91.5722641 |

  And the following food items have been added to the database
  | name                    | category | description | portion | price | user_id |
  | pizza                   | italian  | a           | b       | 10.98 | 1       |
  | spaghetti               | italian  | a           | b       | 12.00 | 1       |
  | brownies                | american | a           | b       | 8.00  | 2       |
  
  And the following food images have been added to the database
  | avatar               | food_item_id |
  | http://www.fake.com  | 2            |
  
  Given the following order has been added to the database
  | customer_id             | seller_id | food_item_portion_id | price_per_portion | quantity|
  | 1                       | 2         | 1                    | 10.98             | 1       |
  
  And the following review has been added to the database
  | user_id             | food_item_id | rating | comment |
  | 1                   | 2            | 4      | Good    |
  
  And I am on the search food item page
  And I enter the term "Iowa City, Iowa" into the food "location" field
  And I stub out Geocoder
  
Scenario:  Search for food item by name
  When I enter the term "pizza" into the food "name" field
  And I click on the food item search button
  Then I should see a listing for "pizza"
  
Scenario: Search for food item by category
  When I enter the term "american" into the food "category" field
  And I click on the food item search button
  Then I should see a listing for "brownies"

Scenario: Search for food item by location
  And I click on the food item search button
  Then I should see a listing for "pizza"
  And I should see a listing for "spaghetti"

Scenario: Search for food items with images
  When I click on the food images filter
  And I click on the food item search button
  Then I should see a listing for "spaghetti"
  And I should not see a listing for "pizza"
  
Scenario: See all food items
  When I click on the food item search button
  Then I should see all the food items
  
Scenario: Search for food items by rating
  When I select "3 or above" rating in rating criteria
  And I click on the food item search button
  Then I should see a listing for "spaghetti"
  And I should not see a listing for "pizza"
  And I should not see a listing for "brownies"

Scenario: Sort food items by rating
  When I check Sort by Rating
  And I click on the food item search button
  Then I should see listing for "spaghetti" before "pizza"