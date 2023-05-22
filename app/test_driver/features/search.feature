Feature: search

  Background:
    Given I navigate to the "Search" page

  Scenario: Search page displays search bar
    Then I should see a "search bar"

  Scenario: Invalid location input displays error message
    When I input "invalid" in the "search bar"
    And I tap the "search-icon"
    Then the system should display a "No data found for address invalid" message

  Scenario Outline: Valid location input displays map and sports facilities list
    When I input "<location>" in the "search bar"
    And I tap the "search-icon"
    Then I should see a "results-map"
    And I should see a "results-list"

    Examples:
      | location                              |
      | Porto                                 |
      | Lisboa                                |
      | R. Dr. Roberto Frias, 4200-465 Porto  |
