Feature: RDS encryption enforcement
  Scenario: Ensure RDS clusters are encrypted
    Given I have aws_rds_cluster defined
    Then it must contain storage_encrypted
    And its value must be true
