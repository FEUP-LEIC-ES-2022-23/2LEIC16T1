Feature: facility
  Background:
    Given I am not logged in
    And I navigate to the "Search" page
    And I input "Porto" in the "search bar"
    And I tap the "search-icon"
    And I should see a "results-list"

  Scenario Outline: Facility information appears when I click on a facility
    Given I choose the facility "<facility>"
    Then I should see a "Facility <facility-name>"

    Examples:
      | facility              | facility-name           |
      | Holmes Place Boavista | Holmes Place Boavista   |
      | CrossFit Durius       | CrossFit Durius         |

  Scenario: See a message to log in in order to rate a facility
    Given I choose the facility "Holmes Place Boavista"
    Then the system should display a "Log in to rate this facility" message
