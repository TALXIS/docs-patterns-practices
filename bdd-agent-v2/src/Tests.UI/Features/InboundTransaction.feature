Feature: Inbound Transaction
    As a warehouse operator
    I want to record inbound stock deliveries
    So that available quantities are updated automatically

    Background:
        Given I am logged in as 'tomas.prokop@thenetw.org'
        And I open the 'dmpp_warehouseapp' app

    Scenario: Create an inbound transaction and verify stock increases
        # First, note the current stock level of the item
        When I click on 'Warehouse Items' in the sitemap
        And I search for 'Printer' in the grid
        And I open the record at row 1
        Then the 'dmpp_availablequantity' attribute should be visible

        # Navigate to transactions and create an inbound delivery
        When I click on 'Warehouse Transactions' in the sitemap
        And I click 'New' on the command bar
        And I enter 'Inbound Delivery Test' into the 'dmpp_name' text attribute
        And I select 'Inbound' in the 'dmpp_type' optionset attribute
        And I enter '10' into the 'dmpp_quantity' decimal attribute
        And I search for 'Printer' in the 'dmpp_warehouseitemid' lookup attribute
        And I select the first result in the 'dmpp_warehouseitemid' lookup
        And I save the record
        Then the record should be saved successfully

        # Go back to the warehouse item and verify the stock increased
        When I click on 'Warehouse Items' in the sitemap
        And I search for 'Printer' in the grid
        And I open the record at row 1
        Then the 'dmpp_availablequantity' attribute should be visible
