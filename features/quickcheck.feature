Feature: Client check in
  As a database user
  In order to know whether a client's qualifications are current
  I want to see a summary of qualifications, and waive them or upload documents
  Background: Logged in, with all requisite permissions
    Given I am logged in and on the "home" page
    And permissions are granted for "admin" to visit the following pages:
          | page                            |
          | households#index                |
          | households#show                 |
          | households#edit                 |
          | households#update               |
          | household_clients#new           |
          | clients#autocomplete            |
          | clients#show                    |
          | clients#index                   |
          | clients#update                  |
          | clients#edit                    |
          | checkins#new                    |
          | checkins#create                 |
          | checkins#create_and_show_client |

@selenium
  Scenario: Visit the quickcheck page
    Given I am on the client quickcheck page
    Then The input field should have focus

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
  Scenario: Follow the document check sequence, and complete it
    Given there is a household with residency, income and govtincome current in the database
    And there is a client with last name "Arbogast", first name "Fanny", age "20", with id date "Date.new(2009,1,1)" in the database belonging to the household
    And I am quickchecking Fanny Arbogast
    And I follow "Warn"
    Then I press "Quickcheck completed"
    Then I should see "Color code is red"
    And Fanny Arbogast should have 1 id warning
    And "Fanny Arbogast" should have 1 client checkin
    And "Fanny Arbogast" should have 1 household checkin
    And "Fanny Arbogast" last client checkin should have "id_warn" "true"
    And "Fanny Arbogast" last household checkin should have "res_warn" "false"
    And "Fanny Arbogast" last household checkin should have "inc_warn" "false"
    And "Fanny Arbogast" last household checkin should have "gov_warn" "false"

@selenium
  Scenario: Follow the document check sequence, for a client with no errors
    Given there is a household with residency, income and govtincome current in the database
    And there is a client with last name "Arbogast", first name "Fanny", age "20", with id date "1.month.ago" in the database belonging to the household
    And I am quickchecking a client without errors, Fanny Arbogast
    Then I should see "Documents for household and clients are current"
    And I should see "Color code is red"
    And "Fanny Arbogast" should have 1 client checkin
    And "Fanny Arbogast" should have 1 household checkin
    And "Fanny Arbogast" last client checkin should have "id_warn" "false"
    And "Fanny Arbogast" last household checkin should have "res_warn" "false"
    And "Fanny Arbogast" last household checkin should have "inc_warn" "false"
    And "Fanny Arbogast" last household checkin should have "gov_warn" "false"

@selenium
  Scenario: Follow the document check sequence, start to upload a document, but then waive the requirement
    Given there is a household with residency, income and govtincome current in the database
    And permission is granted for "admin" to go to the "qualification_documents#upload" page
    And there is a client with last name "Arbogast", first name "Fanny", age "20", with id date "Date.new(2009,1,1)" in the database belonging to the household
    And I am quickchecking Fanny Arbogast
    And I follow "Upload" for "Fanny Arbogast"
    Then I should see a file selector
    Then I press "Cancel"
    Then I should not see a file selector

@selenium
  Scenario: When permission is not granted for document upload
    Given there is a household with residency, income and govtincome expired in the database
    And there is a client with last name "Arbogast", first name "Fanny", age "20", with id date "Date.new(2009,1,1)", and 1 warning, in the database belonging to the household
    And I am quickchecking Fanny Arbogast
    Then There should be no upload links on the page

@selenium
  Scenario: When permission is not granted for document download
    Given there is a household with residency, income and govtincome expired in the database
    And there is a client with last name "Arbogast", first name "Fanny", age "20", with id date "Date.new(2009,1,1)", and 1 warning, in the database belonging to the household
    And I am quickchecking Fanny Arbogast
    Then There should be no document download links on the page

@selenium
  Scenario: When permission is not granted for document delete
    Given there is a household with residency, income and govtincome expired in the database
    And there is a client with last name "Arbogast", first name "Fanny", age "20", with id date "Date.new(2009,1,1)", and 1 warning, in the database belonging to the household
    And I am quickchecking Fanny Arbogast
    Then There should be no document delete links on the page

@selenium
  Scenario: Follow the document check sequence, and upload a document
    Given there is a household with residency, income and govtincome expired in the database
    And permission is granted for "admin" to go to the "qualification_documents#upload" page
    And permission is granted for "admin" to go to the "qualification_documents#show" page
    And permission is granted for "admin" to go to the "qualification_documents#delete" page
    And there is a client with last name "Arbogast", first name "Fanny", age "20", with id date "Date.new(2009,1,1)", and 1 warning, in the database belonging to the household
    And I am quickchecking Fanny Arbogast
    And I follow "Upload" for "Fanny Arbogast"
    Then I should see a file selector
    When I upload a file
    Then I should see "Document saved"
    And Fanny Arbogast should have 0 id warning
    And I should see a view document link for "Fanny Arbogast"
    And I should see a delete document link for "Fanny Arbogast"

@selenium
  Scenario: Follow the document check sequence, upload the final document to complete checkout
    And permission is granted for "admin" to go to the "qualification_documents#upload" page
    And there is a household with residency, income and govtincome current in the database
    And there is a client with last name "Normal", first name "Norman", age "20", with id date "Date.new(2009,1,1)" in the database belonging to the household
    And I am quickchecking Norman Normal
    And I follow "Upload" for "Norman Normal"
    Then I should see a file selector
    When I upload a file
    Then I should see "Document saved"
    And I should see "Quickcheck completed"

@selenium
  Scenario: Navigate away during quickcheck to fix client errors and then return to quickcheck
    Given there is a household with residency, income and govtincome current in the database
    And there is a client with last name "Arbogast", first name "Fanny", age "20", with id date "Date.new(2009,1,1)" in the database belonging to the household
    And there is a client with last name "Normal", first name "Norman", age "20", with id date "Date.new(2009,1,1)" in the database belonging to the household
    And I am quickchecking Fanny Arbogast
    Then The status for "Fanny Arbogast" should be "expired on 1 Jan 2010"
    And I click "Confirm" for "Fanny Arbogast"
    Then The status for "Fanny Arbogast" should be "current"
    When I follow "Arbogast, Fanny. 20"
    Then I should see "Fanny Arbogast" within: "h1"
    And the Id document in the database for Fanny Arbogast should have "confirmed status"
    And the Id document in the database for Fanny Arbogast should have "today's date"
    And there should be 1 client checkin in the database for "Fanny Arbogast"
    And there should be 1 client checkin in the database for "Norman Normal"
    And there should be 1 household checkin in the database for the household
    When I click the browser back button
    Then I should see "Client quick check" within: "h1"
    And The status for "Fanny Arbogast" should be "current"

  Scenario: Navigate away during quickcheck to fix household errors and then return to quickcheck
    Given pending: Navigate away during quickcheck to fix household errors and then return to quickcheck

  Scenario: Navigate away during quickcheck to edit client and then return to quickcheck
    Given pending: Navigate away during quickcheck to edit client and then return to quickcheck

  Scenario: Download a client id document that has been saved
    Given pending: Download a client id document that has been saved

  Scenario: Delete a qualification document
    Given pending: Delete a qualification document

  Scenario: View a qualification document
    Given pending: View a qualification document
