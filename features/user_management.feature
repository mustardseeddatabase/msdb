Feature: Administration portal
  In order to gain access to administrative functions
  As a site administrator
  I wish to visit the administration portal page

	Background: Logged in with all requisit privileges
    Given I am logged in and on the "admin#index" page
    And permissions are granted for "admin" to visit the following pages:
        | page                         |
        | authengine/users#index       |
        | authengine/users#new         |
        | authengine/users#create      |
        | authengine/users#show        |
        | authengine/users#destroy     |
        | authengine/user_roles#index  |
        | authengine/users#edit        |
        | authengine/users#edit_self   |
        | authengine/users#update      |
        | authengine/users#update_self |

  Scenario: Visit the manage users page
    When I follow "Manage users"
    Then I should see "Database Users" within: "h1"
    And I should see "Normal"
    And I should not see "disable"
    And I should not see "delete"
    And I should not see "edit roles"

  Scenario: Add a user
    Given I am on the authengine/users#index page
    When I follow "New User"
    Then I should see "Create a new user account"
    When I fill in "user_firstName" with "Albert"
    And I fill in "user_lastName" with "Einstein"
    And I fill in "user_email" with "bigal@acme.com"
    And I press "Save"
    Then There should be "2" "users"
    And I should see "disable"
    And I should see "delete"
    And I should see "edit roles"
    And "bigal@acme.com" should receive an email
    When I open the email
    Then I should see "An account has been created" in the email body
    When I follow "here" in the email
    Then I should see "Welcome Albert Einstein"
    And I should see "Select a login name"
    And I should see "Select a login password"


  Scenario: Add a user with an email address that is already in the db
    Given I am on the authengine/users#index page
    When I follow "New User"
    Then I should see "Create a new user account"
    When I fill in "user_firstName" with "Albert"
    And I fill in "user_lastName" with "Einstein"
    And I fill in "user_email" with "norm@acme.com"
    And I press "Save"
    Then I should see "There is already an active user with that email address"

  Scenario: Disable a user
    Given an arbitrary user account
    And I am on the authengine/users#index page
    And permission is granted for "admin" to go to the "authengine/users#disable" page
    Then I follow "disable"
    Then I should see "enable"

  Scenario: Show a user's information
    Given I am on the authengine/users#index page
    When I follow "show"
    Then I should see "User: Norman Normal"
    And I should see "Login name:"
    And I should see "Back"

  Scenario: Delete a user
    Given an arbitrary user account
    And I am on the authengine/users#index page
    When I follow "delete"
    Then There should be "1" "user"

  Scenario: Edit a user's roles
    Given an arbitrary user account
    And a role named "foobar" is in the database
    And I am on the authengine/users#index page
    When I follow "edit roles"
    Then I should see "Roles available:"
    Then I should see "Roles assigned:"

  Scenario: Edit a user's profile
    Given an arbitrary user account
    And a role named "foobar" is in the database
    And I am on the authengine/users#index page
    When I follow "edit profile"
    Then I should see "Edit Profile"
    Then I fill in "user_lastName" with "Tortellini"
    Then I press "Save"
    Then I should see "Tortellini"

  Scenario: Edit a user's profile, adding a duplicate email
    Given an arbitrary user account with email "norm@normco.com"
    And a role named "foobar" is in the database
    And I am on the authengine/users#index page
    When I follow "edit profile" test
    Then I should see "Edit Profile"
    Then I fill in "user_email" with "norm@normco.com"
    Then I press "Save"
    Then I should see "There is already an active user with that email address"

	Scenario: Delegate login to a user with lesser privilege level
		When I follow "Restrict access for the current session"
