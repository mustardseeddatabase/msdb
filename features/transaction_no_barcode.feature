@backbone
Feature: Receive donations without barcodes
	As a food pantry staff member
	In order to receive donations without barcodes
	I need to manually enter received items into the database

	Background: Logged in with all requisite permissions
    Given The categories, limit_categories and category_thresholds tables are fully populated
		And There is a donor called "Food for All" in the database
    And I am logged in and on the "donations#new" page
    And permissions are granted for "admin" to visit the following pages:
        | page               |
        | items#show         |
        | donations#create   |
        | donations#index    |
        | sku_items#autocomplete |

@selenium
	Scenario: Manually enter items with no barcodes that are already in the database
    Given There is an item with description "Canned Peas" in the database
    And The "Canned Peas" item has the following attributes:
       | attribute      | value      |
       | sku            | 8593       |
       | upc            | nil        |
       | count          | 6          |
       | weight_oz      | 12         |
       | category_id       | 1       |
    When I follow "No barcode"
    Then I should see a blank item row
    When I fill in autocomplete "description" with "pea"
    Then I should see "Canned Peas"
		When I click "Canned Peas"
		And There should be 1 transaction item
    When I press "Save"
		Then I should see "Donation saved"
    And There should be "1" "items" in the database
		And There should be "1" "donated_item" in the database
		And There should be "1" "donation" in the database

@selenium
	Scenario: Manually enter items with no barcodes that are already in the database, with apostrophe
    Given There is an item with description "Bruce's Pancakes" in the database
    And The "Bruce's Pancakes" item has the following attributes:
       | attribute      | value      |
       | sku            | 8593       |
       | upc            | nil        |
       | count          | 6          |
       | weight_oz      | 12         |
       | category_id       | 1       |
    When I follow "No barcode"
    Then I should see a blank item row
    When I fill in autocomplete "description" with "pan"
    Then I should see "Bruce's Pancakes"
		When I click "Bruce's Pancakes"
		And There should be 1 transaction item
    When I press "Save"
		Then I should see "Donation saved"
    And There should be "1" "items" in the database
		And There should be "1" "donated_item" in the database
		And There should be "1" "donation" in the database

@selenium
	Scenario: Manually enter items with no barcodes that are not in the database
    Given There is a no-barcode item with description "Canned Peas" in the database
    When I follow "No barcode"
    When I fill in autocomplete "description" with "pea"
    Then I should see "Canned Peas"
    And I should see "New Item"
    When I click "New Item"
    Then I fill in the following fields:
        | field             | value    |
        | description | Pea soup |
        | weight_oz   | 12       |
        | count       | 6        |
        | quantity     | 27       |
    And I select options for the following select boxes:
        | field                | value        |
				| category_id       | "Food: Vegetables"       |
    When I press "Save"
		Then I should see "Donation saved"
    And There should be "2" "items" in the database
		And There should be "1" "donated_item" in the database
		And There should be "1" "donation" in the database

@selenium
	Scenario: Manually enter invalid item
    Given There is a no-barcode item with description "Canned Peas" in the database
    When I follow "No barcode"
    When I fill in autocomplete "description" with "pea"
    Then I should see "Canned Peas"
    And I should see "New Item"
    When I click "New Item"
    Then I fill in the following fields:
        | field             | value    |
        | description | abc     |
    Then I should see "Invalid description" within: "#error_message"
    Then I fill in the following fields:
        | field             | value    |
        | description | Pea soup |
        | weight_oz   | 12       |
        | quantity     | 27       |
    And I select options for the following select boxes:
        | field                | value        |
				| category_id       | "Food: Vegetables"       |
    When I press "Save"
    Then I should see "Count can't be blank or zero" within: "#error_message"
    And I should see "Cannot save until errors are corrected" within: "#error_message"
		And I should not see "Donation saved"
    And There should be "1" "items" in the database
		And There should be "0" "donated_items" in the database
		And There should be "0" "donations" in the database

@selenium
  Scenario: Remove an item from the scanned items list -- no-barcode item
    Given There is a no-barcode item with description "Canned Peas" in the database
    When I follow "No barcode"
    When I fill in "description" with "pea"
    Then I should see "Canned Peas"
    And I should see "New Item"
    When I click "New Item"
    Then I fill in the following fields:
        | field             | value    |
        | description | Pea soup |
        | weight_oz   | 12       |
        | count       | 6        |
        | quantity     | 27       |
    And I select options for the following select boxes:
        | field                | value        |
				| category_id       | "Food: Vegetables"       |
    When I follow "Remove"
    Then I should not see "Pea soup" within: "#found_in_db"
    And The donated items list length should be "0"

@selenium
  Scenario: Identify preferred no-barcode item
    Given There is a no-barcode item with description "Canned Peas, giant" in the database
    And   There is a no-barcode item with description "Canned Peas, petite" in the database, identified as preferred
    When I follow "No barcode"
    When I fill in "description" with "pea"
    Then I should see "Canned Peas, petite"
    And I should not see "Canned Peas, giant"
