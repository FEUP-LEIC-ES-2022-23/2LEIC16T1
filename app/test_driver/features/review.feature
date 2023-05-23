Feature: review
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

  Scenario: Write a review for a facility
    When I input "This is a great facility!" in the "review-field"
    And I scroll in "facility-page"
    And I tap the "submit-review-button"
    Then I should see a "This is a great facility!"

  Scenario: Write a new review for a facility
    When I input "This is a great facility!" in the "review-field"
    And I scroll in "facility-page"
    And I tap the "submit-review-button"
    And I should see a "This is a great facility!"
    When I input "This facility is even better than I thought it was!" in the "review-field"
    And I scroll in "facility-page"
    And I tap the "submit-review-button"
    Then I should see a "This facility is even better than I thought it was!"
