# ╔══════════════════════════════════════════════════════════════════════════════════════╗
# ║                  Feature: Error Handling for Warehouse Transactions                  ║
# ╚══════════════════════════════════════════════════════════════════════════════════════╝
#
# This Gherkin scenario tests error handling when attempting to create a Warehouse
# Transaction with a requested quantity that exceeds available stock.
#
# It verifies that a proper error message is shown to the user.
#
# ────────────────────────────────────────────────────────────────────────────────────────
# Scenario: Creating a transaction with quantity greater than stock
Feature: Error Validation - Not Enough Stock

  Background:
    Given I am logged in to the 'Inventory Management' app as 'a Warehouse Manager'
    And I have created 'a pen warehouse item of quantity 5'

  Scenario: Error Message for Insufficient Stock

    When I open the 'Warehouse Transactions' sub area of the 'New Group' group
    And I select the 'Create Warehouse Transaction' command
    And I enter the following into the dialog form
      | Value             | Field   |
      | Test Transaction | Name     |
      | 10               | Quantity |
      | Pen              | Item     |
      | Cash             | Payment Method |
    And I click on 'Save' button in dialog
    Then an error dialog should be displayed with the text 'Not enough product in stock. Available: 5, requested: 10.'