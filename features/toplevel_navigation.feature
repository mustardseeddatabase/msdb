Feature: Top level navigation
  as a database user
  I want to navigate efficiently around the database
	in order to use the features

  Background:
    Given I am logged in and on the "home" page
    And permissions are granted for "admin" to visit the following pages:
      | page |
      | clients#index |
      | checkins#new |
      | distributions#index |
      | donations#index |
      | admin#index |
		And I am on the home page

@javascript
  Scenario: Clients
    When I click on the icon representing "clients"
    Then I should see "Find client"

@javascript
  Scenario: Checkin
    When I click on the icon representing "checkin"
    Then I should see "Client quick check"

@javascript
  Scenario: Checkout
    When I click on the icon representing "checkout"
    Then I should see "Find client for checkout"

@javascript
  Scenario: Donations
    When I click on the icon representing "donations"
    Then I should see "Receive donations into inventory"

@javascript
  Scenario: Logout
    When I click on the icon representing "logout"
    Then I should see "Please log in"

@javascript
  Scenario: Administration
    When I click on the icon representing "admin"
    Then I should see "Administration"
