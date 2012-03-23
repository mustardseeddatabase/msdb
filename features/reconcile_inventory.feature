Feature: Reconcile inventory with database
	As an inventory staffer
	In order to make the physical inventory match the database
	I need to be able to easily update the database with actual item counts

  Background: Logged in, with all requisite permissions
    Given The categories, limit_categories and category_thresholds tables are fully populated
    And I am logged in and on the "home" page
    And permissions are granted for "admin" to visit the following pages:
         | page             |
         | inventories#show |
         | items#update_all |
	  And there is an inventory created on 2011-1-1 in the database
		And there are 5 items in the database each with qoh greater than 1
		And I am on the inventories#show page for the inventory on 2011-1-1

@selenium
	Scenario: Reset database to match actual inventory
		When I follow "Reset database to match inventory"
		And I confirm the popup
		Then 5 items in the database should have qoh 0
		And 3 items in the database should have qoh 1
