Feature: search

  Background:
    Given I navigate to the "Search" page

  Scenario: Search page displays search bar
    Then I should see a "search bar"

  Scenario: Invalid location input displays error message
    When I input a location "invalid" in the search bar
    Then the system should display a "No data found for address invalid" message

  Scenario: Valid location input displays map and sports facilities list
    When I input a location "Porto" in the search bar
    Then the system should display a map and a list of the sports facilities near that location

