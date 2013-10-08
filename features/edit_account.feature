Feature: As a login user
  In order to edit my account
  I want to login
  And I want to edit my account details


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
     And I fill in "Email" with "admin@user.com"
     And I fill in "Password" with "123123"
     When I press "Login"
     Then I should see "Logged in successfully"
     And I should see "My Account"

 Scenario: Edit my account
     When I follow "My Account" for edit account
     Then I should see "My Orders"
     And I should see "Edit"
     When I follow "Edit" for edit
     Then I should see "Editing User"
     And I fill in "Password" with "123123"
     And I fill in "Password Confirmation" with "123123"
     When I press "Update"
     Then I should see "Login as Existing Customer"