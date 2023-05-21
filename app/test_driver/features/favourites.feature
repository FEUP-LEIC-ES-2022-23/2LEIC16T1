Feature: favourites
  Scenario: See a message to log in in order to see the favourite places
    Given I am not logged in
    And I navigate to the "Favourites" page
    Then the system should display a "Log in to check your favourite facilities" message

  Scenario: See favorite facilities when logged in
    Given I am logged in
    And I should see a "profile page"
    And I navigate to the "Favourites" page
    Then I should see a "favorites-list"

  Scenario: See a star when I go to a facility page
    Given I am logged in
    And I navigate to the "Search" page
    And I input "Porto" in the "search bar"
    And I tap the "search-icon"
    And I choose the facility "Holmes Place Boavista"
    Then I should see a "fav-star"
