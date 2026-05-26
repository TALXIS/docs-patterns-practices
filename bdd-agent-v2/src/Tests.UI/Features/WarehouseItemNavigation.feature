Feature: WarehouseItemNavigation

Scenario: User can open a warehouse item from the main view
    Given I am logged in as 'admin@yourorg.onmicrosoft.com'
    And I open the 'Warehouse Management' app
    When I navigate to 'Warehouse' > 'Warehouse Items'
    Then I should see the 'Active Warehouse Items' view
