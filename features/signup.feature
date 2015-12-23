Feature: sign up as a new user to the site
 
  As a user
  So that I can upload my own food items and create reviews
  I want to be able to sign up for the webiste

Scenario: signup successfully using the signup form
  Given I am on the EatAtHome signup Page
  When I have entered the email "EatAtHome.NoReply@gmail.com", password "b", first name "test", last name "user", address "hawkeye lane", city "Iowa City", state "Iowa", and zip "52246"
  And I have clicked on the signup button
  Then I should see a confirmation message for user

