Feature: User activation
  As a database user
  In order to have secure access to the database
  I want to choose my own access parameters

  Scenario: A user who has received an activation email wishes to log in. Forgets to enter login.
    Given I have a user account that has not been activated
    And There is not a privacy policy file available
    When I am on activation url with a valid activation code
    Then I press "Sign up"
    Then I should see "Password can't be blank"
    Then I should see "Password confirmation can't be blank"
    Then I should see "Password is too short"

  Scenario: A user who has received an activation email wishes to log in.
    Given I have a user account that has not been activated
    And There is not a privacy policy file available
    When I am on activation url with a valid activation code
    And I fill in "user_password" with "something"
    And I fill in "user_password_confirmation" with "something"
    Then I press "Sign up"
    Then I should see "Please log in"

  Scenario: A user tries to log in without an activation code
    Given I have a user account that has not been activated
    And There is not a privacy policy file available
    When I am on activation url with no activation code
    Then I should see "Activation code not found"

  Scenario: A user who is already active tries to log in
    Given I have a user account that has been activated
    And There is not a privacy policy file available
    When I am on activation url with a valid activation code
    Then I should see "Your account has already been activated"
    And I should see "Please log in"
