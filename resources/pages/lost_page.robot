*** Settings ***
Library    String
Library    Collections
Variables  ../locators/lost_locators.py
Resource   ../../utils/common_keywords.robot

*** Keywords ***

Lost Submission
    [Arguments]    ${data}
    Get Element States    ${Lost}    validate    value & visible
    Click    ${Lost}
    Wait For Elements State    ${LostUpdateWorkflowStage}    visible
    FOR    ${reason}    IN    @{data['Reasons']}
        ${reasonCheckbox}    Catenate    SEPARATOR=    ${LostReason1}    ${reason}    ${LostReason2}    
        Check Checkbox    ${reasonCheckbox}
    END
    Fill Text    ${LostDetails}    ${data['details']}
    Get Element States    ${LostAcceptButton}    validate    value & enabled
    Click    ${LostAcceptButton}
    Wait For Processing Stage

Verify lost Tagname
    Get Element States    ${Reactive}    validate    value & visible    'Reactive should be visible.'
    ${status}    Run Keyword And Return Status    Get Element States    ${LostTag}    validate    value & visible
    IF    ${status}
    Get Element States    ${LostTag}    validate    value & visible    'LostTag should be visible.'
    ELSE
    Switch to Documents
    Get Element States    ${LostTag}    validate    value & visible    'LostTag should be visible.'
    END
