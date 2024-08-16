@editor @tiny @editor_tiny @tiny_html @tiny_clozergx @javascript
Feature: Test the cloze question editor string compilation after creating the question in the dialogue (using a regexp sub-question).

  Background:
    Given the following "users" exist:
      | username | firstname | lastname | email               |
      | teacher  | Mark      | Allright | teacher@example.com |
    And the following "courses" exist:
      | fullname | shortname | category |
      | Course 1 | C1        | 0        |
    And the following "course enrolments" exist:
      | user    | course | role           |
      | teacher | C1     | editingteacher |
    Given the following "user preferences" exist:
      | user    | preference | value |
      | teacher | htmleditor | tiny  |

  Scenario: Create a REGEXP sub-question with 1 incorrect answer
    When I am on the "Course 1" "core_question > course question bank" page logged in as teacher
    And I press "Create a new question ..."
    And I set the field "Embedded answers with REGEXP (Clozergx)" to "1"
    And I click on "Add" "button" in the "Choose a question type to add" "dialogue"
    And I set the field "Question name" to "multianswer-001"
    And I set the field "Question text" to "... are the colours of the French flag"
    And I select the "span" element in position "0" of the "Question text" TinyMCE editor
    And I click on "Cloze question editor" "button"
    And I set the field "REGEXP" to "1"
    And I click on "Select question type" "button"
    And I set the field "Default mark" to "2"
    And I set the field with xpath "//form[@name='tiny_clozergx_form']//li[1]//input[contains(@class, 'tiny_clozergx_answer')]" to "blue, white and red"
    And I set the field with xpath "//form[@name='tiny_clozergx_form']//li[1]//input[contains(@class, 'tiny_clozergx_feedback')]" to "Those are the right colours"
    And I click on "//form[@name='tiny_clozergx_form']//li[1]//a[contains(@class, 'tiny_clozergx_add')]" "xpath"
    And I set the field with xpath "//form[@name='tiny_clozergx_form']//li[2]//input[contains(@class, 'tiny_clozergx_answer')]" to "--.*blue.*"
    And I set the field with xpath "//form[@name='tiny_clozergx_form']//li[2]//input[contains(@class, 'tiny_clozergx_feedback')]" to " Missing blue!"
    And I set the field with xpath "//form[@name='tiny_clozergx_form']//li[2]//select[contains(@class, 'tiny_clozergx_frac')]" to "Incorrect"
    When I click on "Insert question" "button"
    Then the field "Question text" matches multiline:
    """
    <p><span class="cloze-question-marker" contenteditable="false">{2:REGEXP:=blue, white and red#Those are the right colours~--.*blue.*# Missing blue!}</span>... are the colours of the French flag</p>
    """

  Scenario: Create a REGEXP sub-question with an error
    When I am on the "Course 1" "core_question > course question bank" page logged in as teacher
    And I press "Create a new question ..."
    And I set the field "Embedded answers with REGEXP (Clozergx)" to "1"
    And I click on "Add" "button" in the "Choose a question type to add" "dialogue"
    And I set the field "Question name" to "multianswer-001"
    And I set the field "Question text" to "... are the colours of the French flag"
    And I select the "span" element in position "0" of the "Question text" TinyMCE editor
    And I click on "Cloze question editor" "button"
    And I set the field "REGEXP" to "1"
    And I click on "Select question type" "button"
    And I set the field "Default mark" to "2"
    And I set the field with xpath "//form[@name='tiny_clozergx_form']//li[1]//input[contains(@class, 'tiny_clozergx_answer')]" to "blue, white and red"
    And I set the field with xpath "//form[@name='tiny_clozergx_form']//li[1]//input[contains(@class, 'tiny_clozergx_feedback')]" to "Those are the right colours"
    And I click on "//form[@name='tiny_clozergx_form']//a[contains(@class, 'tiny_clozergx_add')]" "xpath"
    And I set the field with xpath "//form[@name='tiny_clozergx_form']//li[1]//input[contains(@class, 'tiny_clozergx_answer')]" to "--.*blue.*"
    And I set the field with xpath "//form[@name='tiny_clozergx_form']//li[1]//input[contains(@class, 'tiny_clozergx_feedback')]" to " Missing blue!"
    And I set the field with xpath "//form[@name='tiny_clozergx_form']//li[1]//select[contains(@class, 'tiny_clozergx_frac')]" to "Incorrect"
    When I click on "Insert question" "button"
    Then the field "Question text" matches multiline:
    """
    <p><span class="cloze-question-marker" contenteditable="false">{2:REGEXP:--.*blue.*# Missing blue!~=blue, white and red#Those are the right colours}</span>... are the colours of the French flag</p>
    """
    Then I press "id_analyzequestion"
    And I should see "Answer 1 must be a correct answer (grade = 100%) and it will not be analysed as a regular expression."
