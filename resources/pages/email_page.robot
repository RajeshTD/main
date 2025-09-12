*** Settings ***
Resource     ../../utils/common_keywords.robot
Variables     ../locators/email_locators.py

*** Keywords ***

Switch To Email Tab
    [Documentation]    Ensures the view is switched to the 'Email' tab. If not already on the email tab, it will be clicked.
    ${is_visible}=    Run Keyword And Return Status    Get Element States  ${Email_breadcrums}    validate    value & visible    'Email_breadcrums should be visible.'
    IF    not ${is_visible}
        Click    ${EmailMenu}
        Wait For Load State    networkidle
        Wait For Elements State    ${Email_breadcrums}    visible       
    END

Create New Mail
    [Documentation]    Composes and sends a new email with a single submission asset as an attachment.
    ...
    ...    *Arguments:*
    ...    - `${email_data}`: A dictionary containing email details like 'From', 'To', 'Subject', 'Body', and 'AssetName'.
    [Arguments]    ${email_data}
    Switch To Email Tab
    ${is_visible}=    Run Keyword And Return Status     Wait For Elements State    ${CreateNewMessageButton}    visible    timeout=5s
    IF    ${is_visible}
        Click    ${CreateNewMessageButton}
    ELSE
        Click    ${NewEmailButton}
    END
    Wait For Elements State    ${NewMessageTitle}    visible
    ${fromText}=    Get Attribute    ${FromField}    value
    Should Be Equal    ${fromText}    ${email_data['From']}
    Fill Text    ${RecipientsField}    ${email_data['To']}
    ${subjectText}=    Get Attribute    ${SubjectField}    value
    Should Be Equal    ${subjectText}    ${email_data['Subject']}
    Fill Text    ${EmailBody}    ${email_data['Body']}
    Click    ${SubmissionAssetsButton}
    Wait For Elements State    ${SubmissionAssetsDialog}    visible
    ${is_list}=    Evaluate    isinstance($email_data['AssetName'], list)
    IF    ${is_list}
        ${asset}=    Get From List    ${email_data['AssetName']}    0
    ELSE
        ${asset}=    Set Variable    ${email_data['AssetName']}
    END
    ${asset_name}=    Catenate    SEPARATOR=    ${SelectOriginalDocument}    ${asset}    ${SelectOriginalDocument_checkbox}
    Check Checkbox    ${asset_name}
    Click    ${Attach1AssetButton}
    Wait For Elements State    ${AttachmentText}    visible
    ${attachmentText}=    Get Text    ${AttachmentText}
    Should Be Equal    ${asset}    ${attachmentText}    
    Click    ${SendButton}
    Wait For Elements State    ${Email_breadcrums}    visible

Create New Mail For Upload Multiple Submission Assets
    [Documentation]    Composes and sends a new email with multiple submission assets as attachments.
    ...
    ...    *Arguments:*
    ...    - `${email_data}`: A dictionary containing email details, including a list of 'FileNames' to attach from submission assets.
    [Arguments]    ${email_data}
    Switch To Email Tab
    ${is_visible}=    Run Keyword And Return Status     Wait For Elements State    ${CreateNewMessageButton}    visible    timeout=5s
    IF    ${is_visible}
        Click    ${CreateNewMessageButton}
    ELSE
        Click    ${NewEmailButton}
    END
    Wait For Elements State    ${NewMessageTitle}    visible
    ${fromText}=    Get Attribute    ${FromField}    value
    Should Be Equal    ${fromText}    ${email_data['From']}
    Fill Text    ${RecipientsField}    ${email_data['To']}
    Fill Text    ${SubjectField}    ${email_data['Subject']}
    ${subjectText}=    Get Attribute    ${SubjectField}    value
    Should Be Equal    ${subjectText}    ${email_data['Subject']}
    Fill Text    ${EmailBody}    ${email_data['Body']}
    Click    ${SubmissionAssetsButton}
    Wait For Elements State    ${Email_breadcrums}    visible
        FOR    ${file}    IN    @{email_data['FileNames']}
        Wait For Elements State    ${SubmissionAssetsDialog}    visible
        ${asset_name}=    Catenate    SEPARATOR=    ${SelectOriginalDocument}    ${file}    ${SelectOriginalDocument_checkbox}
        Check Checkbox    ${asset_name}
        END
        Click    ${Attach1AssetButton}
        ${counter}=    Set Variable    1
    
        FOR    ${file}    IN    @{email_data['FileNames']}
        ${attachment_text_locator}=    Catenate    SEPARATOR=    ${AttachmentText_MultipleValues}    ${counter}    ]
        Wait For Elements State    ${attachment_text_locator}    visible    timeout=60s
        ${Textvalue}=    Get Text    ${attachment_text_locator}
        Should Be Equal    ${Textvalue}    ${file}
        ${counter}=    Evaluate    ${counter} + 1
        END
    Wait For Elements State    ${SendButton}    enabled
    Click    ${SendButton}
    Wait For Elements State    ${Email_breadcrums}    visible

Create New Mail For Upload 40 MB File
    [Documentation]    Composes and sends a new email, attaching a large file (up to 40MB) from the local file system.
    ...
    ...    *Arguments:*
    ...    - `${email_data}`: A dictionary containing email details, including the 'FileName' to upload.
    [Arguments]    ${email_data}
    Switch To Email Tab
    ${is_visible}=    Run Keyword And Return Status     Wait For Elements State    ${CreateNewMessageButton}    visible    timeout=5s
    IF    ${is_visible}
        Click    ${CreateNewMessageButton}
    ELSE
        Click    ${NewEmailButton}
    END
    Wait For Elements State    ${NewMessageTitle}    visible
    ${fromText}=    Get Attribute    ${FromField}    value
    Should Be Equal    ${fromText}    ${email_data['From']}
    Fill Text    ${RecipientsField}    ${email_data['To']}
    Fill Text    ${SubjectField}    ${email_data['Subject']}
    ${subjectText}=    Get Attribute    ${SubjectField}    value
    Should Be Equal    ${subjectText}    ${email_data['Subject']}
    Fill Text    ${EmailBody}    ${email_data['Body']}
    ${AbsolutePath}=    Normalize Path    ${path}${email_data['FileName']}
    Upload File By Selector    ${UploadFile}    ${AbsolutePath}
    Wait For Elements State    ${AttachmentText}    visible    timeout=60s
    ${Textvalue}=    Get Text    ${AttachmentText}
    Should Be Equal    ${Textvalue}    ${email_data['FileName']}
    Wait For Elements State    ${AttachmentText}    enabled
    Click    ${SendButton}
    Wait For Elements State    ${Email_breadcrums}    visible

Create New Mail For Upload Multiple Files
    [Documentation]    Composes and sends a new email, attaching multiple files from the local file system.
    ...
    ...    *Arguments:*
    ...    - `${email_data}`: A dictionary containing email details, including a list of 'FileNames' to upload.
    [Arguments]    ${email_data}
    Switch To Email Tab
    ${is_visible}=    Run Keyword And Return Status     Wait For Elements State    ${CreateNewMessageButton}    visible    timeout=5s
    IF    ${is_visible}
        Click    ${CreateNewMessageButton}
    ELSE
        Click    ${NewEmailButton}
    END
    Wait For Elements State    ${NewMessageTitle}    visible
    ${fromText}=    Get Attribute    ${FromField}    value
    Should Be Equal    ${fromText}    ${email_data['From']}
    Fill Text    ${RecipientsField}    ${email_data['To']}
    Fill Text    ${SubjectField}    ${email_data['Subject']}
    ${subjectText}=    Get Attribute    ${SubjectField}    value
    Should Be Equal    ${subjectText}    ${email_data['Subject']}
    Fill Text    ${EmailBody}    ${email_data['Body']}   
    ${counter}=    Set Variable    1
        FOR    ${file}    IN    @{email_data['FileNames']}
        ${AbsolutePath}=    Normalize Path    ${path}${file}
        Upload File By Selector    ${UploadFile}    ${AbsolutePath}
        ${attachment_text_locator}=    Catenate    SEPARATOR=    ${AttachmentText_MultipleValues}    ${counter}    ]
        Wait For Elements State    ${attachment_text_locator}    visible    timeout=60s
        ${Textvalue}=    Get Text    ${attachment_text_locator}
        Should Be Equal    ${Textvalue}    ${file}
        ${counter}=    Evaluate    ${counter} + 1
        END
    Wait For Elements State    ${SendButton}    enabled
    Click    ${SendButton}
    Wait For Elements State    ${Email_breadcrums}    visible

Verify Email Sent Successfully
    [Documentation]    Verifies that the 'Email Sent Successfully' confirmation message appears.
    Sleep    1s
    Get Element States    ${EmailSentSuccessfully}    validate    value & visible    'EmailSentSuccessfully should be visible.'

Verify Sent Email
    [Documentation]    Opens the most recent sent email and verifies its content.
    ...
    ...    *Arguments:*
    ...    - `@{email_data}`: A list of strings that are expected to be found in the email body or headers.
    [Arguments]    ${email_data}
    Click    ${SentEmailCard}
    FOR    ${data}    IN    @{email_data}
        ${locator}    Catenate    SEPARATOR=    ${SentEmailContent}    ${data}    ']
        Get Element States    ${locator}    validate    value & visible    'Element should be visible.'
    END

Verify Sent Email Data
    [Documentation]    Opens a specific email card from the list and verifies its content.
    ...
    ...    *Arguments:*
    ...    - `@{email_data}`: A list of strings that are expected to be found in the email body or headers.
    ...    - `${cardName}`: The identifier for the email card to be clicked.
    [Arguments]    ${email_data}    ${cardName}
    ${card}    Catenate    SEPARATOR=    (${EmailCard}    ${cardName}    '])[1]
    Click    ${card}
    FOR    ${data}    IN    @{email_data}
        ${locator}    Catenate    SEPARATOR=    ${SentEmailContent}    ${data}    ']
        Get Element States    ${locator}    validate    value & visible    'Element should be visible.'
    END

Create New Mail With Missing Data
    [Documentation]    Composes and sends a new email with a single submission asset as an attachment.
    ...
    ...    *Arguments:*
    ...    - `${email_data}`: A dictionary containing email details like 'From', 'To', 'Subject', 'Body', and 'AssetName'.
    [Arguments]    ${email_data}    ${Expected_PopUp_Msg}
    ${Actual_Popup_Msg}    Create List
    Switch To Email Tab
    ${is_visible}=    Run Keyword And Return Status     Wait For Elements State    ${CreateNewMessageButton}    visible    timeout=5s
    IF    ${is_visible}
        Click    ${CreateNewMessageButton}
    ELSE
        Click    ${NewEmailButton}
    END
    Wait For Elements State    ${NewMessageTitle}    visible
    ${fromText}=    Get Attribute    ${FromField}    value
    Should Be Equal    ${fromText}    ${email_data['From']}
    ${subjectText}=    Get Attribute    ${SubjectField}    value
    Should Be Equal    ${subjectText}    ${email_data['Subject']}
    Click    ${SendButton}
    FOR    ${Text}    IN    @{Expected_PopUp_Msg}
    ${element}    Catenate    SEPARATOR=    ${Missing_PopUp_Loc}    ${Text}']        
        Run Keyword And Continue On Failure     Get Element States    ${element}    validate    value & visible 
    END

Save and verify mail in Draft
    [Documentation]    Composes and sends a new email with a single submission asset as an attachment.
    ...
    ...    *Arguments:*
    ...    - `${email_data}`: A dictionary containing email details like 'From', 'To', 'Subject', 'Body', and 'AssetName'.
    [Arguments]    ${email_data}
    Switch To Email Tab
    ${is_visible}=    Run Keyword And Return Status     Wait For Elements State    ${CreateNewMessageButton}    visible    timeout=5s
    IF    ${is_visible}
        Click    ${CreateNewMessageButton}
    ELSE
        Click    ${NewEmailButton}
    END
    Wait For Elements State    ${NewMessageTitle}    visible
    ${fromText}=    Get Attribute    ${FromField}    value
    Should Be Equal    ${fromText}    ${email_data['From']}
    Fill Text    ${RecipientsField}    ${email_data['To']}
    ${subjectText}=    Get Attribute    ${SubjectField}    value
    Should Be Equal    ${subjectText}    ${email_data['Subject']}
    Fill Text    ${EmailBody}    ${email_data['Body']}
    Click    ${SubmissionAssetsButton}
    Set Viewport Size    2560    1440
    Wait For Elements State    ${Email_breadcrums}    visible
        FOR    ${file}    IN    @{email_data['FileNames']}
        Wait For Elements State    ${SubmissionAssetsDialog}    visible
        ${asset_name}=    Catenate    SEPARATOR=    ${SelectOriginalDocument}    ${file}    ${SelectOriginalDocument_checkbox}
        Check Checkbox    ${asset_name}
        END
        Click    ${Attach1AssetButton}
        Set Viewport Size    1280    720
        ${counter}=    Set Variable    1
        FOR    ${file}    IN    @{email_data['FileNames']}
        ${attachment_text_locator}=    Catenate    SEPARATOR=    ${AttachmentText_MultipleValues}    ${counter}    ]
        Wait For Elements State    ${attachment_text_locator}    visible    timeout=60s
        ${Textvalue}=    Get Text    ${attachment_text_locator}
        Should Be Equal    ${Textvalue}    ${file}
        ${counter}=    Evaluate    ${counter} + 1
        END
    Click    ${Save_Draft}
    Get Element States    ${Draft_Saved_Msg}    validate    value & visible
    Get Element States    ${Draft_mail_Loc}    validate    value & visible
    Click    ${Draft_mail_Loc}
    ${Actual_Reciver_Mail}    Get Text    ${Resiver_Mail}
    Should Be Equal   ${email_data['To']}    ${Actual_Reciver_Mail}
    ${Actual_Body_Msg}    Get Text    ${Body_Msg}
    Should Be Equal    ${email_data['Body']}    ${Actual_Body_Msg}  
    Get Element States    ${NewEmailButton}    validate    value & visible
    Wait For Elements State    ${SendButton}    visible    5s
    # Click    ${SendButton}
    # Verify Email Sent Successfully


Discard the Created Email
    [Documentation]    Composes and sends a new email with a single submission asset as an attachment.
    ...
    ...    *Arguments:*
    ...    - `${email_data}`: A dictionary containing email details like 'From', 'To', 'Subject', 'Body', and 'AssetName'.
    [Arguments]    ${email_data}
    Switch To Email Tab
    ${is_visible}=    Run Keyword And Return Status     Wait For Elements State    ${CreateNewMessageButton}    visible    timeout=5s
    IF    ${is_visible}
        Click    ${CreateNewMessageButton}
    ELSE
        Click    ${NewEmailButton}
    END
    Wait For Elements State    ${NewMessageTitle}    visible
    ${fromText}=    Get Attribute    ${FromField}    value
    Run Keyword And Continue On Failure    Should Be Equal    ${fromText}    ${email_data['From']}
    Fill Text    ${RecipientsField}    ${email_data['To']}
    ${subjectText}=    Get Attribute    ${SubjectField}    value
    Run Keyword And Continue On Failure    Should Be Equal    ${subjectText}    ${email_data['Subject']}
    Fill Text    ${EmailBody}    ${email_data['Body']}
      Click    ${SubmissionAssetsButton}
    Wait For Elements State    ${Email_breadcrums}    visible
        FOR    ${file}    IN    @{email_data['FileNames']}
        Wait For Elements State    ${SubmissionAssetsDialog}    visible
        ${asset_name}=    Catenate    SEPARATOR=    ${SelectOriginalDocument}    ${file}    ${SelectOriginalDocument_checkbox}
        Check Checkbox    ${asset_name}
        END
        Click    ${Attach1AssetButton}
        ${counter}=    Set Variable    1
        FOR    ${file}    IN    @{email_data['FileNames']}
        ${attachment_text_locator}=    Catenate    SEPARATOR=    ${AttachmentText_MultipleValues}    ${counter}    ]
        Wait For Elements State    ${attachment_text_locator}    visible    timeout=60s
        ${Textvalue}=    Get Text    ${attachment_text_locator}
        Run Keyword And Continue On Failure    Should Be Equal    ${Textvalue}    ${file}
        ${counter}=    Evaluate    ${counter} + 1
        END
        Get Element States    ${Discard_Button}    validate    value & visible
        Click    ${Discard_Button}    
         ${is_visible}=    Run Keyword And Return Status     Wait For Elements State    ${CreateNewMessageButton}    visible    timeout=5s
         ${is_visible1}=    Run Keyword And Return Status     Wait For Elements State    ${NewEmailButton}    visible    timeout=5s
        ${result}=    Evaluate    ${is_visible} or ${is_visible1} 
        Run Keyword And Continue On Failure    Should Be True    ${result} 

Verify Discard Button visible
    [Documentation]    Composes and sends a new email with a single submission asset as an attachment.
    ...
    ...    *Arguments:*
    ...    - `${email_data}`: A dictionary containing email details like 'From', 'To', 'Subject', 'Body', and 'AssetName'.
    [Arguments]    ${email_data}
    Switch To Email Tab
    ${is_visible}=    Run Keyword And Return Status     Wait For Elements State    ${CreateNewMessageButton}    visible    timeout=5s
    IF    ${is_visible}
        Click    ${CreateNewMessageButton}
    ELSE
        Click    ${NewEmailButton}
    END
    Wait For Elements State    ${NewMessageTitle}    visible
    ${fromText}=    Get Attribute    ${FromField}    value
    Should Be Equal    ${fromText}    ${email_data['From']}
    Fill Text    ${RecipientsField}    ${email_data['To']}
    ${subjectText}=    Get Attribute    ${SubjectField}    value
    Should Be Equal    ${subjectText}    ${email_data['Subject']}
    Fill Text    ${EmailBody}    ${email_data['Body']}
      Click    ${SubmissionAssetsButton}
      Set Viewport Size    2560    1440
    Wait For Elements State    ${Email_breadcrums}    visible
        FOR    ${file}    IN    @{email_data['FileNames']}
        Wait For Elements State    ${SubmissionAssetsDialog}    visible
        ${asset_name}=    Catenate    SEPARATOR=    ${SelectOriginalDocument}    ${file}    ${SelectOriginalDocument_checkbox}
        Check Checkbox    ${asset_name}
        END
        Click    ${Attach1AssetButton}
        Set Viewport Size    1280    720
        ${counter}=    Set Variable    1
   
        FOR    ${file}    IN    @{email_data['FileNames']}
        ${attachment_text_locator}=    Catenate    SEPARATOR=    ${AttachmentText_MultipleValues}    ${counter}    ]
        Wait For Elements State    ${attachment_text_locator}    visible    timeout=60s
        ${Textvalue}=    Get Text    ${attachment_text_locator}
        Should Be Equal    ${Textvalue}    ${file}
        ${counter}=    Evaluate    ${counter} + 1
        END
        Get Element States    ${Discard_Button}    validate    value & visible
        Click    ${Discard_Button}    
         ${is_visible}=    Run Keyword And Return Status     Wait For Elements State    ${CreateNewMessageButton}    visible    timeout=5s
         ${is_visible1}=    Run Keyword And Return Status     Wait For Elements State    ${NewEmailButton}    visible    timeout=5s
        ${result}=    Evaluate    ${is_visible} or ${is_visible1}
        Should Be True    ${result}