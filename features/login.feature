Feature: As a register user
  In order to login to the ststem
  I want to login


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
     Given there are users with the following attributes:
      | email           |referral_source| firstname |lastname |address1                       |city   |country  |state      |zip     |phone      |
      | admin@user.com  |Google         | Admin     |User     |P.O. Box 3700 Eureka, CA 95502 |Eureka |US       |California |3700    |1234567890 |
      | user@user.com   |MSN            | User      |Use      |P.O. Box 3700 Eureka, CA 95503 |Eureka |US       |California |3700    |0987654321 |
     Given I am on home page
     Then I should see "Login"
     And I should see "Home"
     When I follow "Login"
     Then I should see "Login as Existing Customer"

Scenario: Login with valid credentials
     And I fill in "Email" with "admin@user.com"
     And I fill in "Password" with "123123"
     When I press "Login"
     Then I should see "Logged in successfully"

Scenario: Login with in-valid credentials
     When I press "Login"
     Then I should see "Invalid email or password."