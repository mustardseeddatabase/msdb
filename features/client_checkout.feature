@backbone
Feature: Client checkout
  As a food pantry staff member
  In order to manage and record distributions
  I need to scan or manually enter items checked out by a client

  Background: Logged in, with all requisite permissions
    Given The categories, limit_categories and category_thresholds tables are fully populated
    And The limit for category "Vegetables" for a household size of "3" is "3"
    And there is a household with residency expired, income expiring and govtincome valid in the database
    And there is a client with last name "Arbogast", first name "Fanny", age "20" in the database belonging to the household, with an ID document
    And there is a client with last name "Gaston", first name "Gary", age "88", with id date "Date.new(2009,1,1)" in the database belonging to the household
    And there is a client with last name "Komenflick", first name "Karmine", age "33", with id date "Date.new(2009,1,1)" in the database belonging to the household
    And I am logged in and on the "distributions#new" page for "Fanny Arbogast"
    And permissions are granted for "admin" to visit the following pages:
       | page                 |
       | distributions#index  |
       | distributions#new    |
       | distributions#create |
       | clients#autocomplete |
       | items#show           |
       | items#autocomplete   |

@javascript
  Scenario: Navigate to individual client checkout page, finding client by autocomplete
    Given I am on the distributions#index page
    When I fill in autocomplete "last_name" with "gas"
    Then I should see "Arbogast, Fanny. 20"
    When I click autocomplete result "Arbogast, Fanny. 20"
    Then I should see "New Distribution for Fanny Arbogast" within: "h1"

@selenium
  Scenario: Scan two existing items with the same barcode in succession, increments quantity
	  Given There is an item with a barcode "12341234" and description "Canned Peas" in the database
    When I scan an item with barcode "12341234"
		Then I should see "Canned Peas" within: "#found_in_db"
		When I scan an item with barcode "12341234"
		And I fill in "quantity" with "100"
    When I scan an item with barcode "12341234"
    Then I should see "1" entry with the description "Canned Peas" and barcode "12341234"
    And Quantity for "Canned Peas" should be "101"
    When I press "Save"
    Then I should see "Checkout completed"
    And There should be "1" "distribution_item" in the database
    And The distribution item in the database should have quantity 101

@selenium
  Scenario: Scan item and save twice
	  Given There is an item with a barcode "12341234" and description "Canned Peas" in the database
    When I scan an item with barcode "12341234"
		Then I should see "Canned Peas" within: "#found_in_db"
    When I press "Save"
    Then I should see "Checkout completed"
    And There should be "1" "distribution_item" in the database
    When I press "Save"
    Then I should see "Checkout completed"
    And There should be "1" "distribution_item" in the database

  Scenario: Save times out
	  Given There is an item with a barcode "12341234" and description "Canned Peas" in the database
    And The server is down
    When I scan an item with barcode "12341234"
		Then I should see "Canned Peas" within: "#found_in_db"
    When I press "Save"
    Then I should see "Server is down, cannot save, please try later"

@selenium
  Scenario: Scan two existing items with the same barcode with a different one between, doesn't increments quantity
	  Given There is an item with a barcode "12341234" and description "Canned Peas" in the database
	  And There is an item with a barcode "43214321" and description "Apple Pie" in the database
    When I scan an item with barcode "12341234"
		Then I should see "Canned Peas" within: "#found_in_db"
    When I scan an item with barcode "43214321"
		Then I should see "Apple Pie" within: "#found_in_db"
		When I scan an item with barcode "12341234"
    Then I should see "Canned Peas" in the most recent entry
    And I should see "2" entries with the description "Canned Peas" and barcode "12341234"
    When I press "Save"
    Then I should see "Checkout completed"
    And There should be "3" "distribution_item" in the database
