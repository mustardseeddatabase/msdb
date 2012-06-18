Feature: User activation
  As a database user
  In order to have secure access to the database
  I want to choose my own access parameters

@selenium
  Scenario: A user who has received an activation email wishes to log in
    Given I have a user account that has not been activated
    And There is a privacy policy file available
    When I am on activation url with a valid activation code
    And I fill in "user_password" with "something"
    And I fill in "user_password_confirmation" with "something"
    And I press "Next step..."
		Then I should see "indicate your commitment to comply" within: "h2"
    Then I check all 9 checkboxes
    Then I press "Sign up"
    Then I should see "Please log in"

@selenium
  Scenario: A user who has received an activation email wishes to log in, forgets to check boxes
    Given I have a user account that has not been activated
    And There is a privacy policy file available
    When I am on activation url with a valid activation code
    And I fill in "user_password" with "something"
    And I fill in "user_password_confirmation" with "something"
    And I press "Next step..."
		Then I should see "indicate your commitment to comply" within: "h2"
    Then I don't check all checkboxes
    Then I press "Sign up"
		Then I should see "indicate your commitment to comply" within: "h2"
