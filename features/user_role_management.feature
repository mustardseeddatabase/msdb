Feature: Manage the roles assigned to a user
  In order to control which users may access which features
  As the database owner
  I want to be able to assign roles to users

  Background:
    Given There is a role called "admin" in the database
    And There is a role called "foobar" in the database descendent of "admin"
    Given a user account for user "Fanny Arbogast" with role "foobar"
    And I am logged in and on the "authengine/users#index" page
    And permissions are granted for "admin" to visit the following pages:
         | page                          |
         | households#index              |
         | admin#index                   |
         | authengine/user_roles#edit    |
         | authengine/user_roles#index   |
         | authengine/user_roles#new     |
         | authengine/user_roles#create  |
         | authengine/user_roles#destroy |
         | authengine/user_roles#update  |
         | authengine/user_roles#save    |
    And permissions are granted for "foobar" to visit the following pages:
         | page                          |
         | households#index              |

  Scenario: Edit a user's roles
    When I follow "edit roles" for "Fanny Arbogast"
    Then "Fanny Arbogast" should have "1" "user_role"

@selenium
  Scenario: Assign a role to a user
    Then "Fanny Arbogast" should have "1" "user_role"
    When I follow "edit roles" for "Fanny Arbogast"
    And I follow "assign role"
    Then "Fanny Arbogast" should have "2" "user_roles"

  Scenario: Remove a role for a user
    When I follow "edit roles" for "Fanny Arbogast"
    And I follow "remove role"
    Then "Fanny Arbogast" should have "0" "user_roles"

@javascript
  Scenario: Reassign current login to lesser role
    When I am on the admin#index page
    And I follow "Restrict access for the current session"
    Then I should see "Select new temporary access role for this session"
    And There should be "1" "user_role" for "foobar"
    When I select "foobar" from "user_role_role_id"
    And I press "Save"
    Then I should see "Current session now has foobar role"
    And There should be "1" "user_role" for "admin"
    And There should be "1" "user_role" for "foobar"

@javascript
  Scenario: Any session_user_roles are deleted at logout
    When I am on the admin#index page
    And I follow "Restrict access for the current session"
    Then I should see "Select new temporary access role for this session"
    When I select "foobar" from "user_role_role_id"
    And I press "Save"
    Then I should see "Current session now has foobar role"
    And There should be "1" "user_role" for "foobar"
    When I click on the icon representing "logout"
    Then I should see "Please log in"

  Scenario: Session user roles prevail over persistent user roles
    When I am on the admin#index page
    And I follow "Restrict access for the current session"
    Then I should see "Select new temporary access role for this session"
    When I select "foobar" from "user_role_role_id"
    And I press "Save"
    Then I should see "Current session now has foobar role"
    And There should be "1" "user_role" for "admin"
    And There should be "1" "user_role" for "foobar"
    And "Norman Normal" should not have permission to visit "admin#index"
		And I should not see an icon representing "admin"
