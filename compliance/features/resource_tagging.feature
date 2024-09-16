Feature: Mandatory Resource Tagging
  All resources should be properly tagged

  Scenario: Ensure all resources have Environment tag
    Given I have resource that supports tags defined
    Then it must contain tag "Environment"
    And its value must not be null

  Scenario: Ensure all resources have ManagedBy tag
    Given I have resource that supports tags defined
    Then it must contain tag "ManagedBy"
    And its value must match the regex "terraform"
