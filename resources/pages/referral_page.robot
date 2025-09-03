*** Settings ***
Library    String
Library    Collections
Variables  ../locators/referral_locators.py
Resource   ../../utils/common_keywords.robot

*** Keywords ***
Verify Referral Button 
    Get Element States    ${ReferralButton}    validate    value & visible    message=Referral Button should visible.

Create New Refer Submission
    [Arguments]    ${data}    
    Click    ${ReferralButton}
    Wait For Elements State    ${ReferSubmission}    visible
    Click    ${ReferralReasonsDropdown}
    FOR     ${referralReason}    IN    @{data['Reasons']}
    ${reason}    Catenate    SEPARATOR=    ${ReferralReason1}    ${referralReason}    ${ReferralReason2}
    Check Checkbox    ${reason}
    END
    Click    ${ReferralReasonsDropdown}
    Click    ${ReferUserDropdown}
    ${user}    Catenate    SEPARATOR=    ${ReferToUser}    ${data['user']}']
    Click    ${user}
    Fill Text    ${ReferDetails}    ${data['details']}
    Get Element States    ${ReferButton}    validate    value & enabled
    Click    ${ReferButton}

Verify the Refer Submission data
    [Arguments]    ${expectedText}
    ${actualText}    Get Text    ${ReferredDetails}
    Log    ${actualText}    console=True
    FOR    ${text}    IN    @{expectedText}
        Should Contain    ${actualText}    ${text}
    END

Verify Referral Pending 
    Get Element States    ${RferralPending}    validate    value & visible    message=Referral Pending should visible.