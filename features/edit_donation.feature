@backbone
Feature: Edit donations

	Background: Logged in with all requisite permissions
    Given The categories, limit_categories and category_thresholds tables are fully populated
    And There is one donation in the database
    And The donor is "Food for All"
    And The date is "2011-11-11"
    And I am logged in and on the "donations#index" page
    And permissions are granted for "admin" to visit the following pages:
        | page               |
        | donations#index    |
        | donations#edit     |
        | donations#update   |
        | upc_items#show         |

@selenium
  Scenario: Navigate to edit page, add an item to a donation, and save it
		Given There is an item with a barcode "43214321" and description "Canned Peas" in the database
    When I follow "Edit"
    Then I should see "Edit Donation by Food for All on 2011, Nov 11" within: "h1"
    And I should see 4 donated items
    And Donated items should have no editable fields
		When I scan an item with barcode "43214321"
		Then I should see "Canned Peas" within: "#found_in_db"
		When I press "Save"
		Then I should see "Donation updated"
		And There should be "5" "donated_item" in the database
		And There should be "1" "donation" in the database
		And There should be "5" "item" in the database

#@selenium
  #Scenario: Edit an item and save
    #Given I follow "Edit"
    #Then I should see "Edit Donation by Food for All on 2011, Nov 11" within: "h1"
    #And I should see 4 donated items
    #And I follow "Edit" for the first donated item
    #Then I should see an edit form
    #And I fill in item description with "Tasty Spam"
		#When I press "Save"
		#Then I should see "Donation updated"
		#And There should be "4" "donated_item" in the database
		#And There should be "1" "donation" in the database
		#And There should be "4" "item" in the database
    #And There should be an item with description "Tasty Spam" in the database

@selenium
  Scenario: Remove an item and then save
    Given I follow "Edit"
    Then I should see "Edit Donation by Food for All on 2011, Nov 11" within: "h1"
    And I should see 4 donated items
    And I follow "Remove" for the first donated item
    And I should see 3 donated items
		When I press "Save"
		Then I should see "Donation updated"
		And There should be "3" "donated_item" in the database
		And There should be "1" "donation" in the database
		And There should be "4" "item" in the database

@selenium
  Scenario: Remove an item and then scan
		Given There is an item with a barcode "43214321" and description "Canned Peas" in the database
    And I follow "Edit"
    Then I should see "Edit Donation by Food for All on 2011, Nov 11" within: "h1"
    And I should see 4 donated items
    And I follow "Remove" for the first donated item
    And I should see 3 donated items
		When I scan an item with barcode "43214321"
		Then I should see "Canned Peas" within: "#found_in_db"
    And I should see 4 donated items
		When I press "Save"
		Then I should see "Donation updated"
		And There should be "4" "donated_item" in the database
		And There should be "1" "donation" in the database
		And There should be "5" "item" in the database

@selenium
  Scenario: Repeated save with item removal between
    Given I follow "Edit"
    Then I should see "Edit Donation by Food for All on 2011, Nov 11" within: "h1"
    Then I should see 4 donated items
    Then I follow "Remove" for the first donated item
    When I press "Save"
    Then There should be "3" "donated_item" in the database
    Then I follow "Remove" for the first donated item
    When I press "Save"
    Then There should be "2" "donated_item" in the database
    Then I follow "Remove" for the first donated item
    When I press "Save"
    Then There should be "1" "donated_item" in the database
    Then I follow "Remove" for the first donated item
    When I press "Save"
    Then There should be "0" "donated_item" in the database
