Feature: Warehouse Item Navigation
    As a warehouse operator
    I want to browse warehouse items through the sitemap
    So that I can find and inspect inventory records

    Background:
        Given I am logged in as 'tomas.prokop@thenetw.org'
        And I open the 'dmpp_warehouseapp' app

    Scenario: Navigate to the Warehouse Items list
        When I click on 'Warehouse Items' in the sitemap
        Then I should see the 'Active Warehouse Items' view

    Scenario: Search for a specific item in the grid
        When I click on 'Warehouse Items' in the sitemap
        And I search for 'Pen' in the grid
        Then the grid should contain a record with 'Name' equal to 'Pen'

    Scenario: Sort warehouse items by name
        When I click on 'Warehouse Items' in the sitemap
        And I sort the grid by 'Name'
        Then I should see the 'Active Warehouse Items' view

    Scenario: Switch to a different view
        When I click on 'Warehouse Items' in the sitemap
        And I switch to the 'Inactive Warehouse Items' view
        Then I should see the 'Inactive Warehouse Items' view
