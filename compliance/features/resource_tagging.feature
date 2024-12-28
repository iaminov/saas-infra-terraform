Feature: Resource tagging
  Scenario: Ensure default tags are applied
    Given I have resource that supports tags defined
    When it contains tags
    Then it must contain Environment
    And it must contain Project
    And it must contain ManagedBy
