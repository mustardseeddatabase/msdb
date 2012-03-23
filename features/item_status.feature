@backbone
Feature: Item status

  Background: Logged in with all requisite permissions
    Given The categories, limit_categories and category_thresholds tables are fully populated
	  And There is an item with a barcode "12341234" and description "Canned Peas" in the database
	  And There is an item with a barcode "43214321" and description "Stewed Tomatoes" in the database
	  And There is an item with a barcode "5551212" and description "Tasty Nosh" in the database
		And Item with barcode "5551212" has no category configured
    And I am logged in and on the "admin#index" page
    And permissions are granted for "admin" to visit the following pages:
        | page         |
        | items#show   |
        | items#update |

@selenium
  Scenario: Navigate to item status page
    When I follow "Item status"
    Then I should see "Item status" within: "h1"

@selenium
  Scenario: Scan items
    Given I am on the item status page
    When I scan an item with barcode "12341234"
		Then I should see "Canned Peas" within: "#found_in_db"
    When I scan an item with barcode "43214321"
		Then I should see "Stewed Tomatoes" within: "#found_in_db"

@selenium
  Scenario: Edit item
    Given I am on the item status page
    When I scan an item with barcode "12341234"
    And I follow "Edit"
    Then I should see an edit form for the item
    And I fill in "description" with "broccoli"
    And I follow "Save"
    Then The item in the database with upc 12341234 should have description "Broccoli"
    And I should see "Item updated"

@selenium
	Scenario: Scan item with errors
		Given I am on the item status page
		When I scan an item with barcode "5551212"
		Then I should see "The item in the database has errors" within: "#error_message"
    And I should see "Please select a category" within: "#error_message"

