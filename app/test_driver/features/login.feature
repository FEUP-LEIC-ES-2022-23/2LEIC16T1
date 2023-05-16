Feature: login
  Background:
    Given I navigate to the "Profile" page
    And I am not logged in

  Scenario: Username not registered on login form
    When I input "user.not.registered1234@gmail.com" in the "sign in mail field"
    And I input "randompassword" in the "sign in password field"
    And I tap the "login button"
    Then the system should display a "There is no user record corresponding to this identifier. The user may have been deleted." message

  Scenario: Successful login redirects to profile page
    When I input "esof@gmail.pt" in the "sign in mail field"
    And I input "Es123456.?" in the "sign in password field"
    Then I should see a "profile page"

  Scenario: Incorrect password on login form
    When I input "esof@gmail.pt" in the "sign in mail field"
    And I input "wrongpassword" in the "sign in password field"
    And I tap the "login button"
    Then the system should display a "The password is invalid or the user does not have a password." message

  Scenario: Pressing login without entering any field
    When I tap the "login button"
    Then the system should display a "Given String is empty or null" message
