*** Settings ***
Resource    ../../config/browser.robot
Variables        ../locators/my_assignments_locators.py

*** Keywords ***
Verify My Assignments Tab is displayed as a default tab
    [Documentation]    Verifies that the 'My Assignments' tab is visible and selected by default when the page loads.
    Wait For Elements State    ${MyAssignments}    visible    timeout=30s
    Get Element States    ${MyAssignments}    validate    value & visible    'MyAssignments should be visible.'
