Feature: View inventory
	As an inventory staffer
	In order to know what the inventory was on some date
	I need to be able to view any inventory count

  Background: Logged in, with all requisite permissions
    Given The categories, limit_categories and category_thresholds tables are fully populated
    And I am logged in and on the "home" page
    And permissions are granted for "admin" to visit the following pages:
         | page             |
         | inventories#show |
	  And there is an inventory created on 2011-1-1 in the database
		And I am on the inventories#show page for the inventory on 2011-1-1

	Scenario: View entire current inventory
		Then I should see "Inventory count on 2011, Jan 1"
		And I should see 3 inventory items
