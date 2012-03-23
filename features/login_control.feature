Feature: Login control
  In order to limit access to the database
  As the database owner
  I want to control who has access

@selenium
  Scenario: Administrator login
    Given a user account with username "admin" and password "password"
    And the user has "admin" role
    And permission is granted for "admin" to go to the "home#index" page
    And permission is granted for "admin" to go to the "admin#index" page
    When I go to the root page
    Then I should not see "Logout"
    Then I fill in "login" with "admin"
    And I fill in "password" with "password"
    And I press "Log in..."
    And I should see an icon representing "logout"
    And I should see an icon representing "admin"

  Scenario: Administrator login with incorrect username
    Given a user account with username "admin" and password "password"
    When I go to the root page
    And I fill in "login" with "foobar"
    And I fill in "password" with "password"
    And I press "Log in..."
    Then I should see "Your username or password is incorrect."

  Scenario: Administrator login with incorrect password
    Given a user account with username "admin" and password "password"
    When I go to the root page
    And I fill in "login" with "admin"
    And I fill in "password" with "wrongpassword"
    And I press "Log in..."
    Then I should see "Your username or password is incorrect."

  Scenario: Login with role other than administrator
    Given a user account with username "someuser" and password "secret"
    And the user has "foobar" role
    And permission is granted for "foobar" to go to the "households#index" page
    When I go to the root page
    Then I should not see an icon representing "logout"
    Then I fill in "login" with "someuser"
    And I fill in "password" with "secret"
    And I press "Log in..."
    And I should see an icon representing "logout"
    And I should see an icon representing "households"
    And I should not see an icon representing "admin"

  Scenario: Login as a user whose account is disabled
    Given I am a user whose account is disabled
    When I login
    Then I should see "Your account has been disabled, please contact administrator"

  Scenario: Try to view site entry page without logging in
    Given no user is logged in
    When I go to the home page
    Then I should see "Please log in"

@javascript
  Scenario: Logout
    Given I am logged in with "foobar" role
    When I am on the home page
    And I click on the icon representing "logout"
    Then I should see "Please log in"
    Then I go to the home page
    # i.e. I am truly logged out and cannot access the home page
    Then I should see "Please log in"

@selenium
  Scenario: Login as user with only checkout privileges
    Given a user account with username "Volunteer" and password "password"
    And the user has "checkout_only" role
    And permission is granted for "checkout_only" to go to the "distributions#index" page
    When I go to the root page
    Then I fill in "login" with "Volunteer"
    And I fill in "password" with "password"
    And I press "Log in..."
    And I should see an icon representing "logout"
    And I should not see an icon representing "households"
    And I should not see an icon representing "clients"
    And I should not see an icon representing "checkin"
    And I should not see an icon representing "donations"
    And I should not see an icon representing "admin"

  Scenario: Multiple failed logins exceed the threshold
    Given this scenario is pending
