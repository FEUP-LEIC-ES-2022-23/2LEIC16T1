Feature: filters

  Background:
    Given I navigate to the "Search" page

  Scenario: Invalid location with filters displays error message
    When I input "invalid" in the "search bar"
    And I tap the "filter-icon"
    And I input "outdoor" in the "dropdown 1"
    And I scroll in "Edit options menu 1"
    And I tap the "save button"
    And I tap the "search-icon"
    Then the system should display a "No data found for address invalid" message

  Scenario Outline: Select according to one tag
    When I input "<location>" in the "search bar"
    And I tap the "filter-icon"
    And I input "<tag>" in the "dropdown 1"
    And I scroll in "Edit options menu 1"
    And I tap the "save button"
    And I tap the "search-icon"
    Then I should see a "results-map"
    And I should see a "results-list"

    Examples:
      | location | tag    |
      | Porto    | outdoor|
      | Porto    | soccer |
      | Lisboa   | yoga   |
