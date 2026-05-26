Feature: Warehouse Dashboard
    As a warehouse manager
    I want to see a summary dashboard of inventory status
    So that I can quickly identify stock levels and low stock alerts

    # This is a generative page (pagetype=genux, React + Fluent UI V9).
    # Navigation uses standard MDA bindings (Tier 1).
    # All dashboard-specific assertions require custom bindings (Tier 2).

    Background:
        Given I am logged in as 'tomas.prokop@thenetw.org'
        And I open the 'dmpp_warehouseapp' app

    Scenario: Navigate to the Dashboard page
        When I click on 'Dashboard' in the sitemap
        # Custom binding required — genux page, verify heading text
        Then I should see the 'Warehouse Dashboard' page heading

    Scenario: Summary cards are displayed
        When I click on 'Dashboard' in the sitemap
        # Custom binding required — Fluent UI Card components, not MDA fields
        Then I should see a summary card titled 'Total Items'
        And I should see a summary card titled 'Locations'
        And I should see a summary card titled 'Low Stock Alerts'

    Scenario: Summary cards reflect inventory data
        When I click on 'Dashboard' in the sitemap
        # Custom binding required — read numeric values from Fluent UI cards
        Then the 'Total Items' summary card should show a value greater than 0
        And the 'Locations' summary card should show a value greater than 0

    Scenario: Low stock alerts count items below reorder point
        When I click on 'Dashboard' in the sitemap
        # Custom binding required — card value depends on qty vs reorder point
        Then the 'Low Stock Alerts' summary card should show a numeric value

    Scenario: Inventory overview table is visible with correct columns
        When I click on 'Dashboard' in the sitemap
        # Custom binding required — Fluent UI Table, not ag-Grid
        Then I should see the 'Inventory Overview' table
        And the table should have columns:
            | Column        |
            | Item Name     |
            | SKU           |
            | Qty on Hand   |
            | Reorder Point |
            | Status        |

    Scenario: Inventory table displays warehouse items
        When I click on 'Dashboard' in the sitemap
        # Custom binding required — Fluent UI TableRow elements
        Then the inventory table should contain at least 1 row

    Scenario: Items with sufficient stock show 'In Stock' status
        When I click on 'Dashboard' in the sitemap
        # Custom binding required — Fluent UI Badge component
        Then items with quantity above their reorder point should show 'In Stock' status

    Scenario: Items with low stock show 'Low Stock' status
        When I click on 'Dashboard' in the sitemap
        # Custom binding required — Fluent UI Badge with danger color
        Then items at or below their reorder point should show 'Low Stock' status

    Scenario: Inventory table is sorted by quantity ascending
        When I click on 'Dashboard' in the sitemap
        # Custom binding required — verify row order in Fluent UI Table
        Then the inventory table should be sorted by 'Qty on Hand' in ascending order
