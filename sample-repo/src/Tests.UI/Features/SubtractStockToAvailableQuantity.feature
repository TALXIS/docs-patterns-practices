# ╔══════════════════════════════════════════════════════════════════════════════════════╗
# ║                      Feature: Subtract Stock from Available Quantity                 ║
# ╚══════════════════════════════════════════════════════════════════════════════════════╝
#
# This Gherkin scenario tests subtract item from the Available Quantity of an item after
# creating a Warehouse Transaction.
#
# It verifies that the 'Available Quantity' is recalculated correctly after an
# inbound transaction is subtracted.
#
# ────────────────────────────────────────────────────────────────────────────────────────
# Background setup: login and item creation
Feature: Subtract Stock

  Background:
    Given I am logged in to the 'Inventory Management' app as 'a Warehouse Manager'
    And I have created 'a printer warehouse item of quantity 5'

# ────────────────────────────────────────────────────────────────────────────────────────
# Scenario: Performing the transaction and verifying available quantity
  Scenario: Subtract Stock to Available Quantity

    When I open the 'Warehouse Transactions' sub area of the 'New Group' group
    And I select the 'Create Warehouse Transaction' command
    And I enter the following into the dialog form
      | Value   | Field    |
      | Inbound | Name     |
      | Printer | Item     |
      | 3       | Quantity |
      | Visa    | Payment Method |
    And I click on 'Save' button in dialog
    And I search for 'Inbound' in the grid
    And I open the record at position '0' in the grid
    And I select a related 'Item' lookup field
    Then I should be able to see a value of '2' in the 'Available Quantity' field