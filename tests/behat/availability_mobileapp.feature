@availability @availability_mobileapp
Feature: availability_mobileapp
  In order to control student access to activities
  As a teacher
  I need to set Mobile app access conditions which prevent student access

  Background:
    Given the following "courses" exist:
      | fullname | shortname | format | enablecompletion |
      | Course 1 | C1        | topics | 1                |
    And the following "users" exist:
      | username |
      | teacher1 |
      | student1 |
    And the following "course enrolments" exist:
      | user     | course | role           |
      | teacher1 | C1     | editingteacher |
      | student1 | C1     | student        |
    And I log in as "admin"
    And I set the following administration settings values:
      | Enable web services                    | 1 |
      | Enable web services for mobile devices | 1 |
    And I log out

  @javascript
  Scenario: Test condition
    # Basic setup.
    Given I log in as "teacher1"
    And I follow "Course 1"
    And I turn editing mode on

    # Add a Page with a Mobile app condition that does match.
    And I add a "Page" to section "1"
    And I set the following fields to these values:
      | Name         | Page 1 |
      | Description  | Test   |
      | Page content | Test   |
    And I expand all fieldsets
    And I click on "Add restriction..." "button"
    And I click on "Mobile app" "button" in the "Add restriction..." "dialogue"
    And I click on ".availability-item .availability-eye img" "css_element"
    And I set the field "e" to "2"
    And I press "Save and return to course"

    # Add a Page with a date condition that doesn't match.
    And I add a "Page" to section "2"
    And I set the following fields to these values:
      | Name         | Page 2 |
      | Description  | Test   |
      | Page content | Test   |
    And I expand all fieldsets
    And I click on "Add restriction..." "button"
    And I click on "Mobile app" "button" in the "Add restriction..." "dialogue"
    And I click on ".availability-item .availability-eye img" "css_element"
    And I set the field "e" to "2"
    And I press "Save and return to course"

    # Log back in as student.
    When I log out
    And I log in as "student1"
    And I follow "Course 1"

    # Page 1 should appear, but page 2 does not.
    Then I should see "Page 1" in the "region-main" "region"
    And I should not see "Page 2" in the "region-main" "region"