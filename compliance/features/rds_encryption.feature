Feature: RDS Storage Encryption
  All RDS instances must use encryption at rest

  Scenario: Ensure RDS instances are encrypted
    Given I have aws_db_instance defined
    Then it must have storage_encrypted
    And its value must be true
