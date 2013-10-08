Feature: Creating Categories
In order to have categories to assign  to
products
I want to create category

Background: Visiting admin home page
When I go to the sign in page
And I sign in admin login
Then I See link "My Account"
When I go to the admin
Then I see to "Overview"
When I go to the configurations
Then I See link "Front Page Highlights"
When I go to the Front Page Highlights
Then I See "Listing Front Page Highlights"

Scenario: create category

Scenario: Create Valid Front Page Highlight
    Given a user visits the Front Page Highlights list page
    When I follow "New"
    And I fill in "Name"
    And I press "Create"
    Then I should see "Successfully created Category."

Scenario: creating Front Page Highlight with blank name
    Given a user visits the Front Page Highlights list page
    When I follow "New"
    And I fill in "Name"
    And I press "Create"
    Then I should see "Successfully created Category."






    