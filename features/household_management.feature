Feature: Household management feature
  As a database owner
  In order to manage interactions with households
  I want to add, update, and study the records of households

  Background: Logged in, with all requisite permissions
    Given I am logged in and on the "households#index" page
    And permissions are granted for "admin" to visit the following pages:
       | page                      |
       | households#index          |
       | households#new            |
       | households#create         |
       | households#edit           |
       | households#show           |
       | households#update         |
       | households#destroy        |
       | clients#index             |
       | clients#autocomplete      |
       | clients#show              |
       | clients#destroy           |
       | household_clients#destroy |
       | addresses#autocomplete    |

@selenium
  Scenario: Add a new household
    When I follow "Add new household"
    Then I should see "Add a new household"
    And I fill in the following with Faker values:
           | household_perm_address_attributes_address | household.permanent_address |
           | household_perm_address_attributes_city    | household.permanent_city    |
           | household_perm_address_attributes_zip     | household.permanent_zip     |
           | household_perm_address_attributes_apt     | household.permanent_apt     |
           | household_temp_address_attributes_address | household.temporary_address |
           | household_temp_address_attributes_city    | household.temporary_city    |
           | household_temp_address_attributes_zip     | household.temporary_zip     |
           | household_temp_address_attributes_apt     | household.temporary_apt     |
           | household_phone                           | household.phone             |
           | household_email                           | household.email             |
           | household_income                          | household.income            |
           | household_otherConcerns                   | household.otherConcerns     |
    And I check the following:
           | field                                    |
           | household_ssi                            |
           | household_medicaid                       |
           | household_homeless                       |
           | household_physDisabled                   |
           | household_mentDisabled                   |
           | household_singleParent                   |
           | household_vegetarian                     |
           | household_diabetic                       |
           | household_retired                        |
           | household_unemployed                     |
           | household_res_qualdoc_attributes_confirm |
           | household_res_qualdoc_attributes_vi      |
           | household_inc_qualdoc_attributes_confirm |
           | household_inc_qualdoc_attributes_vi      |
           | household_gov_qualdoc_attributes_confirm |
           | household_gov_qualdoc_attributes_vi      |
           | household_usda                           |
    And I select dates for the following fields:
          | field                               | value      |
          | Residency confirmation date         | '2010,1,1' |
          | Income confirmation date            | '2010,1,1' |
          | Government income confirmation date | '2010,1,1' |
    And I press "Save"
    Then I should see "New household was saved"
    And There should be "1" "household"

@selenium 
  Scenario: Edit a household, save and return to the list from which it was selected for editing
    Given I am on the households#index page
    And there are households with cities "Paris Texas" and "Paris Hilton", with no temporary addresses, in the database
    When I fill in "city" with "Paris"
    And I press "Find matching household(s)..."
    When I follow "Edit" for household "Paris Texas"
    Then I should see "Edit household information"
    Then I fill in "household_temp_address_attributes_address" with "777 Route 66"
    And I press "Save"
    Then I should see "Find household" within: "h1"
    Then I should see "Paris Texas" within: "#households"
    Then I should see "Paris Hilton" within: "#households"
    Then I follow "Show" for household "Paris Texas"
    Then I should see "777 Route 66"

@selenium
  Scenario: Edit a household and upload a qualification document
    Given I am on the households#index page
    And there are households with cities "Paris Texas" and "Paris Hilton", with no temporary addresses, in the database
    When I fill in "city" with "Paris"
    And I press "Find matching household(s)..."
    When I follow "Edit" for household "Paris Texas"
    Then I should see "Edit household information"
    And I follow "Upload new residency verification document..."
    Then I should see a file selector
    When I press "Save"
    Then I should see "Household was updated"

@selenium
  Scenario: Remove a client who is not household head from a household
    Given there is a household with residency expired, income expiring and govtincome valid in the database
    And there is a client with last name "Arbogast", first name "Fanny", age "20" in the database belonging to the household, with an ID document, not head of household
    And there is a client with last name "Gaston", first name "Gary", age "88" in the database belonging to the household, without an ID document
    And I am on the households#edit page
    Then I should see "Edit household information"
    And I should see 2 residents in the household
    When I follow the link to remove "Arbogast, Fanny" as resident
    Then I confirm the popup
    Then I should see 1 resident in the household
    And I should see "removed from this household"

@selenium
  Scenario: Remove a client who is sole head of household
    Given there is a household with residency expired, income expiring and govtincome valid in the database
    And there is a client with last name "Arbogast", first name "Fanny", age "20" in the database belonging to the household, with an ID document
    And there is a client with last name "Gaston", first name "Gary", age "88" in the database belonging to the household, without an ID document
    And "Fanny Arbogast" is head of household
    And "Gary Gaston" is not head of household
    And I am on the households#edit page
    Then I should see "Edit household information"
    And I should see 2 residents in the household
    When I follow the link to remove "Arbogast, Fanny" as resident
    Then I should see "Head of household cannot be removed." within: ".message"
    And I should see "Please designate a new head of household first." within: ".message"

@selenium
  Scenario: Remove a client who is one of multiple heads of household
    Given there is a household with residency expired, income expiring and govtincome valid in the database
    And there is a client with last name "Arbogast", first name "Fanny", age "20" in the database belonging to the household, with an ID document, head of household
    And there is a client with last name "Gaston", first name "Gary", age "88" in the database belonging to the household, with an ID document, head of household
    And I am on the households#edit page
    Then I should see "Edit household information"
    And I should see 2 residents in the household
    When I follow the link to remove "Arbogast, Fanny" as resident
    Then I confirm the popup
    Then I should see 1 resident in the household
    And I should see "removed from this household"

@selenium
  Scenario: Delete a client who is sole head of household, and return to household page
    Given there is a household with residency expired, income expiring and govtincome valid in the database
    And there is a client with last name "Arbogast", first name "Fanny", age "20" in the database belonging to the household, with an ID document
    And there is a client with last name "Gaston", first name "Gary", age "88" in the database belonging to the household, without an ID document
    And "Fanny Arbogast" is head of household
    And "Gary Gaston" is not head of household
    And I am on the households#show page
    When I follow "Arbogast, Fanny"
    Then I should see "Delete this client"
    When I follow "Delete this client"
    Then I should see "Head of household cannot be deleted." within: ".message"
    And I should see "Please designate a new head of household first." within: ".message"

@selenium
  Scenario: Delete a client who is one of multiple heads of household, and return to household page
    Given there is a household with residency expired, income expiring and govtincome valid in the database
    And there is a client with last name "Arbogast", first name "Fanny", age "20" in the database belonging to the household, with an ID document, head of household
    And there is a client with last name "Gaston", first name "Gary", age "88" in the database belonging to the household, with an ID document, head of household
    And I am on the households#show page
    When I follow "Arbogast, Fanny"
    Then I should see "Delete this client"
    When I follow "Delete this client"
    And I confirm the popup
    Then I should see "Client Fanny Arbogast deleted"
    Then I should see "Household information" within: "h1"

@selenium
  Scenario: Delete a client who is not head of household, and return to household page
    Given there is a household with residency expired, income expiring and govtincome valid in the database
    And there is a client with last name "Arbogast", first name "Fanny", age "20" in the database belonging to the household, with an ID document, not head of household
    And there is a client with last name "Gaston", first name "Gary", age "88" in the database belonging to the household, without an ID document
    And I am on the households#show page
    When I follow "Arbogast, Fanny"
    Then I should see "Delete this client"
    When I follow "Delete this client"
    And I confirm the popup
    Then I should see "Client Fanny Arbogast deleted"
    Then I should see "Household information" within: "h1"

@selenium
  Scenario: Add a new household, cancel without saving
    When I go to the households#index page
    And I follow "Add new household"
    Then I should see "Add a new household"
    And I follow "Cancel"
    Then I should see "Find household"

  Scenario: Add invalid household
    When I follow "Add new household"
    Then I should see "Add a new household"
    And I fill in the following with Faker values:
           | household_perm_address_attributes_address |                          | 
           | household_perm_address_attributes_city    |                          | 
           | household_perm_address_attributes_zip     |                          | 
           | household_perm_address_attributes_apt     | household.permanent_apt  | 
           | household_temp_address_attributes_address |                          | 
           | household_temp_address_attributes_city    |                          | 
           | household_temp_address_attributes_zip     |                          | 
           | household_temp_address_attributes_apt     | household.temporary_apt  | 
           | household_phone                           | household.phone          | 
           | household_email                           | household.email          | 
           | household_income                          | household.income         | 
           | household_otherConcerns                   | household.otherConcerns  | 
    And I select dates for the following fields:
          | field                               | value      |
          | Residency confirmation date         | '2010,1,1' |
          | Income confirmation date            | '2010,1,1' |
          | Government income confirmation date | '2010,1,1' |
    And I press "Save"
    Then I should see "Add a new household"
    And I should see "A household must have either a permanent or a temporary address"
    And There should be "0" "households"

@selenium
  Scenario: Go from retrieved list to edit page
    Given I am on the households#index page
    And there are households with cities "Paris Texas" and "Paris Hilton" in the database
    When I fill in "city" with "Paris"
    And I press "Find matching household(s)..."
    When I follow "Edit" for household "Paris Texas"
    Then I should see "Edit household information"

@selenium
  Scenario: Go from retrieved list to show page
    Given I am on the households#index page
    And there are households with cities "Paris Texas" and "Paris Hilton" in the database
    When I fill in "city" with "Paris"
    And I press "Find matching household(s)..."
    When I follow "Show" for household "Paris Texas"
    Then I should see "Household information"

@selenium
  Scenario: Delete a household from the show page
    Given I am on the households#index page
    And there are households with cities "Paris Texas" and "Paris Hilton" in the database
    When I fill in "city" with "Paris"
    And I press "Find matching household(s)..."
    When I follow "Show" for household "Paris Texas"
    Then I should see "Household information"
    When I follow "Delete this household"
    Then I confirm the popup
    Then I should see "Household deleted"
    And I should see "Find household"

@selenium
  Scenario: Edit a household from the show page
    Given I am on the households#index page
    And there are households with cities "Paris Texas" and "Paris Hilton" in the database
    When I fill in "city" with "Paris"
    And I press "Find matching household(s)..."
    When I follow "Show" for household "Paris Texas"
    Then I should see "Household information"
    When I follow "Edit this household"
    Then I should see "Edit household information"
    When I press "Save"
    Then I should see "Household was updated"
    And I should see "Household information"

@selenium
  Scenario: Visit households#index page without query parameters
    Given I am on the households#index page
    Then I should see no query results

@selenium
  Scenario: Visit households#index page with query parameters
    Given there are households with cities "Paris Texas" and "Paris Hilton" in the database
    And I visit the "households#index" page with query string "household_search[city]=Paris"
    Then I should see "Paris Texas" within: "#households"
    Then I should see "Paris Hilton" within: "#households"

@selenium
  Scenario: Ajax with back button, staying within the index page
    Given I am on the households#index page
    And there are households with cities "Paris Texas" and "Paris Hilton" in the database
    And there are households with cities "Romford" and "Rome" in the database
    When I fill in "city" with "Paris"
    And I press "Find matching household(s)..."
    Then I should see "Paris Texas" within: "#households"
		And I should see "Paris Hilton" within: "#households"
    Then I fill in "city" with "rom"
    And I press "Find matching household(s)..."
    Then I should see "Romford" within: "#households"
		And I should see "Rome" within: "#households"
    Then I click the back button
    Then I should see "Paris Texas" within: "#households"
		And I should see "Paris Hilton" within: "#households"
    Then I click the forward button
    Then I should see "Romford" within: "#households"
		And I should see "Rome" within: "#households"

@selenium
  Scenario: Ajax with back button, navigating away from the index page
    Given I am on the households#index page
    And there are households with cities "Paris Texas" and "Paris Hilton" in the database
    When I fill in "city" with "Paris"
    And I press "Find matching household(s)..."
    Then I should see "Paris Texas" within: "#households"
		And I should see "Paris Hilton" within: "#households"
    When I follow "Show" for household "Paris Texas"
    Then I should see "Household information"
    Then I click the back button
    Then I should see "Paris Texas" within: "#households"
		And I should see "Paris Hilton" within: "#households"
    Then I click the forward button
    Then I should see "Household information"

@selenium
  Scenario: Edit a household, adding invalid attributes
    Given I am on the households#index page
    And there are households with cities "Paris Texas" and "Paris Hilton" in the database
    When I fill in "city" with "Paris"
    And I press "Find matching household(s)..."
    When I follow "Edit" for household "Paris Texas"
    Then I should see "Edit household information"
    And I fill in the following with Faker values:
           | household_perm_address_attributes_address |  | 
           | household_perm_address_attributes_city    |  | 
           | household_perm_address_attributes_zip     |  | 
           | household_perm_address_attributes_apt     |  | 
           | household_temp_address_attributes_address |  | 
           | household_temp_address_attributes_city    |  | 
           | household_temp_address_attributes_zip     |  | 
           | household_temp_address_attributes_apt     |  | 
           | household_phone                           |  | 
           | household_email                           |  | 
    And I press "Save"
    Then I should see "A household must have either a permanent or a temporary address"


@selenium
  Scenario: Edit a household, cancel and return to the list from which it was selected for editing
    Given I am on the households#index page
    And there are households with cities "Paris Texas" and "Paris Hilton" in the database
    When I fill in "city" with "Paris"
    And I press "Find matching household(s)..."
    When I follow "Edit" for household "Paris Texas"
    Then I should see "Edit household information"
    And I follow "Cancel"
    Then I should see "Find household" within: "h1"
    Then I should see "Paris Texas" within: "#households"
    Then I should see "Paris Hilton" within: "#households"

@selenium
  Scenario: View household information for a household with qualification documents
    Given there is a household with all three qualification documents in the database
    When I am on the households#show page
    Then I should see "View residency verification information"
    And I should see "View income verification information"
    And I should see "View government income verification information"
