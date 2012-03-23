Feature: Household search feature
  As a database owner
  In order to manage interactions with households
  I want to find households by a variety of search fields

  Background: Logged in, with all requisite permissions
    Given I am logged in and on the "home" page
    And permissions are granted for "admin" to visit the following pages:
       | page                    |
       | households#index        |
       | households#autocomplete |
       | clients#autocomplete    |
       | addresses#autocomplete  |

@selenium
  Scenario: Autocomplete zip code search field
    Given I am on the households#index page
    And there are households with zipcodes "70001" and "70002" in the database
    When I fill in "zip" with "700"
    Then I should see "70001"
    Then I should see "70002"

@selenium
  Scenario: Autocomplete city search field
    Given I am on the households#index page
    And there are households with cities "Paris Texas" and "Paris Hilton" in the database
    When I fill in "city" with "Par"
    Then I should see "Paris Texas"
    Then I should see "Paris Hilton"

@selenium
  Scenario: Autocomplete street name search field
    Given I am on the households#index page
    And there are households with street names "Fleet Street" and "Oxford Street" in the database
    When I fill in "address" with "str"
    Then I should see "Fleet Street"
    Then I should see "Oxford Street"

@selenium
  Scenario: Autocomplete client name search field
    Given I am on the households#index page
    And there are clients with last names "Arbogast" and "Gaston" in the database
    When I fill in "client_name" with "gas"
    Then I should see "Arbogast"
    Then I should see "Gaston"

@javascript
  Scenario: Search for household when no results match search criteria
    Given I am on the households#index page
    When I fill in "city" with "Paris Texas"
    And I press "Find matching household(s)..."
    Then I should see "No households matched city: Paris Texas"

@javascript
  Scenario: Search for household matching search criteria
    Given I am on the households#index page
    And there are households with cities "Paris Texas" and "Paris Hilton" in the database
    When I fill in "city" with "Paris"
    And I press "Find matching household(s)..."
    Then I should see "Paris Texas"
		Then I should see "Paris Hilton"

@javascript
	Scenario: search for household by client names
    Given I am on the households#index page
    And there is a household with client "Arbogast" in the database
    When I fill in "client_name" with "Arbogast"
    And I press "Find matching household(s)..."
		Then I should see "Find household"
    And I should see "Search terms: client last name: Arbogast"
    And I should see "Arbogast" within: "#households"

@javascript
  Scenario: search without entering any search criteria
    Given I am on the households#index page
    When I press "Find matching household(s)..."
    Then I should see "Please enter at least one search criterion." within: "#message"
