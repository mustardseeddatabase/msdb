Feature: Role management
  As a database owner
  In order to group user access privileges into roles
  I want to define access roles

  Background: logged in with requisite permissions
    Given There is a 'developer' role in the database
    And I am logged in and on the "authengine/roles#index" page
    And permissions are granted for "admin" to visit the following pages:
      | page |
      | authengine/roles#new |
      | authengine/roles#create|
      | authengine/roles#destroy|

  Scenario: Visit the roles index page
    Then I should see "Edit roles"

  Scenario: Should not be able to remove developer role
    Then I should not see "Remove" for "developer" role

  Scenario: Add a role
    When I follow "Add new role"
    Then I should see "Add role"
    And I fill in "role_name" with "foobar"
    And I select "admin" from "Parent:"
    And I press "Save"
    Then I should see "Edit roles"
    And I should see "foobar"
    And There should be "3" "roles"
    And "foobar" role should have parent "admin"

  Scenario: Start to add a role, but cancel
    When I follow "Add new role"
    Then I should see "Add role"
    And I fill in "role_name" with "foobar"
    And I follow "Cancel"
    Then I should see "Edit roles"
    And I should not see "foobar"
    And There should be "2" "roles"

  Scenario: Try to add a duplicate role
    When I follow "Add new role"
    Then I should see "Add role"
    And I fill in "role_name" with "admin"
    And I press "Save"
    Then I should see "Add role"
    And I should see "has already been taken"
    And There should be "2" "roles"

  Scenario: Try to remove a role, but users are assigned
    Given a user account for user "Blinky Blartfarst" with role "schmoogie"
    When I follow "Remove"
    Then I should see "Cannot remove a role if users are assigned."
    And I should see "Please reassign or delete users."

@selenium
  Scenario: Remove a role that has no users assigned
    Given There is a role called "i_do_everything" in the database
    And I am on the authengine/roles#index page
    When I follow "Remove" for the role "i_do_everything"
    Then I should not see "Cannot remove a role if users are assigned."
    And I should not see "Please reassign or delete users."
