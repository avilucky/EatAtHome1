Feature: Allow EatAtHome user (buyer) to follow a cook

Background: users have been added to the database
  
  Given the following user has been added to the database
  | first_name                   | last_name | email                       | password | address_one | city      | state | zip   |
  | test                         | user      | EatAtHome.NoReply@gmail.com | b        | hawkeye     | iowa city | IA    | 52246 |
  | test1                        | user      | a1                          | b        | hawkeye     | iowa city | IA    | 52246 |
  

  Given the following food items have been added to the database
  | name                    | category | description | portion | price | user_id |
  | pizza                   | italian  | a           | b       | 10.98 | 1       |
  
  And I have logged on with email "a1" and password "b"
  
Scenario: Follow Cook
Given I am on food details page
When I click on Follow button
Then I should see a message 