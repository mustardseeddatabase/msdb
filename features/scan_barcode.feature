@backbone
Feature: Scan barcode
	As a food pantry staff member
	In order to identify items by barcode
	I need to scan with a barcode reader

	Background: Logged in with all requisite permissions
		Given There is a donor called "Food for All" in the database
    And I am logged in and on the "donations#new" page

@selenium
  Scenario: Scan invalid barcode: nil
    When I scan an item with barcode ""
    Then I should see "Invalid barcode" within: "#barcode_message"

@selenium
  Scenario: Scan invalid barcode: letters
    When I scan an item with barcode "abcd"
    Then I should see "Invalid barcode" within: "#barcode_message"

@selenium
  Scenario: Scan invalid barcode: numbers and letters
    When I scan an item with barcode "abc1234"
    Then I should see "Invalid barcode" within: "#barcode_message"
