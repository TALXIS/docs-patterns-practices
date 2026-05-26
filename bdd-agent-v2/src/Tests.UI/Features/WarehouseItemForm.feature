Feature: Warehouse Item Form
    As a warehouse operator
    I want to open and edit warehouse item records
    So that I can keep inventory data accurate

    Background:
        Given I am logged in as 'tomas.prokop@thenetw.org'
        And I open the 'dmpp_warehouseapp' app
        When I click on 'Warehouse Items' in the sitemap

    Scenario: Open a warehouse item and verify its fields
        When I open the record at row 1
        Then the 'dmpp_name' attribute should be visible
        And the 'dmpp_availablequantity' attribute should be visible
        And the 'dmpp_availablequantity' attribute should be read-only

    Scenario: Edit the name of a warehouse item
        When I open the record at row 1
        And I enter 'Updated Item Name' into the 'dmpp_name' text attribute
        And I save the record
        Then the record should be saved successfully
        And the 'dmpp_name' attribute should contain 'Updated Item Name'

    Scenario: Verify form tabs are visible
        When I open the record at row 1
        Then the 'General' tab should be visible
        And the 'Related' tab should be visible

    Scenario: Required fields are enforced
        When I click 'New' on the command bar
        Then the 'dmpp_name' attribute should be required
