@backbone
Feature: Resume a previous inventory
	As an inventory staffer
	In order to continue adding item counts to a previous inventory that was paused
	I need to be able to resume adding items

  Background: Logged in, with all requisite permissions
    Given The categories, limit_categories and category_thresholds tables are fully populated
    And I am logged in and on the "home" page
    And permissions are granted for "admin" to visit the following pages:
            | page               |
            | items#show         |
            | inventories#edit |
            | inventories#update |
	  And there is an inventory created on 2011-1-1 in the database
		And I am on the inventories#edit page for the inventory on 2011-1-1

@selenium
	Scenario: Load inventory
		Then I should see 3 inventory items

@selenium
	Scenario: Scan barcodes to record items that are already in the database
		Given There is an item with a barcode "12341234" and description "Canned Peas" in the database
		When I scan an item with barcode "12341234"
		Then I should see "Canned Peas" within: "#found_in_db"
		When I press "Save"
		Then I should see "Inventory updated"
		And There should be "4" "inventory_item" in the database
		And There should be "1" "inventory" in the database

@selenium
	Scenario: Scan barcodes to receive items that are already in the database, but item is invalid
		Given There is an item with a barcode "12341234" and description "Canned Peas" in the database
    And Item with barcode "12341234" count is "0"
		When I scan an item with barcode "12341234"
		Then I should see a text field with the value "Canned Peas" within: #found_in_db
    And I should see "The item in the database has errors." within: "#error_message"
    And I should see "Count can't be blank or zero" within: "#error_message"
    And "count" field should have class "configuration_error"
		When I press "Save"
    Then I should see "Cannot save until errors are corrected" within: "#error_message"
		Then There should be "3" "inventory_items" in the database
		And There should be "1" "inventories" in the database
    When I fill in "count" with "6"
    Then The backbone inventory model should contain a count of "6"
    And "count" field should not have class "configuration_error"
    When I fill in "quantity" with "0"
    Then The backbone inventory model should contain a quantity of "0"
    Then "quantity" field should have class "configuration_error"

@selenium
	Scenario: Scan barcodes to receive items that are already in the database, item is invalid, then save
		Given There is an item with a barcode "12341234" and description "Canned Peas" in the database
    And Item with barcode "12341234" count is "0"
		When I scan an item with barcode "12341234"
		Then I should see a text field with the value "Canned Peas" within: #found_in_db
    When I fill in "count" with "6"
    When I fill in "quantity" with "6"
		When I press "Save"
		Then I should see "Inventory updated"
		And There should be "4" "inventory_item" in the database
		And There should be "1" "inventory" in the database

@selenium
	Scenario: Scan barcodes of an existing item, and edit
		Given There is an item with a barcode "12341234" and description "Canned Peas" in the database
		When I scan an item with barcode "12341234"
		Then I should see "Canned Peas" within: "#found_in_db"
    When I follow "Edit"
    And I fill in "description" with "Canned Carrots"
    And I press "Save"
    Then I should see "Inventory updated"
    And There should be "4" "inventory_item" in the database
    And The item with barcode "12341234" in the database should have a description "Canned Carrots"

@selenium
	Scenario: Scan barcodes of an existing item, edit, and scan another item
		Given There is an item with a barcode "12341234" and description "Canned Peas" in the database
		And There is an item with a barcode "43214321" and description "Stewed Tomatoes" in the database
		When I scan an item with barcode "12341234"
		Then I should see "Canned Peas" within: "#found_in_db"
    When I follow "Edit"
    And I fill in "description" with "Canned Carrots"
		When I scan an item with barcode "43214321"
		Then I should see "Stewed Tomatoes" within: "#found_in_db"
    Then only the first item should have an edit link

@selenium
  Scenario: Remove an item from the scanned items list -- item exists in db
		Given There is an item with a barcode "12341234" and description "Canned Peas" in the database
		Given There is an item with a barcode "43214321" and description "Wild Honey" in the database
		When I scan an item with barcode "12341234"
		When I scan an item with barcode "43214321"
		Then I should see "Canned Peas" within: "#found_in_db"
    When I follow "Remove" for inventory item "Canned Peas"
    Then I should not see "Canned Peas" within: "#found_in_db"
    And The inventory items list length should be "4"
    When I press "Save"
    Then There should be "1" "inventory" in the database
    And There should be "4" "inventory_item" in the database

@selenium
  Scenario: Remove an item from the scanned items list -- item doesn't exist in db
		When I scan an item with barcode "43214321"
		Then I fill in "description" with "Canned Peas"
    When I follow Remove... for the Canned Peas item
    Then I should not see "Canned Peas" within: "#found_in_db"
    And The inventory items list length should be "3"
    When I press "Save"
    Then There should be "1" "inventory" in the database
    And There should be "3" "inventory_item" in the database

@selenium
  Scenario: Remove an item from the scanned items list -- no-barcode item
    Given There is an item with description "Canned Peas" in the database
    When I follow "No barcode"
    Then I should see a description autocomplete form
    And I follow "Remove"
    Then I should not see a description autocomplete form


