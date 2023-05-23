Feature: facility
  Background:
    Given I navigate to the "Profile" page
    And I am not logged in
    When I input "esof@gmail.pt" in the "sign in mail field"
    And I input "Es123456.?" in the "sign in password field"
    And I tap the "login button"
    Then I should see a "profile page"
    And I navigate to the "Search" page
    And I input "Porto" in the "search bar"
    And I tap the "search-icon"
    And I should see a "results-list"
    Given I choose the facility "Holmes Place Boavista"

  Scenario: Review a facility
    When I input "This is a great facility!" in the "review-field"
    And I scroll in "facility-page"
    And I tap the "submit-review-button"
    Then I should see a "This is a great facility!"