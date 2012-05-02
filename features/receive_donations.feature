@backbone
Feature: Receive donations
	As a food pantry staff member
	In order to receive donations
	I need to scan or manually enter received items into the database

	Background: Logged in with all requisite permissions
    Given The categories, limit_categories and category_thresholds tables are fully populated
		And There is a donor called "Food for All" in the database
    And I am logged in and on the "donations#new" page
    And permissions are granted for "admin" to visit the following pages:
        | page               |
        | items#show         |
        | donations#create   |
        | donations#index    |
        | items#autocomplete |

@selenium
  Scenario: Click save without scanning any barcodes
    When I press "Save"
    Then I should see "No items to save!"

@selenium
	Scenario: Scan barcodes to receive items that are already in the database
		Given There is an item with a barcode "12341234" and description "Canned Peas" in the database
		When I scan an item with barcode "12341234"
		Then I should see "Canned Peas" within: "#found_in_db"
		When I press "Save"
		Then I should see "Donation saved"
		And There should be "1" "donated_item" in the database
		And There should be "1" "donation" in the database

@selenium
	Scenario: Scan barcodes to receive items that are already in the database, but item is invalid
		Given There is an item with a barcode "12341234" and description "Canned Peas" in the database
    And Item with barcode "12341234" weight is invalid
		When I scan an item with barcode "12341234"
		Then I should see a text field with the value "Canned Peas" within: #found_in_db
    And I should see "The item in the database has errors." within: "#error_message"
    And I should see "Weight can't be blank or zero" within: "#error_message"
    And "weight_oz" field should have class "configuration_error"
		When I press "Save"
    Then I should see "Cannot save until errors are corrected" within: "#error_message"
		Then There should be "0" "donated_items" in the database
		And There should be "0" "donations" in the database
    When I fill in "weight_oz" with "6"
    Then The backbone "donation_app" model should contain a "weight_oz" of "6"
    And "count" field should not have class "configuration_error"
    When I fill in "quantity" with "0"
    Then The backbone "donation_app" transaction model should contain a quantity of "0"
    Then "quantity" field should have class "configuration_error"

@selenium
	Scenario: Scan barcodes to receive items that are already in the database, item is invalid, then save
		Given There is an item with a barcode "12341234" and description "Canned Peas" in the database
    And Item with barcode "12341234" weight is invalid
		When I scan an item with barcode "12341234"
		Then I should see a text field with the value "Canned Peas" within: #found_in_db
    When I fill in "count" with "6"
    And I fill in "quantity" with "6"
    And I fill in "weight_oz" with "6"
		When I press "Save"
		Then I should see "Donation saved"
		And There should be "1" "donated_item" in the database
		And There should be "1" "donation" in the database

@selenium
	Scenario: Scan barcodes of an existing item, and edit
		Given There is an item with a barcode "12341234" and description "Canned Peas" in the database
		When I scan an item with barcode "12341234"
		Then I should see "Canned Peas" within: "#found_in_db"
    When I follow "Edit"
    And I fill in "description" with "Canned Carrots"
    And I press "Save"
    Then I should see "Donation saved"
    And There should be "1" "donated_item" in the database
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
    When I follow "Remove" for donation item "Canned Peas"
    Then I should not see "Canned Peas" within: "#found_in_db"
    And The donated items list length should be "1"
    When I press "Save"
    Then There should be "1" "donation" in the database
    And There should be "1" "donated_item" in the database

@selenium
  Scenario: Remove an item from the scanned items list -- item doesn't exist in db
		When I scan an item with barcode "43214321"
		Then I fill in "description" with "Canned Peas"
    When I follow "Remove"
    Then I should not see "Canned Peas" within: "#found_in_db"
    And The donated items list length should be "0"
    When I press "Save"
    Then I should see "No items to save!"

@selenium
  Scenario: Remove an item from the scanned items list -- no-barcode item
    Given There is an item with description "Canned Peas" in the database
    When I follow "No barcode"
    Then I should see a description autocomplete form
    And I follow "Remove"
    Then I should not see a description autocomplete form

