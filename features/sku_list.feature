Feature: Sku list
  As a food pantry checkout person
  In order to be most efficient in checking out clients
  I need quick access to a list of non-barcode item sku's, in hard copy or with scanner input

  Background: Logged in, with all requisit permissions
    Given There is a no-barcode item with description "Rutabaga" in the database
    And The "Rutabaga" item has limit category "Vegetables"
    And The "Rutabaga" item is identified as canonical
    And I am logged in and on the "sku_lists#show" page
    And permissions are granted for "admin" to visit the following pages:
           | page                   |
           | sku_lists#show         |
           | sku_lists#edit         |
           | sku_list_items#edit    |
           | sku_items#autocomplete |
           | sku_list_items#destroy |
           | sku_list_items#new     |
           | sku_list_items#update  |
           | sku_list_items#create  |

  Scenario: Basic page features
    Then I should see "Food: Vegetables" within: "h2"

  Scenario: Edit the list
    When I follow "Edit"
    Then I should see "Edit preferred sku list" within: "h1"
    And I should see "Edit" for the item described as "Rutabaga"
    And I should see "Remove" for the item described as "Rutabaga"
    And I should see a link called "Add an item"

  Scenario: Edit an item on the list
    When I follow "Edit"
    And I follow "Edit" for the item described as "Rutabaga"
    Then I should see "Edit item" within: "h1"
    When I fill in "item_description" with "Rutabaga, loose"
    Then I press "Save"
    Then The item description in the database should be "Rutabaga, Loose"
    Then I should see "Food: Vegetables" within: "h2"
    And I should see "Edit" for the item described as "Rutabaga, Loose"

@javascript
  Scenario: Remove an item from the list
    When I follow "Edit"
    And I follow "Remove" for the item described as "Rutabaga"
    Then I should see "Edit preferred sku list" within: "h1"
    And The "Rutabaga" item in the database should not be designated as canonical
    And I should not see any items in the preferred sku list

@selenium
  Scenario: Add an item to the list
    Given There is a no-barcode item with description "Potatoes, loose" in the database
    And The "Potatoes, loose" item has limit category "Vegetables"
    And The "Potatoes, loose" item is identified as not canonical
    When I follow "Edit"
    And I follow "Add an item"
    Then The "Add to list" button should be disabled
    And I fill in autocomplete "description" with "pot"
    Then I should see "Potatoes"
    When I click autocomplete result "Potatoes"
    Then The "Add to list" button should be enabled
    And I press "Add to list"
    Then I should see an item in the list with description "Potatoes"
    And The "Potatoes, loose" item in the database should be designated as canonical
