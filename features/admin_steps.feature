Feature: As a login admin user
  In order to add or edit masters
  I want to be admin
  And I want to add or edit masters


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