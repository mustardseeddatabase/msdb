@backbone
Feature: Distribution limits
  As a food pantry staff member
  In order to ensure that clients receive the maximum distribution allowed
  I need to monitor the quantities distributed in each limit category

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
       | items#show           |
       | items#autocomplete   |

@selenium
  Scenario: Checkout items with barcode, and change quantity
    Given There is an item with description "Canned Peas" in the database
    And The "Canned Peas" item has the following attributes:
          | attribute   | value    |
          | sku         | nil      |
          | upc         | 12341234 |
          | count       | 6        |
          | weight_oz   | 12       |
          | category_id | 14       |
    When I scan an item with barcode "12341234"
		Then I should see "Canned Peas" within: "#found_in_db"
    And The size of the limit bar for category "Vegetables" should be "10"
		And I fill in "quantity" with "5"
    And The size of the limit bar for category "Vegetables" should be "50"
    And "#error_message' should be blank

@selenium
  Scenario: Increment limit bar length
    Given There is an item with description "Canned Peas" in the database
    And The "Canned Peas" item has the following attributes:
        | attribute   | value    |
        | upc         | 12341234 |
        | category_id | 14       |
     Then The size of the limit bar for category "Vegetables" should be "0"
     When I scan an item with barcode "12341234"
     Then The size of the limit bar for category "Vegetables" should be "10"
     And The class of the limit bar for category "Vegetables" should be "below_threshold"
     When I scan an item with barcode "12341234"
     Then The size of the limit bar for category "Vegetables" should be "20"
     And The class of the limit bar for category "Vegetables" should be "below_threshold"
     When I scan an item with barcode "12341234"
     Then The size of the limit bar for category "Vegetables" should be "30"
     And The class of the limit bar for category "Vegetables" should be "at_threshold"
     When I scan an item with barcode "12341234"
     Then The size of the limit bar for category "Vegetables" should be "40"
     And The class of the limit bar for category "Vegetables" should be "over_threshold"

@selenium
  Scenario: Scan, then remove, an item for which the db contains errors
    Given There is an item with description "Canned Peas" in the database
    And The "Canned Peas" item has the following attributes:
            | attribute   | value    |
            | upc         | 12341234 |
            | count       | 1        |
            | category_id | nil      |
		When I scan an item with barcode "12341234"
    Then I should see "The item in the database has errors" within: "#error_message"
    And I should see "Please select a category" within: "#error_message"
    When I follow "Remove..."
    Then I should not see "Item in the database has errors" within: "#error_message"
    And I should not see "Count can't be blank or zero" within: "#error_message"
    And The size of the limit bar for category "Vegetables" should be "0"
    And There should be 0 transaction item in the application
