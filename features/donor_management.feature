Feature: Donor management feature
  As a food pantry staff member
	In order to assign donations to donors
	I want to create/edit/delete donors

  Background: Logged in, with all requisite permissions
    Given I am logged in and on the "home" page
    And permissions are granted for "admin" to visit the following pages:
       | page            |
       | donations#index |
       | donors#new       |
       | donors#create       |

  Scenario: Add a new donor
    Given I am on the donors#new page
		When I fill in the following with Faker values:
			  | Organization  | donor.organization |
			  | Contact name  | donor.contactName  |
			  | Contact title | donor.contactTitle |
			  | Address       | donor.address      |
			  | City          | donor.city         |
			  | Zip           | donor.zip          |
			  | Phone         | donor.phone        |
			  | Fax           | donor.fax          |
			  | Email         | donor.email        |
    And I select options for the following select boxes:
       | field         | value         |
       | donor_state   | donor.state   |
    Then I press "Save"
    Then I should see "New donor saved"
    And I should see "Receive donations into inventory"
    And There should be "1" "donor" in the database

@javascript
	Scenario: Add a new donor without organization attribute
    Given I am on the donors#new page
    When I press "Save"
    Then I should not see "New donor saved"
    And I should see "can't be blank"

@javascript
	Scenario: Add a new donor with duplicate organization attribute
    Given I am on the donors#new page
    And There is a donor organization "Second Harvest" in the database
    And I fill in "Organization" with "Second harvest"
    When I press "Save"
    Then I should see "There is already a donor organization with that name. Donor name must be unique."
    And I should not see "New donor saved"
