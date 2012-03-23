Feature: Client management
  As a database user
  In order to add/delete/update clients
  I want to see the pages that facilitate client management

  Background: Logged in, with all requisite permissions
    Given I am logged in and on the "home" page
    And there is a household with residency expired, income expiring and govtincome valid in the database
    And there is a client with last name "Arbogast", first name "Fanny", age "20" in the database belonging to the household, with an ID document
    And there is a client with last name "Heiffetz", first name "Herbert", age "33" in the database belonging to the household, with an ID document
    And there is a client with last name "Gaston", first name "Gary", age "88" in the database belonging to the household, without an ID document
    And "Fanny Arbogast" is not head of household
    And "Herbert Heiffetz" is head of household
    And "Gary Gaston" is not head of household
		And there is a client with last name "Normal", first name "Norman", age "50" in the database with no household
    And permissions are granted for "admin" to visit the following pages:
      | page |
      | households#index |
      | households#edit |
      | households#update |
      | household_clients#new |
      | household_clients#update |
      | household_clients#create |
      | clients#autocomplete |
      | clients#show |
      | clients#index |
      | clients#update |
      | clients#quickcheck |
      | clients#new |
      | clients#create |
      | clients#edit |
      | clients#destroy |

  Scenario: Add a client to a household
    Given I am on the households#edit page
    When I follow "Add resident..."
    Then I should see "Add resident to household" within: "h1"
    And I should see "121 Apple Lane"
    And I should see "Pendleton"
    And I should see "10101"

@selenium
  Scenario: Add existing client to a household, client name autocomplete
    Given I am on the household_clients#new page
    When I follow "Add resident from existing clients..."
    Then I should see "Find existing client"
    Then I fill in "lastName" with "gas"
    Then I should see "Arbogast, Fanny. 20"
    And I should see "Gaston, Gary"
    Then I click "Arbogast, Fanny. 20"
    Then I should see "Current temporary residence:"
    And I should see "Current permanent residence:"
    When I follow "Add to household"
    Then I should see "Edit household"

@selenium
  Scenario: Add to a household and existing client who does not currently have a household
    Given I am on the household_clients#new page
    When I follow "Add resident from existing clients..."
    Then I should see "Find existing client"
    Then I fill in "lastName" with "norm"
    Then I should see "Normal, Norman. 50"
		Then I click "Normal, Norman. 50"
    Then I should see "not known"
    When I follow "Add to household"
    Then I should see "Edit household"
		And I should see "Normal, Norman"

@selenium
  Scenario: Add a new client to a household
    Given I am on the household_clients#new page
    When I follow "Add a new client..."
    Then I should see "First name"
    And I should see "Last name"
    And I should see "Head of household"
    And I should see a "Save" button
    When I fill in "client_firstName" with "Herbert"
    And I fill in "client_lastName" with "Hagenflick"
		And I select "2001-1-1" as the "Birthdate" date
    And I press "Save"
    Then I should see "New client added"

@selenium
  Scenario: Add a new client, head of household, to a household that already has a head of household
    Given "Fanny Arbogast" is head of household
    And I am on the household_clients#new page
    When I follow "Add a new client..."
    Then I should see "First name"
    And I should see "Last name"
    And I should see "Head of household"
    And I should see a "Save" button
    When I fill in "client_firstName" with "Herbert"
    And I fill in "client_lastName" with "Hagenflick"
		And I select "2001-1-1" as the "Birthdate" date
    And I check "Head of household"
    Then I should see "There is already designated a head of household." within: ".message"
    And I should see "Checking this checkbox replaces current head of household" within: ".message"
    When I press "Save"
    Then I should see "(head of household)" for "Hagenflick, Herbert"
    And I should not see "(head of household)" for "Arbogast, Fanny"

@selenium
  Scenario: Add a new invalid client to a household
    Given I am on the household_clients#new page
    When I follow "Add a new client..."
    Then I should see "First name"
    And I should see "Last name"
    And I should see "Head of household"
    And I should see a "Save" button
    When I fill in "client_firstName" with "Herbert"
    And I fill in "client_lastName" with "Hagenflick"
    And I press "Save"
    Then I should see "Birthdate can't be blank"
    And I should see "First name"
    And I should see "Last name"
    And "First name" should have value "Herbert"
    And "Last name" should have value "Hagenflick"

	Scenario: Add new client
		Given I am on the clients#index page
		When I follow "Add new client..."
		Then I should see "Add a new client"
		Then I fill in the following with Faker values:
			 | client_firstName       | client.firstName         |
			 | client_mi              | client.mi                |
			 | client_lastName        | client.lastName          |
		 And I select dates for the following fields:
		    | field     | value      |
		    | Birthdate | '1922,1,1' |
		 And I select options for the following select boxes:
        | field         | value         |
		    | client_race   | client.race   |
		    | client_gender | client.gender |
		 And I check "Head of household?"
		 Then I press "Save"
		 Then I should see "New client created"
     And There should be "5" "clients"

@selenium
	Scenario: Add invalid client, with blank name fields
		Given I am on the clients#index page
		When I follow "Add new client..."
		Then I should see "Add a new client"
		Then I fill in the following with Faker values:
			 | client_mi              | client.mi                |
			 | client_lastName        | client.lastName          |
		 And I select options for the following select boxes:
        | field         | value         |
		    | client_race   | client.race   |
		    | client_gender | client.gender |
		 And I check "Head of household?"
		 Then I press "Save"
		 Then I should see "can't be blank"
     And I should see "Add a new client" within: "h1"

@selenium
	Scenario: Add invalid client, with future birthdate
		Given I am on the clients#index page
		When I follow "Add new client..."
		Then I should see "Add a new client"
		Then I fill in the following with Faker values:
			 | client_mi              | client.mi                |
			 | client_firstName        | client.firstName          |
			 | client_lastName        | client.lastName          |
			 # the next step will cause this test to fail when it's run on
			 # 12/31 in any year!
		 And I select dynamic dates for the following fields:
		    | field     | value      |
		    | Birthdate |  (Date.today.year).to_s+'-12-31' |
		 And I select options for the following select boxes:
        | field         | value         |
		    | client_race   | client.race   |
		    | client_gender | client.gender |
		 And I check "Head of household?"
		 Then I press "Save"
     And I should see "Birthdate cannot be in the future"
     And I should see "Add a new client" within: "h1"

@selenium
	Scenario: Add duplicate client
		Given I am on the clients#index page
    And The birthdate of Fanny Arbogast in the database is "1991-7-28"
		When I follow "Add new client..."
		Then I should see "Add a new client"
		Then I fill in "First name" with "Fanny"
		And  I fill in "Last name" with "Arbogast"
    And I select "1991-7-28" as the "Birthdate" date
		Then I press "Save"
		Then I should see "Fanny Arbogast is already in the database"
    And I should see "Add a new client" within: "h1"

@selenium
	Scenario: Edit client information
    Given I am on the client#show page for "Fanny Arbogast"
    When I follow "Edit this client"
    Then I should see "Edit Fanny Arbogast"
    When I select "1991-7-28" as the "Birthdate" date
    Then I press "Save"
    Then I should see "1991-07-28"

@selenium
	Scenario: Edit client information, designate as head of household which already has a household head
    Given I am on the client#show page for "Fanny Arbogast"
    When I follow "Edit this client"
    Then I should see "Edit Fanny Arbogast"
    And I check "Head of household"
    Then I should see "There is already designated a head of household." within: ".message"

@selenium
	Scenario: Edit client information, designate as head of household which already has a household head, and save
    Given I am on the client#show page for "Fanny Arbogast"
    When I follow "Edit this client"
    Then I should see "Edit Fanny Arbogast"
    And I check "Head of household"
    When I press "Save"
    Then "Fanny Arbogast" should be head of household
    And The household should have exactly one head

@selenium
	Scenario: Edit client information, remove head of household designation of a client who is sole head
    Given I am on the client#show page for "Herbert Heiffetz"
    When I follow "Edit this client"
    Then I should see "Edit Herbert Heiffetz"
    And I uncheck "Head of household"
    Then I should see "Head of household status cannot be removed." within: ".message"
    And I should see "Instead, assign another household member as head." within: ".message"
    When I press "Save"
    Then I should see "Edit Herbert Heiffetz"

@selenium
	Scenario: Edit client information, remove head of household designation of a client who is one of multiple heads
    Given there is a client with last name "Hansen", first name "Henry", age "23" in the database belonging to the household, with an ID document, head of household
    And I am on the client#show page for "Herbert Heiffetz"
    When I follow "Edit this client"
    Then I should see "Edit Herbert Heiffetz"
    And I uncheck "Head of household"
    Then I should not see "Head of household status cannot be removed." within: "#client_form"
    And I should not see "Instead, assign another household member as head." within: "#client_form"
    When I press "Save"
    Then I should see "Client updated"

@selenium
  Scenario: Find client information from client name autocomplete
    Given I am on the clients#index page
    And I fill in "lastName" with "gas"
    Then I should see "Arbogast, Fanny. 20"
    When I click "Arbogast, Fanny. 20"
    Then I should see "Fanny Arbogast" within: "h1"
    And I should see a link to "View household"
    And I should see a link to "View ID document"

@selenium
  Scenario: Show client page when client does not have an ID document on file
    Given I am on the client#show page for "Gary Gaston"
    Then I should see "Gary Gaston" within: "h1"
    And I should see a link to "View household"
    And I should not see a link to "View ID document"

@selenium
  Scenario: Show client page for head of housheold and try to delete
    Given I am on the client#show page for "Herbert Heiffetz"
    When I follow "Delete this client"
    Then I should see "Head of household cannot be deleted." within: ".message"
    And I should see "Please designate a new head of household first." within: ".message"
    And I should not see "Client deleted"

@selenium
  Scenario: Show client page for non head of household and delete
    Given I am on the clients#index page
    And I fill in "lastName" with "gas"
    Then I should see "Arbogast, Fanny. 20"
    When I click "Arbogast, Fanny. 20"
    Then I should see "Fanny Arbogast" within: "h1"
    When I follow "Delete"
    And I confirm the popup
    Then I should see "Client Fanny Arbogast deleted"
    And I should see "Find client" within: "h1"
    And "Fanny Arbogast" should not be in the database
