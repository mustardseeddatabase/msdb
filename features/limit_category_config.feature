Feature: Limit category configuration
  As a database administrator
  In order to ensure that I can serve as many clients as possible
  I want to set limits on how much food any client may receive

  Background: Logged in with all required permissions
    Given The categories, limit_categories and category_thresholds tables are fully populated
    And I am logged in and on the "limit_categories#index" page
    And permissions are granted for "admin" to visit the following pages:
      | page |
      | limit_categories#update |

@selenium
  Scenario: Save new configuration
    When I fill in "3" for category "Vegetables" and family size "2"
    And I press "Save"
    Then the category threshold for category "Vegetables" and family size "2" should be "3"
