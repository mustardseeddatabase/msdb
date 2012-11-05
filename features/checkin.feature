Feature: Client check in
  As a database user
  In order to know whether a client's qualifications are current
  I want to see a summary of qualifications, and waive them or upload documents
  Background: Logged in, with all requisite permissions
    Given I am logged in and on the "home" page
    And permissions are granted for "admin" to visit the following pages:
           | page                               |
           | households#index                   |
           | households#show                    |
           | households#edit                    |
           | households#update                  |
           | household_clients#new              |
           | clients#autocomplete               |
           | clients#show                       |
           | clients#index                      |
           | clients#update                     |
           | clients#edit                       |
           | checkins#new                       |
           | checkins#edit                      |
           | checkins#create                    |
           | checkins#update                    |
           | checkins#update_and_show_client    |
           | checkins#update_and_show_household |

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
    And permission is granted for "admin" to go to the "qualification_documents#create" page
    And permission is granted for "admin" to go to the "qualification_documents#update" page
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

@selenium @allow-rescue
  Scenario: Follow the document check sequence, and upload an id document, when client did not previously have one
    Given there is a household with residency, income and govtincome expired in the database
    And permission is granted for "admin" to go to the "qualification_documents#create" page
    And permission is granted for "admin" to go to the "qualification_documents#show" page
    And permission is granted for "admin" to go to the "qualification_documents#delete" page
    And there is a client with last name "Arbogast", first name "Fanny", with no id document in the database
    And I am quickchecking Fanny Arbogast
    And I follow "Upload" for "Fanny Arbogast"
    Then I should see a file selector
    When I upload a file
    Then I should see "Document saved"
    And Fanny Arbogast should have 0 id warning
    And I should see a view document link for "Fanny Arbogast"
    And I should see a delete document link for "Fanny Arbogast"

@selenium @allow-rescue
  Scenario: Follow the document check sequence, and upload an id document, replacing previous document
    Given there is a household with residency, income and govtincome expired in the database
    And permission is granted for "admin" to go to the "qualification_documents#update" page
    And permission is granted for "admin" to go to the "qualification_documents#show" page
    And permission is granted for "admin" to go to the "qualification_documents#delete" page
    And there is a client with last name "Arbogast", first name "Fanny", age "20", with id date "Date.new(2009,1,1)", and 1 warning, in the database belonging to the household
    And I am quickchecking Fanny Arbogast
    And I follow "Upload" for "Fanny Arbogast"
    Then I should see a file selector
    When I upload a file
    Then I should see "Document saved"
    And Fanny Arbogast should have 0 id warning

@selenium
  Scenario: Follow the document check sequence, upload the final document to complete checkout
    Given permission is granted for "admin" to go to the "qualification_documents#create" page
    And permission is granted for "admin" to go to the "qualification_documents#update" page
    And there is a household with residency, income and govtincome current in the database
    And there is a client with last name "Normal", first name "Norman", age "20", with id date "Date.new(2009,1,1)" in the database belonging to the household
    And I am quickchecking Norman Normal
    And I follow "Upload" for "Norman Normal"
    Then I should see a file selector
    When I upload a file
    Then I should see "Document saved"
    And I should see "Quickcheck completed"

@selenium
  Scenario: Navigate to show client during quickcheck and then return to quickcheck
    Given there is a household with residency, income and govtincome current in the database
    And there is a client with last name "Arbogast", first name "Fanny", age "20", with id date "Date.new(2009,1,1)" in the database belonging to the household
    And there is a client with last name "Normal", first name "Norman", age "20", with id date "Date.new(2009,1,1)" in the database belonging to the household
    And I am quickchecking Fanny Arbogast
    Then The status for "Fanny Arbogast" should be "expired on 1 Jan 2010"
    And The id document for "Fanny Arbogast" should exist
    And The id document for "Norman Normal" should exist
    Then I click "Confirm" for "Fanny Arbogast"
    And I click "Warn" for "Norman Normal"
    Then The status for "Fanny Arbogast" should be "current"
    And there should be an unwarn link for "Normal, Norman. 20"
    And the number of warnings for "Normal, Norman. 20" should be 1
    When I follow "Normal, Norman. 20"
    Then I should see "Norman Normal" within: "h1"
    And the Id document in the database for Fanny Arbogast should have "confirmed status"
    And the Id document in the database for Fanny Arbogast should have "today's date"
    And there should be 1 client checkin in the database for "Fanny Arbogast"
    And there should be 1 client checkin in the database for "Norman Normal"
    And the client checkin for "Norman Normal" should have id_warn true
    And there should be 1 household checkin in the database for the household
    And view household hyperlink should be disabled
    And delete client hyperlink should be disabled
    And document hyperlinks should be disabled
    And recent checkins client hyperlinks should be disabled
    And I should see a "Return to checkin" button
    When I click the browser back button
    Then I should see "Client quick check" within: "h1"
    And The status for "Fanny Arbogast" should be "current"
    And the number of warnings for "Normal, Norman. 20" should be 1
    And there should be an unwarn link for "Normal, Norman. 20"

@selenium
  Scenario: Navigate to show household during quickcheck and then return to quickcheck
    Given there is a household with residency, income and govtincome current in the database
    And there is a client with last name "Arbogast", first name "Fanny", age "20", with id date "Date.new(2009,1,1)" in the database belonging to the household
    And there is a client with last name "Normal", first name "Norman", age "20", with id date "Date.new(2009,1,1)" in the database belonging to the household
    And I am quickchecking Fanny Arbogast
    Then The status for "Fanny Arbogast" should be "expired on 1 Jan 2010"
    And I click "Confirm" for "Fanny Arbogast"
    And I click "Warn" for "Norman Normal"
    Then The status for "Fanny Arbogast" should be "current"
    And there should be an unwarn link for "Normal, Norman. 20"
    And the number of warnings for "Normal, Norman. 20" should be 1
    When I follow "View household"
    Then I should see "Household information" within: "h1"
    And the Id document in the database for Fanny Arbogast should have "confirmed status"
    And the Id document in the database for Fanny Arbogast should have "today's date"
    And there should be 1 client checkin in the database for "Fanny Arbogast"
    And there should be 1 client checkin in the database for "Norman Normal"
    And the client checkin for "Norman Normal" should have id_warn true
    And there should be 1 household checkin in the database for the household
    And delete household hyperlink should be disabled
    And resident hyperlinks should be disabled
    And document hyperlinks should be disabled
    And I should see a "Return to checkin" button
    When I click the browser back button
    Then I should see "Client quick check" within: "h1"
    And The status for "Fanny Arbogast" should be "current"
    And the number of warnings for "Normal, Norman. 20" should be 1
    And there should be an unwarn link for "Normal, Norman. 20"

@selenium
  Scenario: Edit a client during checkin
    Given there is a household with residency, income and govtincome current in the database
    And there is a client with last name "Humperdinck", first name "Hubert", age "20" in the database
    And there is a client with last name "Normal", first name "Norman", age "20", with id date "Date.new(2009,1,1)" in the database belonging to the household
    And there is a client with last name "Arbogast", first name "Fanny", age "20", with id date "Date.new(2009,1,1)" in the database belonging to the household
    And I am quickchecking Fanny Arbogast
    When I follow "Arbogast, Fanny. 20"
    Then I should see "Fanny Arbogast" within: "h1"
    When I follow "Edit this client"
    Then I should see "Edit Fanny Arbogast" within: "h1"
    When I press "Save"
    Then I should see "Fanny Arbogast" within: "h1"
    And I should see a "Return to checkin" button
    When I press "Return to checkin"
    Then I should see "Client quick check: Fanny Arbogast" within: "h1"

@selenium
  Scenario: Edit a client during checkin, and cancel
    Given there is a household with residency, income and govtincome current in the database
    And there is a client with last name "Arbogast", first name "Fanny", age "20", with id date "Date.new(2009,1,1)" in the database belonging to the household
    And there is a client with last name "Normal", first name "Norman", age "20", with id date "Date.new(2009,1,1)" in the database belonging to the household
    And I am quickchecking Fanny Arbogast
    When I follow "Normal, Norman. 20"
    Then I should see "Norman Normal" within: "h1"
    When I follow "Edit this client"
    Then I should see "Edit Norman Normal" within: "h1"
    When I follow "Cancel"
    Then I should see "Norman Normal" within: "h1"
    And I should see a "Return to checkin" button
    When I press "Return to checkin"
    Then I should see "Client quick check" within: "h1"

@selenium
  Scenario: Edit a household during checkin
    Given there is a household with residency, income and govtincome current in the database
    And there is a client with last name "Humperdinck", first name "Hubert", age "20" in the database
    And there is a client with last name "Arbogast", first name "Fanny", age "20", with id date "Date.new(2009,1,1)" in the database belonging to the household
    And there is a client with last name "Normal", first name "Norman", age "20", with id date "Date.new(2009,1,1)" in the database belonging to the household
    And I am quickchecking Fanny Arbogast
    When I follow "View household"
    Then I should see "Household information" within: "h1"
    When I follow "Edit this household"
    And the remove resident links should be disabled
    And the add resident link should be disabled
    And the upload document links should be disabled
    And I press "Save"
    Then I should see "Household information" within: "h1"
    And I should see a "Return to checkin" button
    When I press "Return to checkin"
    Then I should see "Client quick check" within: "h1"

@selenium
  Scenario: Edit a household during checkin, then cancel
    Given there is a household with residency, income and govtincome current in the database
    And there is a client with last name "Humperdinck", first name "Hubert", age "20" in the database
    And there is a client with last name "Arbogast", first name "Fanny", age "20", with id date "Date.new(2009,1,1)" in the database belonging to the household
    And there is a client with last name "Normal", first name "Norman", age "20", with id date "Date.new(2009,1,1)" in the database belonging to the household
    And I am quickchecking Fanny Arbogast
    When I follow "View household"
    Then I should see "Household information" within: "h1"
    When I follow "Edit this household"
    And I follow "Cancel"
    Then I should see a "Return to checkin" button
    When I press "Return to checkin"
    Then I should see "Client quick check" within: "h1"

@selenium
  Scenario: Show recent checkins for client
    Given there is a household with residency, income and govtincome current in the database
    And there is a client with last name "Arbogast", first name "Fanny", age "20", with id date "Date.new(2009,1,1)" in the database belonging to the household
    And there is a client with last name "Normal", first name "Norman", age "20", with id date "Date.new(2009,1,1)" in the database belonging to the household
    And I am quickchecking Fanny Arbogast
    When I follow "Normal, Norman. 20"
    Then I should see "Norman Normal" within: "h1"
    And there should be 1 recent checkin by "Fanny Arbogast"
    Then I press "Return to checkin"
    And I follow "Arbogast, Fanny. 20"
    Then I should see "Fanny Arbogast" within: "h1"
    And there should be 1 recent checkin

  Scenario: Download a client id document that has been saved
    Given pending: Download a client id document that has been saved

  Scenario: Delete a qualification document
    Given pending: Delete a qualification document

  Scenario: View a qualification document
    Given pending: View a qualification document

  Scenario: Upload a household document
    Given pending: Upload a household document
