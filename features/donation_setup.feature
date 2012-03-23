Feature: Donation setup feature
  As a food pantry staff member
	In order to prepare to receive donations
	I want to select or create a donor, or edit a previous donation

  Background: Logged in, with all requisite permissions
    Given I am logged in and on the "home" page
    And There is a donor called "Second Harvest" in the database
    And permissions are granted for "admin" to visit the following pages:
       | page            |
       | donations#index |
       | donations#new   |
       | donations#edit   |
       | donors#new       |

@javascript
  Scenario: Select a donor already in the database
    Given I am on the donations#index page
    When I select "Second Harvest" from "donor"
    Then I should see "New Donation by Second Harvest" within: "h1"

  Scenario: Add a new donor
    Given I am on the donations#index page
    When I follow "Add a new donor"
    Then I should see "New Donor" within: "h1"

  Scenario: Edit a recent donation
    Given There are ten donations in the database
    And I am on the donations#index page
    Then I should see 5 donations
    When I follow "Edit"
    Then I should see "Donation by" within: "h1"
