Feature: View site help data
  
  As a user
  So that I can learn how to use the website
  I want to be able to view a help web page

Scenario: Successfully view the help page
  Given I am on the EatAtHome Home Page
  When I click the help page link
  Then I should see a the help page
