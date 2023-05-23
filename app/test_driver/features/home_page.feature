Feature: home page

  Background:
    Given I navigate to the "Home" page

  Scenario: Home page displays app name
    Then I should see a "app-name"

  Scenario: Home page displays different sports
    Then I should see a "Soccer"
    And I should see a "Basketball"
    And I should see a "Baseball"
