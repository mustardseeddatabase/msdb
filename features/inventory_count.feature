@backbone
Feature: Count current inventory
  As an inventory staffer
  In order to know and record the current contents of the physical inventory
  I need to be able to count and record each item of physical inventory

  Background: Logged in, with all requisite permissions
    Given The categories, limit_categories and category_thresholds tables are fully populated
    And I am logged in and on the "home" page
    And permissions are granted for "admin" to visit the following pages:
            | page               |
            | items#show         |
            | inventories#new    |
            | inventories#create |
		And I am on the inventories#new page

@selenium
  Scenario: Click save without scanning any barcodes
    When I press "Save"
    Then I should see "No items to save!"

@selenium
	Scenario: Scan barcodes to record items that are already in the database
		Given There is an item with a barcode "12341234" and description "Canned Peas" in the database
		When I scan an item with barcode "12341234"
		Then I should see "Canned Peas" within: "#found_in_db"
		When I press "Save"
		Then I should see "Inventory saved"
		And There should be "1" "inventory_item" in the database
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
		Then There should be "0" "inventory_items" in the database
		And There should be "0" "inventories" in the database
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
		Then I should see "Inventory saved"
		And There should be "1" "inventory_item" in the database
		And There should be "1" "inventory" in the database

@selenium
	Scenario: Scan barcodes of an existing item, and edit
		Given There is an item with a barcode "12341234" and description "Canned Peas" in the database
		When I scan an item with barcode "12341234"
		Then I should see "Canned Peas" within: "#found_in_db"
    When I follow "Edit"
    And I fill in "description" with "Canned Carrots"
    And I press "Save"
    Then I should see "Inventory saved"
    And There should be "1" "inventory_item" in the database
    And The item with barcode "12341234" in the database should have a description "Canned Carrots"

@selenium
	Scenario: Scan barcodes of an existing item, and edit category
		Given There is an item with a barcode "12341234" and description "Canned Peas" in the database
		When I scan an item with barcode "12341234"
		Then I should see "Canned Peas" within: "#found_in_db"
    When I follow "Edit"
    And I select "Household" from "category_id"
    Then The item cache item with barcode "12341234" should have "category_id" for "Household"
    And The item cache item with barcode "12341234" should have "category_descriptor" for "Household"

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
		And There is an item with a barcode "43214321" and description "Wild Honey" in the database
		When I scan an item with barcode "12341234"
		And I scan an item with barcode "43214321"
		Then I should see "Canned Peas" within: "#found_in_db"
    When I follow "Remove" for inventory item "Canned Peas"
    Then I should not see "Canned Peas" within: "#found_in_db"
    And The inventory items list length should be "1"
    When I press "Save"
    Then There should be "1" "inventory" in the database
    And There should be "1" "inventory_item" in the database

@selenium
  Scenario: Remove an item from the scanned items list -- item doesn't exist in db
		When I scan an item with barcode "43214321"
		Then I fill in "description" with "Canned Peas"
    When I follow "Remove"
    Then I should not see "Canned Peas" within: "#found_in_db"
    And The inventory items list length should be "0"
    When I press "Save"
    Then I should see "No items to save!"

@selenium
  Scenario: Remove an item from the scanned items list -- no-barcode item
    Given There is an item with description "Canned Peas" in the database
    When I follow "No barcode"
    Then I should see a description autocomplete form
    And I follow "Remove"
    Then I should not see a description autocomplete form

@selenium
  Scenario: Scan multiple items
		Given There is an item with a barcode "12341234" and description "Canned Peas" in the database
		And There is an item with a barcode "43214321" and description "Wild Honey" in the database
		When I scan an item with barcode "12341234"
		And I scan an item with barcode "43214321"
    Then The item with barcode "43214321" should be editable
    Then The item with barcode "12341234" should not be editable
