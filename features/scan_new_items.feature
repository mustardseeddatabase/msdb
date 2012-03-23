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

@selenium
  Scenario: Scan an item that is not in the database
		When I scan an item with barcode "12341234"
    Then There should be 1 item in the item cache
    Then There should be 1 transaction item in the application
    Then I fill in "description" with "Canned Peas"
		And I fill in "weight_oz" with "12"
		And I fill in "count" with "6"
		And I fill in "quantity" with "100"
    And I select "Food: Vegetables" from "category_id"
    Then The item cache item should be configured with "description" "Canned Peas"
    Then The item cache item should be configured with "weight_oz" "12"
    Then The item cache item should be configured with "count" "6"
    Then The item cache item should have a category with the name "Food"

@selenium
  Scenario: Scan an item that is not in the database, then save
		When I scan an item with barcode "12341234"
		Then I fill in "description" with "Canned Peas"
		And I fill in "weight_oz" with "12"
		And I fill in "count" with "6"
		And I fill in "quantity" with "100"
		And I select "Food" from "category_id"
    When I press "Save"
    Then I should see "Checkout completed"
    And There should be "1" "distribution_item" in the database

@selenium
  Scenario: Scan two identical items that are not in the database with a different one between, doesn't increments quantity
	  Given There is an item with a barcode "43214321" and description "Canned Peas" in the database
		When I scan an item with barcode "12341234"
		Then I fill in "description" with "Apple Pie"
		And I fill in "weight_oz" with "12"
		And I fill in "count" with "6"
		And I fill in "quantity" with "100"
		And I select "Food" from "category_id"
		Then I scan an item with barcode "43214321"
    Then I should see "Canned Peas" in the most recent entry
		Then I scan an item with barcode "12341234"
    Then I should see "Apple Pie" in the most recent entry
    When I press "Save"
    Then I should see "Checkout completed"
    And There should be "3" "distribution_item" in the database

@selenium
	Scenario: Scan barcodes for item not yet in the database, and fail to enter complete information for new item
		When I scan an item with barcode "12341234"
		Then I fill in "description" with "Canned Peas"
		And I fill in "weight_oz" with "12"
		And I fill in "count" with "6"
		And I fill in "quantity" with "100"
		When I scan an item with barcode "349874543"
    Then I should see "Please select a category" within: "#error_message"

@selenium
	Scenario: Scan barcodes for item not yet in the database, fail to enter complete information, try to save
		When I scan an item with barcode "12341234"
		Then I fill in "description" with "Canned Peas"
		And I fill in "weight_oz" with "12"
		And I fill in "quantity" with "100"
		When I press "Save"
    Then I should see "Count can't be blank or zero" within: "#error_message"
		And There should be "0" "distribution_items" in the database
		And There should be "0" "distributions" in the database

@selenium
	Scenario: Scan barcodes for item not yet in the database, enter complete information, save
		When I scan an item with barcode "12341234"
		Then I fill in "description" with "Canned Peas"
		And I fill in "weight_oz" with "12"
		And I fill in "count" with "6"
		And I fill in "quantity" with "100"
		And I select "Food" from "category_id"
		When I press "Save"
		And There should be "1" "distribution_items" in the database
		And There should be "1" "distributions" in the database

@selenium
  Scenario: Scan an item that was previously scanned as new, but is not yet in database
		Given There is an item with a barcode "12341234" and description "Tasty Stuff" in the database
		When I scan an item with barcode "43214321"
		Then I fill in "description" with "Canned Peas"
		And I fill in "weight_oz" with "12"
		And I fill in "count" with "6"
		And I fill in "quantity" with "100"
		And I select "Food" from "category_id"
		When I scan an item with barcode "12341234"
		Then I should see "Tasty Stuff" within: "#found_in_db"
    When I scan an item with barcode "43214321"
    Then I should see "Canned Peas" in the first distributed item
    Then First item should be a distribution item with only quantity as required input
