Feature: domain for profile

  As a user
  I want access a profile by its own domain

  Background:
    Given the following user
      | login     | name       |
      | joaosilva | Joao Silva |
    And the following communities
      | identifier       | name             | domain    |
      | sample-community | Sample Community | localhost |
    And the following blocks
      | owner            | type              |
      | joaosilva        | ProfileInfoBlock  |
    And the environment domain is "127.0.0.1"
    And "Joao Silva" is environment admin
    And "Joao Silva" is admin of "Sample Community"

  @selenium
  Scenario: access profile control panel through profile blocks
    Given I am logged in as "joaosilva"
    When I go to joaosilva's homepage
    And I follow "Control panel" within ".profile-info-block"
    Then I should see "Joao Silva" within "span.control-panel-title"
    When I follow "Control panel" within ".profile-image-block"
    Then I should see "Joao Silva" within "span.control-panel-title"

  @selenium
  Scenario: access user control panel
    Given I am logged in as "joaosilva"
    When I go to the homepage
    And I follow "joaosilva"
    And I go to sample-community's homepage
    And I follow "Login"
    And I fill in "joaosilva" for "Username"
    And I fill in "123456" for "Password"
    And I press "Log in"
    And I follow "Control panel" within "div#user"
    Then I should see "Joao Silva" within "span.control-panel-title"

  @selenium
  Scenario: access user page
    Given I am logged in as "joaosilva"
    When I go to the homepage
    And I follow "joaosilva"
    Then the page title should be "Joao Silva"

  @selenium-fixme
  Scenario: access community by domain
    Given I go to the search communities page
    When I follow "Sample Community" within ".search-profile-item"
    Then the page title should be "Sample Community"

  @selenium-fixme
  Scenario: Go to profile homepage after clicking on home button on not found page
    Given I am on sample-community's homepage
    When I go to /something-that-does-not-exist
    And I follow "Go to the home page"
    Then the page title should be "Sample Community - Colivre.net"

  @selenium
  Scenario: Go to environment homepage after clicking on home button on not found page
    Given I am on the homepage
    When I go to /something-that-does-not-exist
    And I follow "Go to the home page"
    Then the page title should be "Colivre.net"

  @selenium
  Scenario: Compose link to administration with environment domain
    Given I am logged in as "joaosilva"
    Then I should see "Administration" linking to "http://127.0.0.1.*/admin"
