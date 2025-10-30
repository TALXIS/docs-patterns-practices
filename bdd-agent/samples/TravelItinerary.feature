Feature: Travel Itinerary Management
  As a travel administrator
  I want to manage travel itineraries
  So that I can organize and track employee travel plans

  Background:
    Given I am logged in to the Travel Admin Management App
    And I am on the Travel Itineraries page

  Scenario: Create a new travel itinerary with basic details
    When I click the New button
    And I fill the Travel Itinerary field with "Business Trip to Singapore"
    And I select "Travel Request 1" from the Travel Request lookup
    And I fill the Flight Details field with "SQ321 - Singapore Changi Airport"
    And I click the Save button
    Then I should see "Saved" in the save status
    And the page title should contain "Business Trip to Singapore"

  Scenario: Create a travel itinerary with complete details
    When I click the New button
    And I fill the form with:
      | Field             | Value                              |
      | Travel Itinerary  | Conference Trip to Barcelona       |
      | Flight Details    | VY8301 - Barcelona El Prat Airport |
      | Hotel Details     | Hotel Arts Barcelona               |
      | Transport Details | Metro and taxi                     |
    And I select "Travel Request 2" from the Travel Request lookup
    And I click the Save button
    Then I should see "Saved" in the save status
    And the page title should contain "Conference Trip to Barcelona"

  Scenario: View existing travel itinerary details
    When I click on the itinerary "Test Trip to Tokyo"
    Then the Travel Itinerary field should contain "Test Trip to Tokyo"
    And the Flight Details field should contain "ANA NH123 - Tokyo Narita Airport"
    And the Hotel Details field should contain "Shinjuku Grand Hotel"
    And the Transport Details field should contain "JR Pass for local travel"
    And the Travel Request field should show "Travel Request 1"

  Scenario: Navigate back to itineraries list
    When I click on the itinerary "Test Trip to London"
    And I click the back button
    Then I should be on the Travel Itineraries page
    And I should see the itineraries grid

  Scenario: View itineraries filtered by travel request
    When I search for "Tokyo" in the itinerary filter
    Then I should see itineraries containing "Tokyo"
    And the results should be filtered

  Scenario: Create multiple itineraries for the same travel request
    When I click the New button
    And I fill the Travel Itinerary field with "Outbound Flight - Munich"
    And I select "Travel Request 3" from the Travel Request lookup
    And I fill the Flight Details field with "LH456 - Munich Airport"
    And I click the Save & Close button
    Then I should be on the Travel Itineraries page
    When I click the New button
    And I fill the Travel Itinerary field with "Return Flight - Munich"
    And I select "Travel Request 3" from the Travel Request lookup
    And I fill the Flight Details field with "LH457 - Munich Airport"
    And I click the Save & Close button
    Then I should be on the Travel Itineraries page
    And I should see "Outbound Flight - Munich" in the grid
    And I should see "Return Flight - Munich" in the grid
