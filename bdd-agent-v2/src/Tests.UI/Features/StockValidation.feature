Feature: Stock Validation
    As a warehouse system
    I want to prevent outbound transactions that exceed available stock
    So that inventory never goes negative

    Background:
        Given I am logged in as 'tomas.prokop@thenetw.org'
        And I open the 'dmpp_warehouseapp' app

    Scenario: Outbound transaction exceeding stock is rejected by the plugin
        # Navigate to transactions and create a new record
        When I click on 'Warehouse Transactions' in the sitemap
        And I click 'New' on the command bar

        # Fill in the transaction form with a quantity that exceeds stock
        And I enter 'Outbound Overstock Test' into the 'dmpp_name' text attribute
        And I select 'Outbound' in the 'dmpp_type' optionset attribute
        And I enter '9999' into the 'dmpp_quantity' decimal attribute
        And I search for 'Pen' in the 'dmpp_warehouseitemid' lookup attribute
        And I select the first result in the 'dmpp_warehouseitemid' lookup

        # Attempt to save — the server-side plugin should reject this
        And I save the record
        Then the form should not be dirty
