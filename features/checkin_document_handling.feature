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

@selenium
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

@selenium
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

  Scenario: Download a client id document that has been saved
    Given pending: Download a client id document that has been saved

  Scenario: Delete a qualification document
    Given pending: Delete a qualification document

  Scenario: Upload a household document
    Given pending: Upload a household document
