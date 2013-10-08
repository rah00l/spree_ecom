Feature: Register user
  In order to register user
  I want to register

Background:
    Given there are countries with the following attributes:
       |iso_name         |iso       |iso3    |name            |numcode    |
       |UNITED STATES    |US        |USA     |United States   |840        |
       |INDIA            |IN        |iso3    |IND             |356        |
    Given there are states with the following attributes:
       |name             |abbr      |country       |
       |California       |CA        |US            |
       |Louisiana        |LA        |US            |
       |Virginia         |VA        |US            |
    Given there are referral sources with the following attributes:
       |name             |
       |AOL              |
       |Google           |
       |MSN              |
       |Neo Buggy        |
       |RC Tech          |
       |Sports Buggy     |
       |Yahoo!           |
    Given I am on home page
    Then I should see "Login"
    And I should see "Home"
    When I follow "Login"
    Then I should see "Login as Existing Customer"
    And I should see "Create a new account"
    When I follow "Create a new account" for signup
    Then I should see "New Customer"


Scenario: Registering a user with valid input
    When I fill in "Email" with "admin@example.com"
    And I fill in "Password" with "123123"
    And I fill in "Password Confirmation" with "123123"
    And I fill in "First Name" with "Spree"
    And I fill in "Last Name" with "Test"
    And I fill in "Street Address" with "P.O. Box 3700 Eureka, CA 95502"
    And I fill in "City" with "Eureka"
    And I select "United States" from "Country"
    Then I should see "California"
    When I select "California" from "user_bill_address_attributes_state_id"
    And I fill in "Zip" with "123456"
    And I fill in "Phone" with "1234567891"
    And I fill in "Phone" with "1234567891"
    And I select "Google" from "user_referral_source_id"
    And I press "Create"
    Then I should see "Welcome! You have signed up successfully."

Scenario: Registering a user with in-valid input
    When I press "Create"
    Then I should see "Email can't be blank"
    Then I should see "Password can't be blank"
    Then I should see "Bill address firstname can't be blank"
    Then I should see "Bill address lastname can't be blank"
    Then I should see "Bill address address1 can't be blank"
    Then I should see "Bill address city can't be blank"
    Then I should see "Bill address zipcode can't be blank"
    Then I should see "Bill address phone can't be blank"
    Then I should see "Bill address state is invalid"
    Then I should see "Please select referral source"


