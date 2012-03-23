Feature: Client check in
  As a database user
  In order to know whether a client's qualifications are current
  I want to see a summary of qualifications, and waive them or upload documents
  Background: Logged in, with all requisite permissions
    Given I am logged in and on the "home" page
    And permissions are granted for "admin" to visit the following pages:
      | page |
      | households#index |
      | households#show |
      | households#edit |
      | households#update |
      | household_clients#new |
      | clients#autocomplete |
      | clients#show |
      | clients#index |
      | clients#update |
      | qualification_documents#index |
      | qualification_documents#update |

@selenium
  Scenario: Follow the document check sequence, and follow links to related information
    Given there is a household with residency, income and govtincome current in the database
    And there is a client with last name "Arbogast", first name "Fanny", age "20", with id date "Date.new(2009,1,1)" in the database belonging to the household
    And I am quickchecking Fanny Arbogast
    Then I should see a link to "Arbogast, Fanny. 20"
    And I should see a link to "View household"
    When I follow "View household"
    Then I should see "Household information" within: "h1"
    When I click the browser back button
    Then I should see a link to "Arbogast, Fanny. 20"
    When I follow "Arbogast, Fanny. 20"
    Then I should see "Fanny Arbogast" within: "h1"
    When I click the browser back button
    Then I should see "Client quick check" within: "h1"
    And I should see a link to "Arbogast, Fanny. 20"

@selenium
  Scenario: Quickcheck client
    Given I am on the client quickcheck page
    And there is a household with residency expired, income expiring and govtincome valid in the database
    And there is a client with last name "Arbogast", first name "Fanny", age "20" in the database belonging to the household
    And there is a client with last name "Gaston", first name "Gary", age "88" in the database belonging to the household
    And I fill in "lastName" with "gas"
    Then I should see "Arbogast, Fanny. 20"
    When I click "Arbogast, Fanny. 20"
    Then I should see "Permanent address"
    And I should see "Temporary address"
    And I should see that the residency information has expired
    And I should see that the income information is expiring
    And I should see that the govt income information is valid

@selenium
  Scenario: Follow the document check sequence
    Given there is a household with residency, income and govtincome expired in the database
    And there is a client with last name "Arbogast", first name "Fanny", age "20", with id date "Date.new(2009,1,1)" in the database belonging to the household
    And I am quickchecking Fanny Arbogast
    Then I should see "Date expired: Identification verification information expired on 1 Jan 2010 for Fanny Arbogast"
    And I should see "Upload new identification verification document"
    And I should see "Warn and waive requirement, this visit"
    And I should see "0" warnings for "Arbogast, Fanny"
    Then I follow "Warn and waive requirement, this visit"
    Then I should see "1" warnings for "Arbogast, Fanny"
    And I should see "Residency verification information expired"
    And I should see "Upload new residency verification document"
    And I should see "0" warnings for "Residency verification information"
    And I should see "0" warnings for "Income verification information"
    And I should see "0" warnings for "Residency verification information"
    Then I follow "Warn and waive requirement, this visit"
    And I should see "1" warnings for "Residency verification information"
    And I should see "Upload new income verification document"
    Then I follow "Warn and waive requirement, this visit"
    And I should see "1" warnings for "Income verification information"
    And I should see "Upload new government income verification document"
    Then I follow "Warn and waive requirement, this visit"
    And I should see "1" warnings for "Government income verification information"

@selenium
  Scenario: Follow the document check sequence, and complete it
    Given there is a household with residency, income and govtincome current in the database
    And there is a client with last name "Arbogast", first name "Fanny", age "20", with id date "Date.new(2009,1,1)" in the database belonging to the household
    And I am quickchecking Fanny Arbogast
    And I follow "Warn and waive requirement, this visit"
    Then I press "Quickcheck completed"
    Then I should see "Color code is red"
    And Fanny Arbogast should have 1 id warning
    And "Fanny Arbogast" should have 1 checkin
    And "Fanny Arbogast" last checkin should have "id_warn" "true"
    And "Fanny Arbogast" last checkin should have "res_warn" "false"
    And "Fanny Arbogast" last checkin should have "inc_warn" "false"
    And "Fanny Arbogast" last checkin should have "gov_warn" "false"

@selenium
  Scenario: Follow the document check sequence, for a client with no errors
    Given there is a household with residency, income and govtincome current in the database
    And there is a client with last name "Arbogast", first name "Fanny", age "20", with id date "1.month.ago" in the database belonging to the household
    And I am quickchecking a client without errors, Fanny Arbogast
    Then I should see "Documents for household and clients are current"
    And I should see "Color code is red"
    And "Fanny Arbogast" should have 1 checkin
    And "Fanny Arbogast" last checkin should have "id_warn" "false"
    And "Fanny Arbogast" last checkin should have "res_warn" "false"
    And "Fanny Arbogast" last checkin should have "inc_warn" "false"
    And "Fanny Arbogast" last checkin should have "gov_warn" "false"

@selenium
  Scenario: Follow the document check sequence, start to upload a document, but then waive the requirement
    Given there is a household with residency, income and govtincome current in the database
    And there is a client with last name "Arbogast", first name "Fanny", age "20", with id date "Date.new(2009,1,1)" in the database belonging to the household
    And I am quickchecking Fanny Arbogast
    And I follow "Upload new identification verification document..."
    Then I should see a file selector
    Then I follow "Warn and waive requirement, this visit"
    Then I should not see a file selector

@selenium
  Scenario: Follow the document check sequence, and upload a document
    Given there is a household with residency, income and govtincome expired in the database
    And there is a client with last name "Arbogast", first name "Fanny", age "20", with id date "Date.new(2009,1,1)", and 1 warning, in the database belonging to the household
    And I am quickchecking Fanny Arbogast
    And I follow "Upload new identification verification document..."
    Then I should see a file selector
    When I upload a file
    Then I should see "Document saved"
    And Fanny Arbogast should have 0 id warning
    And I should see a link to "View ID document"

@selenium
  Scenario: Follow the document check sequence, and upload a document, forgetting to select a file
    Given there is a household with residency, income and govtincome current in the database
    And there is a client with last name "Arbogast", first name "Fanny", age "20", with id date "Date.new(2009,1,1)" in the database belonging to the household
    And I am quickchecking Fanny Arbogast
    And I follow "Upload new identification verification document..."
    Then I should see a file selector
    When I press "Upload file"
    Then I should see "You must first select a file to upload"

# TODO CHECK THIS, it can't be working. It probably appears to work b/c
# Factory(:id_qualdoc) includes a qualification document already, before 
# even a document is uploaded
@selenium
  Scenario: Follow the document check sequence, upload the final document to complete checkout
    Given there is a household with residency, income and govtincome current in the database
    And there is a client with last name "Normal", first name "Norman", age "20", with id date "Date.new(2009,1,1)" in the database belonging to the household
    And I am quickchecking Norman Normal
    And I follow "Upload new identification verification document..."
    Then I should see a file selector
    When I upload a file
    Then I should see "Document saved"
    Then I should see "Documents for household and clients are current"
    And I should see "Color code is red"


@selenium
  Scenario: Follow the document check sequence, test that checkins are recorded
    Given there is a household with residency, income and govtincome expired in the database
    And there is a client with last name "Arbogast", first name "Fanny", age "20", with id date "Date.new(2009,1,1)" in the database belonging to the household
    And there is a client with last name "Gaston", first name "Gary", age "88", with id date "Date.new(2009,1,1)" in the database belonging to the household
    And I am quickchecking Fanny Arbogast
    Then I should see "Identification verification information expired"
    When I follow "Warn and waive requirement, this visit"
    Then I should see "Identification verification information expired"
    When I follow "Warn and waive requirement, this visit"
    Then I should see "Residency verification information expired"
    And I should see "0" warnings for "Residency verification information"
    When I follow "Warn and waive requirement, this visit"
    Then I should see "1" warnings for "Residency verification information"
    When I follow "Warn and waive requirement, this visit"
    Then I should see "1" warnings for "Income verification information"
    When I follow "Warn and waive requirement, this visit"
    Then I should see "1" warnings for "Government income verification information"
    When I press "Quickcheck completed"
		Then I should see "Quickcheck complete"
    And there should be "2" "checkins" in the database
