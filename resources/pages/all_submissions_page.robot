*** Settings ***
Library    String
Library    Collections
Variables  ../locators/all_submissions.py
Resource   ../../utils/common_keywords.robot
Library    OperatingSystem

*** Variables ***
${FilePath}        ${CURDIR}/../../uploads/ACORD-MSIG.pdf
${path}             ${CURDIR}/../../uploads/
${processing_stage_timeout}    2000s
${upload_procesing_timeout}    2000s
${element_timeout}    180s

*** Keywords ***
Search Submission by Submission ID
    [Documentation]    Searches for a submission using the provided submission ID.
    ...    It first checks if the search input field is visible. If not, it clicks the search button to reveal it.
    ...    Finally, it types the submission ID into the search field.
    ...
    ...    *Arguments:*
    ...    - `${data_submissionID}`: The ID of the submission to search for.
    [Arguments]    ${data_submissionID}
    ${fieldStatus}    Run Keyword And Return Status    Wait For Elements State    ${SearchSubmissionField}    visible    timeout=3s
    IF    ${fieldStatus}
        Log    Search field is visible
    ELSE
        Wait For Elements State    ${SearchSubmissionButton}    visible
        Click    ${SearchSubmissionButton}
    END
    Wait For Elements State    ${SearchSubmissionField}    visible
    Fill Text    ${SearchSubmissionField}    ${data_submissionID}
     Press Keys    ${SearchSubmissionField}    Enter

Check the submission for the searched Submission ID
    [Documentation]    Selects the checkbox corresponding to a given submission ID.
    ...    It dynamically creates the locator for the checkbox associated with the submission.
    ...    If the checkbox is already selected, it will be un-checked first before being checked again to ensure a consistent state.
    ...
    ...    *Arguments:*
    ...    - `${data_submissionID}`: The submission ID for which to check the checkbox.
    [Arguments]    ${data_submissionID}
    ${submission_checkBox}    Catenate    SEPARATOR=    ${SubmissionCheckBox}    ${data_submissionID}    ']
    Wait For Elements State    ${submission_checkBox}    visible
    ${checkbox_selected}    Run Keyword And Return Status    Get Checkbox State    ${submission_checkBox}
    IF    ${checkbox_selected}
        Uncheck Checkbox    ${submission_checkBox}
    END
    Check Checkbox    ${submission_checkBox}

Click on the Submission type
    [Documentation]    Clicks on a specific submission type link.
    ...
    ...    *Arguments:*
    ...    - `${data_submission}`: The text of the submission type to be clicked.
    [Arguments]    ${data_submission}
    ${locator_submission_type}    Catenate    SEPARATOR=    ${SubmissionType}    ${data_submission}    ']
    Wait For Elements State    ${locator_submission_type}    visible
    Click    ${locator_submission_type}

Verify Reprocessing Submission Popup
    [Documentation]    Verifies that the reprocessing submission popup appears and then disappears.
    ...    This is useful for ensuring an asynchronous reprocessing action has completed.
    Wait For Elements State    ${ReprocessingPopup}    visible
    Wait For Elements State    ${ReprocessingPopup}    detached

Click on the Preview Submission - Eye icon
    [Documentation]    Opens the submission preview by clicking the 'eye' icon.
    ...    It first hovers over the company name associated with the submission ID to make the preview icon visible.
    ...
    ...    *Arguments:*
    ...    - `${data_submissionID}`: The ID of the submission to preview.
    [Arguments]    ${data_submissionID}
    ${locator_company_name}    Catenate    SEPARATOR=    ${CompanyName}    ${data_submissionID}    ']
    Wait For Elements State    ${locator_company_name}    visible
    Hover    ${locator_company_name}
    Wait For Elements State    ${EyeIcon}    visible
    Click    ${EyeIcon}

Verify side bar menu is displayed
    [Documentation]    Verifies that the submission preview side bar menu is displayed.
    ...    It also retrieves the company name from the preview tab as part of the verification.
    Wait For Elements State    ${PreviewSubmissionTab}    visible
    Get Text    ${CompanyNameInPreviewTab}

Verify Company name in side bar menu
    [Documentation]    Verifies the company name displayed in the side bar menu matches the expected name.
    ...
    ...    *Arguments:*
    ...    - `${expectedCompanyName}`: The expected company name.
    [Arguments]    ${expectedCompanyName}
    ${companyName}    Get Text    ${CompanyNameInPreviewTab}
    ${actualCompanyName}    Strip String    ${companyName}
    Should Be Equal    ${expectedCompanyName}    ${actualCompanyName}    'Company name in sidebar should match the expected company name.'

Verify Address1 in side menu bar
    [Documentation]    Verifies the first line of the address in the side menu bar.
    ...
    ...    *Arguments:*
    ...    - `${expectedAddress}`: The expected address line 1.
    [Arguments]    ${expectedAddress}
    ${Address}    Get Text    ${Address1}
    ${actualAddress}    Strip String    ${Address}
    Should Be Equal    ${expectedAddress}    ${actualAddress}    'Address in sidebar should match the expected address.'

Verify Address2 in side menu bar
    [Documentation]    Verifies that all parts of the second address line are visible in the side menu bar.
    ...
    ...    *Arguments:*
    ...    - `@{expectedAddress2}`: A list of strings that make up the second address line.
    [Arguments]    @{expectedAddress2}
    FOR    ${address2}    IN    @{expectedAddress2}
        ${address}    Catenate    SEPARATOR=    ${AddressText}    ${address2}    ')]
        Wait For Elements State    ${address}    visible
    END

Close Side bar menu
    [Documentation]    Closes the submission preview side bar menu.
    Wait For Elements State    ${CloseSideBar}    visible
    Click    ${CloseSideBar}

Verify Submission Id is available
    [Documentation]    Checks if a submission with the given ID is present in the 'All Submissions' list.
    ...    It performs a search and checks if the 'No Submissions' message is displayed.
    ...
    ...    *Arguments:*
    ...    - `${submission_id}`: The submission ID to verify.
    ...
    ...    *Returns:*
    ...    - `${submission_id_status}`: `True` if the submission does *not* exist (i.e., 'No Submissions' message is visible), `False` otherwise.
    [Arguments]    ${submission_id}
    Wait For Elements State    ${AllSubmissions}    visible
    Search Submission by Submission ID    ${submission_id}
    ${submission_id_status}    Run Keyword And Return Status    Wait For Elements State    ${NoSubmissions}    visible    timeout=10s
    Click    ${ClearSearch}
    RETURN    ${submission_id_status}

Create new submission if the submission not exists
    [Documentation]    Creates a new submission if one with the given ID does not already exist.
    ...    It uses `Verify Submission Id is available` to check for existence.
    ...    If the submission doesn't exist, it navigates to the new submission page, uploads a default PDF file, and creates the submission.
    ...
    ...    *Arguments:*
    ...    - `${submission_id}`: The submission ID to check for and potentially use for the new submission.
    ...
    ...    *Returns:*
    ...    - The new submission ID if one was created, otherwise the existing `${submission_id}`.
    [Arguments]    ${submission_id}
    ${AbsolutePath}=    Normalize Path    ${FilePath}
    ${submission}    Verify Submission Id is available    ${submission_id}
    IF    ${submission}
        Log Step    'Creating New Submission!'
        Wait For Elements State    ${NewButton}    visible
        Click    ${NewButton}
        Wait For Elements State    ${CreateSubmissionTab}    visible
        Click    ${UploadSupportingDocuments}
        Wait For Elements State    ${BrowseFile}    visible
        Upload File By Selector    ${UploadFile}    ${AbsolutePath}
        Sleep    2s
        Scroll To Element    ${CreateSubmissionButton}
        Wait For Elements State    ${CreateSubmissionButton}    enabled
        Click    ${CreateSubmissionButton}
        Sleep    5s
        Wait For Elements State    ${Processing}    visible
        Wait For Elements State    ${ProcessingStatus}    visible
        ${retrive_submission_id}    Get Text    ${Locator_SubmissionId}
        ${get_submission_id}    Strip String    ${retrive_submission_id}
        Wait For Elements State    ${ProcessingStatus}    detached    timeout=${upload_procesing_timeout}
        Log Step    'New Submission ID -> ${get_submission_id}'
        RETURN    ${get_submission_id}
    ELSE
        Log Step    '${submission_id} is exists no need to create new one!'
        RETURN    ${submission_id}
    END

Create new submission
    [Documentation]    Creates a new submission by uploading a specified file.
    ...    This keyword handles the full UI flow for creating a submission: setting filters, rearranging columns, clicking 'New', uploading the file, and waiting for processing to complete.
    ...
    ...    *Arguments:*
    ...    - `${file_name}`: The name of the file to upload from the `uploads` directory.
    ...    - `@{submission_column_names}`: A list of column names to configure on the submissions page.
    ...
    ...    *Returns:*
    ...    - The ID of the newly created submission.
    [Arguments]    ${file_name}    @{submission_column_names}
    ${AbsolutePath}=    Normalize Path    ${path}${file_name}
    Log    ${AbsolutePath}
        Select Date Filter option    Today
        Click All submissions option
        Rearrange Submission Page Columns    @{submission_column_names}
        Log Step    'Creating New Submission!'
        Wait For Elements State    ${NewButton}    visible
        Click    ${NewButton}
        Sleep    3s
        ${status}    Run Keyword And Return Status    Get Element States    ${SelectPage}    validate    value & visible    'SelectPage should be visible.'
        IF    ${status}  
        Select Options By    ${SelectPage}    text    100
        END
        Sleep    2s
        # ${existingSubmissionCount1}    Get Element Count    ${ProcessingStatusCount}
        # Log    ${existingSubmissionCount1}
        Wait For Elements State    ${CreateSubmissionTab}    visible
        Click    ${UploadSupportingDocuments}
        Wait For Elements State    ${BrowseFile}    visible
        Upload File By Selector    ${UploadFile}    ${AbsolutePath}
        Sleep    2s
        Scroll To Element    ${CreateSubmissionButton}
        Wait For Elements State    ${CreateSubmissionButton}    enabled
        Click    ${CreateSubmissionButton}
        Sleep    5s
        Wait For Elements State    ${Processing}    visible 
        # Click My submissions option
        # Sleep    2s
        # Click All submissions option
        # Wait For Elements State    ${ProcessingStatus}    visible
        #  ${existingSubmissionCount2}    Get Element Count    ${ProcessingStatusCount}
        # Log    ${existingSubmissionCount2}
        # IF    ${existingSubmissionCount2} == ${existingSubmissionCount1}
        #    ${index}    Evaluate    ${existingSubmissionCount2} + 1
        #    ${locator}    Catenate    SEPARATOR=    ${ExistingProcessingStatus}    ${index}    ]  
        #     Wait For Elements State    ${locator}    visible
        # END
        Wait For Elements State    ${ProcessingStatus}    visible    timeout=120s    
        ${retrive_submission_id}    Get Text    ${Locator_SubmissionId}
        ${get_submission_id}    Strip String    ${retrive_submission_id}
        Wait For Elements State    ${ProcessingStatus}    detached    timeout=${upload_procesing_timeout}
        # Wait For Elements State    ${CloseSubmissionPreview}    visible    timeout=60s
        # Click    ${CloseSubmissionPreview}
        Log Step    'New Submission ID -> ${get_submission_id}'
        RETURN    ${get_submission_id}

Select Submission using submission id
    [Documentation]    Selects a specific submission from the 'All Submissions' list by its ID.
    ...    It configures the view, searches for the submission, and then clicks on the company name to open it.
    ...
    ...    *Arguments:*
    ...    - `${data_submissionID}`: The ID of the submission to select.
    ...    - `@{submission_column_names}`: A list of column names to configure on the submissions page.
    [Arguments]    ${data_submissionID}    @{submission_column_names}
    Click All submissions option
    Rearrange Submission Page Columns    @{submission_column_names}
    Search Submission By Submission ID    ${data_submissionID}
    ${locator_company_name}    Catenate    SEPARATOR=    (${CompanyName}    ${data_submissionID}    ${BalanceCompanyName})[1]
    Wait For Elements State    ${locator_company_name}    visible
    ${locator_product_name}    Catenate    SEPARATOR=    (${CompanyName}    ${data_submissionID}    ${Loc_ProductName})[1]
    ${product}    Get Text    ${locator_product_name}
    Click    ${locator_company_name}
    Sleep    2s
    ${visible}    Run Keyword And Return Status    Wait For Elements State    ${locator_company_name}    visible    timeout=3s
    IF    ${visible}
         Click    ${locator_company_name}
    END
    RETURN    ${product}

Verify Submission page is displayed
    [Documentation]    Verifies that the submission details page is displayed correctly after opening a submission.
    ...    It does this by waiting for the 'Answers' tab and the 'Schema' button to be visible.
    Wait For Elements State    ${Answers}    visible    timeout=${element_timeout}
    Click    ${Answers}
    Wait For Elements State    ${SchemaButton}    visible    timeout=${element_timeout}
    Get Element States    ${SchemaButton}    validate    value & visible    'SchemaButton should be visible.'

Click Edit Submission
    [Documentation]    Clicks the 'Edit Submission' button to enable editing fields on the submission page.
    ...    It then waits for the 'Save Submission' button to become visible.
    ${status}    Run Keyword And Return Status    Get Element States    ${SaveSubmission}    validate    value & visible    'EditSubmission should be visible.'
    IF    ${status} == False
        Click    ${EditSubmission}
        Wait For Elements State    ${SaveSubmission}    visible
    END

Click and verify Clearance tab
    [Documentation]    Navigates to the 'Clearance' tab within a submission and verifies it is displayed.
     Wait For Elements State    ${Clearance}    visible    
     Click    ${Clearance}
     Run Keyword And Continue On Failure    Wait For Elements State    ${ClearanceTab}    visible    
     
Click Insured Tab
    [Documentation]    Navigates to the 'Insured' tab within a submission.
    Wait For Elements State    ${Insured}    visible    timeout=${element_timeout}
    Click    ${Insured}

Verify PDF Data in Insured Tab
    [Documentation]    Verifies that the text of specific fields in the 'Insured' tab matches the expected data.
    ...    The fields checked are hardcoded within the keyword.
    ...
    ...    *Arguments:*
    ...    - `@{ExpectedPDFText}`: A list of strings containing the expected text for each verified field.
    [Arguments]    ${ExpectedPDFText}
    @{locators}     Create List    ${InsuredName}    ${InsuredAddress}    ${InsuredAddressStreet}    ${InsuredAddressCity}    ${InsuredAddressState}    ${InsuredAddressPostalCode}    ${InsuredAddressCounty}    ${InsuredAddressCountry}
    @{ActualPDFText}    Create List
    FOR    ${locator}    IN    @{locators}
        Scroll To Element    ${locator}
        ${text}    Get Text    ${locator}
        ${trimText}    Strip String    ${text}
        Append To List    ${ActualPDFText}    ${trimText}
    END
    Log    ${ActualPDFText}
    Log    ${ExpectedPDFText}
    Lists Should Be Equal    ${ExpectedPDFText}    ${ActualPDFText}    'PDF text content should match the expected values.'

Fill the data for issue fields
    [Documentation]    Fills in the SIC Code, SIC Description, and NAICS code fields in the 'Insured' tab.
    ...    It handles clicking to enable the input fields before typing.
    ...
    ...    *Arguments:*
    ...    - `${data_sic_code}`: The SIC code to enter.
    ...    - `${data_sic_description}`: The SIC description to enter.
    ...    - `${data_naisc_code}`: The NAICS code to enter.
    [Arguments]    ${data_sic_code}    ${data_sic_description}    ${data_naisc_code}
    Get Element States    ${Insured_code_button}    validate    value & visible    'Insured_code_button should be visible.'
    Click With Options    ${Insured_code_button}    clickCount=2
    Click    ${Insured_code_button}
    ${status}    Run Keyword And Return Status    Get Element States    ${Insured_code_button}    validate    value & visible 
    IF    ${status}    
    Click    ${Insured_code_button}
    END
    Wait For Elements State    ${Insured_code_input}    visible    timeout=${element_timeout}
    Clear Text    ${Insured_code_input}
    Sleep    2s
    Type Text    ${Insured_code_input}    ${data_sic_code}
    Get Element States    ${InsuredDescriptionButton}    validate    value & visible    'InsuredDescriptionButton should be visible.'
    Click With Options    ${InsuredDescriptionButton}    clickCount=2 
    Click    ${InsuredDescriptionButton}
    ${status1}    Run Keyword And Return Status    Get Element States    ${InsuredDescriptionButton}    validate    value & visible 
    IF    ${status1}    
    Click    ${InsuredDescriptionButton}
    END
    Sleep    2s
    Wait For Elements State    ${InsuredDescriptionInput}    visible    timeout=${element_timeout}
    Type Text     ${InsuredDescriptionInput}    ${data_sic_description}
    Scroll To    ${InsuredNAICSCode}    top
    Get Element States    ${InsuredNAICSCode}    validate    value & visible    'InsuredNAICSCode should be visible.'
    Click With Options    ${InsuredNAICSCode}    clickCount=2
    Sleep    2s
    Type Text    ${InsuredNAICSInput}    ${data_naisc_code}
  
Verify User Mod is message for updated fields
    [Documentation]    Verifies that the 'User Modified' indicator is visible for the SIC and NAICS code fields after they have been edited.
    @{locators}    Create List    ${UserModeForCode}    ${UserModeForDescription}    ${UserModeInNAICS}
    FOR    ${locator}    IN    @{locators}
        Get Element States    ${locator}    validate    value & visible    'Locator should be visible.'
    END

Click Processing Tab
    [Documentation]    Navigates to the 'Processing' tab within a submission.
    Hover    ${Insured_code_button}
    Scroll To Element    ${processingInSubmission}
    Wait For Elements State    ${processingInSubmission}    visible    timeout=30s
    Click    ${processingInSubmission}

Fill the data for issue fields in processing
    [Documentation]    Fills in the Underwriter and Operations contact information in the 'Processing' tab.
    ...
    ...    *Arguments:*
    ...    - `${data_UnderwriterName}`: The name of the underwriter.
    ...    - `${data_UnderWriterEmail}`: The email of the underwriter.
    ...    - `${data_OperationsName}`: The name of the operations contact.
    ...    - `${data_OperationsEmail}`: The email of the operations contact.
    [Arguments]    ${data_UnderwriterName}    ${data_UnderWriterEmail}    ${data_OperationsName}     ${data_OperationsEmail}    ${data_UnderwrittingOffice}    ${data_Channel}
    Wait For Elements State    ${UnderwriterName}    visible    timeout=${element_timeout}
    Click    ${UnderwriterName}
    Type Text    ${UnderwriterInput}    ${data_UnderwriterName}
    Click    ${UnderwriterEmail}
    Type Text    ${UnderwriterEmailInput}    ${data_UnderWriterEmail}
    Get Element States    ${UnderwrittingOffice}    validate    value & visible    'UnderwrittingOffice should be visible.'
    Click    ${UnderwrittingOffice}
    Type Text    ${UnderwrittingOfficeInput}    ${data_UnderwrittingOffice}
    Get Element States    ${OperationsName}    validate    value & visible    'OperationsName should be visible.'
    Click    ${OperationsName}
    Type Text    ${OperationsNameInput}    ${data_OperationsName}
    Get Element States    ${OperationsEmail}    validate    value & visible    'OperationsEmail should be visible.'
    Click    ${OperationsEmail}
    Type Text    ${OperationsEmailInput}    ${data_OperationsEmail}
    Get Element States    ${Channel}    validate    value & visible    'Channel should be visible.'
    Click    ${Channel}
    Type Text    ${ChannelInput}    ${data_Channel}

Click Producer Tab
    [Documentation]    Navigates to the 'Producer' tab within a submission.
    Scroll To Element    ${producer}
    Wait For Elements State    ${producer}    visible    timeout=${element_timeout}
    Click    ${producer}

Verify PDF Data in Producer Tab
    [Documentation]    Verifies that the text of specific fields in the 'Producer' tab matches the expected data.
    ...    The fields checked are hardcoded within the keyword.
    ...
    ...    *Arguments:*
    ...    - `@{ExpectedPDFText}`: A list of strings containing the expected text for each verified field.
    [Arguments]    @{ExpectedPDFText}
    @{locators}     Create List    ${Agency}    ${ProducerAddress}    ${ProducerAddressStreet}    ${ProducerAddress2}    ${ProducerAddressCity}    ${ProducerAddressState}    ${ProducerPostalCode}    ${ProducerCountry}
    @{ActualPDFText}    Create List
    FOR    ${locator}    IN    @{locators}
        Scroll To Element    ${locator}
        ${text}    Get Text    ${locator}
        ${trimText}    Strip String    ${text}
        Append To List    ${ActualPDFText}    ${trimText}
    END
    Log    ${ExpectedPDFText}
    Log    ${ActualPDFText}
    Lists Should Be Equal    ${ExpectedPDFText}    ${ActualPDFText}

Fill the data for issues field in Producer
    [Documentation]    Fills in the Producer's name, email, and optionally their code in the 'Producer' tab.
    ...
    ...    *Arguments:*
    ...    - `${data_producer_name}`: The name of the producer.
    ...    - `${data_producer_email}`: The email of the producer.
    ...    - `${data_producer_code}`: (Optional) The code for the producer.
    [Arguments]    ${data_producer_name}    ${data_producer_email}    ${data_producer_code}=None
    Scroll To Element    ${ProducerName}
    Click    ${ProducerName}
    Type Text    ${ProducerNameInput}    ${data_producer_name}
    Get Element States    ${UserModForProducerName}    validate    value & visible    'UserModForProducerName should be visible.'
    Scroll To Element    ${ProducerEmailButton}
    Click    ${ProducerEmailButton}
    Type Text    ${ProducerEmailInput}    ${data_producer_email}
    Get Element States    ${UserModForProducerEmail}    validate    value & visible    'UserModForProducerEmail should be visible.'
    IF    '${data_producer_code}' != 'None'
        Scroll To Element    ${ProducerCodeButton}
        Click    ${ProducerCodeButton}
        Type Text    ${ProducerCodeInput}    ${data_producer_code}
        Get Element States    ${UserModForProducerCode}    validate    value & visible    'UserModForProducerCode should be visible.'
    END

Click Coverage Tab
    [Documentation]    Navigates to the 'Coverage' tab within a submission.
    Scroll To Element    ${Coverage}
    Wait For Elements State    ${Coverage}    visible    timeout=${element_timeout}
    Click    ${Coverage}
    
Verify the Coverage data
    [Documentation]    Verifies the effective date, expiration date, and product type in the 'Coverage' tab.
    ...
    ...    *Arguments:*
    ...    - `${data_expected_eff_date}`: The expected effective date.
    ...    - `${data_expected_expiry_date}`: The expected expiration date.
    ...    - `${data_expected_product}`: The expected product type.
    [Arguments]    ${data_expected_eff_date}    ${data_expected_expiry_date}    ${data_expected_product}
     Wait For Elements State    ${EffectiveDate}    visible    timeout=${element_timeout}
     ${actualEffectiveDate}    Get Text    ${EffectiveDate}
     ${trimEffectiveDate}    Strip String    ${actualEffectiveDate}
     Should Be Equal    ${data_expected_eff_date}    ${trimEffectiveDate}
     ${actualExpirationDate}    Get Text    ${ExpirationDate}
     ${trimExpirationDate}    Strip String    ${actualExpirationDate}
     Should Be Equal    ${data_expected_expiry_date}    ${trimExpirationDate}

Fill the data for issues field in Coverage
    [Arguments]    ${data}    
        Add LOB if not present    ${data['Product']}   ${data['product_dropdown_values']}
        ${Actual_Product_Segment_Text}    Create List 
        Click    ${ProductSegment}
        Click    ${ProductSegmentDropdown}
          ${Product_Segment_DropDownElements}    Get Elements    ${Product_segment_DropDownElement}
    FOR    ${element}    IN    @{Product_Segment_DropDownElements}
        ${Product_Segment_Text}    Get Text    ${element}
        ${Product_Segment_Text}    Strip String    ${Product_Segment_Text}   
        Append To List    ${Actual_Product_Segment_Text}    ${Product_Segment_Text}     
    END
    Log    ${Actual_Product_Segment_Text}
    Log    ${data['ProductSegment_dropdown_values']}
    Run Keyword And Continue On Failure    Lists Should Be Equal    ${data['ProductSegment_dropdown_values']}    ${Actual_Product_Segment_Text}
    ${value}    Catenate    SEPARATOR=    ${CoverageProductSelect}    ${data['ProductSegment']}    '])[1]
    Wait For Elements State    ${value}    visible
    Click    ${value}


Click Issues Tab
    [Documentation]    Navigates to the 'Issues' tab within a submission.
    Scroll To Element    ${Issues_tab}
    Wait For Elements State    ${Issues_tab}    visible    timeout=${element_timeout}
    Click    ${Issues_tab}

Verify updated datas in Issues Tab
    [Documentation]    Verifies that data updated in other tabs (Insured, Processing, Producer) is correctly reflected in the 'Issues' tab.
    ...
    ...    *Arguments:*
    ...    - `@{ExpectedPDFText}`: A list of strings containing the expected text for each verified field.
    [Arguments]    @{ExpectedPDFText}
    @{locators}     Create List    ${Issues_sic_code}    ${Issues_description}    ${Issues_naics_code}    ${Issues_underwriter_name}    ${Issues_underwriter_email}    ${Issues_underwritting_office}    ${Issues_operations_name}    ${Issues_operations_email}    ${Issues_channel}    ${Issues_producer_name}
    @{ActualPDFText}    Create List
    FOR    ${locator}    IN    @{locators}
        Scroll To Element    ${locator}
        ${text}    Get Text    ${locator}
        ${trimText}    Strip String    ${text}
        Append To List    ${ActualPDFText}    ${trimText}
    END
    Log    ${ExpectedPDFText}
    Log    ${ActualPDFText}
    Lists Should Be Equal    ${ExpectedPDFText}    ${ActualPDFText}

Click Finish Tab
    [Documentation]    Navigates to the 'Finish' tab within a submission.
    Scroll To Element    ${Finish_tab}
    Wait For Elements State    ${Finish_tab}    visible    timeout=${element_timeout}
    Click    ${Finish_tab}

Verify and click the save and close button
    [Documentation]    Verifies the 'Finish' tab is correctly displayed and then clicks the 'Save and Close' button.
    Wait For Elements State    ${All_Done}    visible    timeout=${element_timeout}
    Get Element States    ${Please_Review_Msg}    validate    value & visible    'Please_Review_Msg should be visible.'
    Get Element States    ${SaveAndClose}    validate    value & visible    'SaveAndClose should be visible.'
    Click    ${SaveAndClose}
    #  ${error_Message}    Run Keyword And Return Status    Get Element States    ${Error_Saving_popup}
    # IF    ${error_Message} == True
    # Get Element States    ${SaveAndClose}    validate    value & visible    'SaveAndClose should be visible.'
    # Wait For Elements State    ${SaveAndClose}    visible        timeout=10s
    # Click    ${SaveAndClose}
    # END
    Wait For Elements State    ${processingStage1}    visible    timeout=30s
    Wait For Elements State    ${processingStage1}    hidden    timeout=300s

Verify Error popup is exists
     ${error_Message}    Run Keyword And Return Status    Get Element States    ${Error_Saving_popup}
    IF    ${error_Message} == True
    Get Element States    ${SaveAndClose}    validate    value & visible    'SaveAndClose should be visible.'
    Wait For Elements State    ${SaveAndClose}    visible    5s
    Sleep    60s
    Click    ${SaveAndClose}
    END

Switch to Documents
    [Documentation]    Switches the view to the 'Documents' section for the current submission.
    Wait For Elements State    ${Documents}    visible    timeout=30s
    # ${promise} =         Promise To    Wait For Alert    action=accept
    # Handle Future Dialogs    action=accept    
    Click    ${Documents}
    # Run Keyword And Ignore Error    Wait For      ${promise}
    # Click    ${Documents}

Verify datas in UserModification file
    [Documentation]    Verifies the contents of the 'UserModification' file in the 'Documents' section.
    ...    It compares a list of expected text values with the actual values found in the document.
    ...
    ...    *Arguments:*
    ...    - `@{expectedText}`: A list of strings with the expected values.
    [Arguments]    @{expectedText}
    Scroll To Element    ${UserModification}
    Wait For Elements State    ${UserModification}    visible    timeout=${element_timeout}
    Click    ${UserModification}
    @{variables}    Get Elements    ${UserModificationVariable}
    @{values}    Get Elements    ${UserModificationValue}
    @{actualText}    Create List    
    FOR    ${value}    IN    @{values}
        ${text}    Get Text    ${value}
        ${trimValue}    Strip String    ${text}
        Append To List    ${actualText}    ${trimValue}
    END
    Log    ${expectedText}
    Log    ${actualText}
    Lists Should Be Equal    ${expectedText}    ${actualText}

Save Submission
    [Documentation]    Clicks the 'Save Submission' button.
    Wait For Elements State    ${SaveSubmission}    visible
    Click    ${SaveSubmission}

Verify Save Submission Popup
    [Documentation]    Verifies that the 'Are you sure?' popup is displayed after clicking 'Save Submission'.
    Get Element States    ${AreYouSurePopup}    validate    value & visible    'AreYouSurePopup should be visible.'
    Get Element States    ${CancelButtonInSave}    validate    value & visible    'CancelButtonInSave should be visible.'
    Get Element States    ${ContinueButtonInSave}    validate    value & visible    'ContinueButtonInSave should be visible.'

Click Continue Button
    [Documentation]    Clicks the 'Continue' button on the 'Save Submission' confirmation popup.
    Click    ${ContinueButtonInSave}

Save Submission And verify popup
    [Documentation]    A comprehensive keyword that handles saving a submission, including dealing with a potential 'Reactive' button popup.
    ...    It will save, verify the confirmation, and click continue. It includes logic to handle a 'Reactive' state if it appears.
    ${reactiveButtonStatus}    Run Keyword And Return Status    Wait For Elements State    ${Reactive}    visible    timeout=10s
    IF    ${reactiveButtonStatus}
        Switch to Documents
        Click    ${Side_Bar_Risk360_Button}
        Click    ${Reactive}
        Click    ${AcceptButtonInReactive}
        Wait For Elements State    ${Reactive}    detached    timeout=${element_timeout}
        Switch to Documents
        Click    ${Side_Bar_Risk360_Button}
        Sleep    3s
        ${status}    Run Keyword And Return Status    Wait For Elements State    ${processingStageInLeftMenu}    visible    timeout=${processing_stage_timeout}
        IF     ${status}
            Click    ${Side_Bar_Risk360_Button}
            Switch to Documents
            Wait For Elements State    ${processingStageInLeftMenu}    detached    timeout=${element_timeout}
        END
    ELSE
       Log    Reactive button is hidden
    END
    Save Submission
    Run Keyword And Continue On Failure    Verify Save Submission Popup
    Click Continue Button
    Wait For Elements State    ${ContinueButtonInSave}    hidden
    Sleep    5s
    ${saveSubmissionStatus}    Run Keyword And Return Status    Wait For Elements State    ${SaveSubmission}    visible    timeout=20s
    IF    ${saveSubmissionStatus}
         Save Submission
        Verify Save Submission Popup
        Click Continue Button
        Wait For Elements State    ${ContinueButtonInSave}    hidden
    END


   
Verify Submission updated
    [Documentation]    Verifies that the submission has been successfully updated after saving.
    ...    It checks for the disappearance of processing indicators and the appearance of an 'Updated' message.
    Click Answers Tab
    Switch to Documents
    ${status}    Run Keyword And Return Status    Wait For Elements State    ${processingStage1}    hidden    timeout=${element_timeout}
    IF    ${status}
        Log    'Processing Stage 1 is hidden'
    ELSE
        Click Answers Tab
        Click   ${Side_Bar_Risk360_Button}
        Wait For Elements State    ${processingStage1}    hidden    timeout=${upload_procesing_timeout}
    END
    Switch to Documents
    Click    ${Side_Bar_Risk360_Button}
    ${updateSubmissionStatus}    Run Keyword And Return Status    Get Element States    ${UpdatedSubmission}    validate    value & visible    'UpdatedSubmission should be visible.'
    IF    ${updateSubmissionStatus}
        Log    Submission Updated is displayed
    ELSE
        Switch to Documents
        Click    ${Side_Bar_Risk360_Button}
        Wait For Elements State    ${UpdatedSubmission}    visible    timeout=${element_timeout}
    END

Verify WorkFlow Options Advance Stage and Reject
    [Documentation]    Verifies that the 'Advance Stage' and 'Reject' buttons are visible in the workflow options.
    Get Element States    ${Workflow_Advance_Stage}    validate    value & visible    'Workflow_Advance_Stage should be visible.'
    Get Element States    ${Workflow_Reject}    validate    value & visible    'Workflow_Reject should be visible.'
    
Advance Stage 2
    [Documentation]    Clicks the 'Advance Stage' button and waits for the submission to move to the next stage.
    Wait For Elements State    ${Workflow_Advance_Stage}    visible    
    Click    ${Workflow_Advance_Stage}
    Wait For Elements State    ${processingStage2}    visible    timeout=30s
    ${status}    Run Keyword And Return Status    Wait For Elements State    ${processingStage2}    hidden    timeout=100s
    IF    ${status}
        Log Step    Processing Stage 2 hidden
    ELSE
        Click    ${Side_Bar_Risk360_Button}
        Switch to Documents
        ${checkEditSubmission}    Run Keyword And Return Status    Wait For Elements State    ${EditSubmission}    visible    timeout=${element_timeout}
        IF    ${checkEditSubmission} 
            Log    Processing Stage 2 hidden
        ELSE
        Wait For Elements State    ${processingStage2}    hidden    timeout=120s
        END
    END 
Verify WorkFlow History is Empty For Draft stage
    [Documentation]    Verifies that the workflow history is empty when the submission is in the 'Draft' stage.
    Switch to Documents
    Click    ${WorkFLow_History}
    Wait For Elements State    ${WorkFlow_History_Empty}    visible
    # Get Element States    ${WorkFlow_History_Empty}    validate    value & visible

Reject Submission and Verify the Tag name
    [Documentation]    Rejects a submission, fills out the rejection reason, and verifies the submission tag changes accordingly.
    ...
    ...    *Arguments:*
    ...    - `${FailureReasons}`: A list of reasons for the rejection.
    ...    - `${data_details}`: A text description of the rejection details.
    ...    - `${action}`: Either 'Cancel' to cancel the rejection or any other value to proceed.
    [Arguments]    ${FailureReasons}    ${data_details}    ${action}
    Click    ${Workflow_Reject}
    Wait For Elements State    ${UpdateWorkflowStage}    visible
    Get Element States    ${SelectReason}    validate    value & visible    'SelectReason should be visible.'
    FOR     ${failureReason}    IN    @{FailureReasons}
    ${reason}    Catenate    SEPARATOR=    ${ReasonForReject1}    ${failureReason}    ${ReasonForReject2}
    Check Checkbox    ${reason}
    END
    Type Text    ${Details}    ${data_details}
    IF    '${action}' == 'Cancel'
        Get Element States    ${SelectReason}    validate    value & enabled    'SelectReason should be enabled.'
        Click    ${CancelButtonInReject}
        Verify WorkFlow Options Advance Stage and Reject
        Get Element States    ${InDraftTag}    validate    value & visible    'InDraftTag should be visible.'
    ELSE
         Get Element States    ${AcceptButton}    validate    value & enabled    'AcceptButton should be enabled.'
         Click    ${AcceptButton}
         Get Element States    ${Reactive}    validate    value & visible    'Reactive should be visible.'
         Get Element States    ${RejectedTag}    validate    value & visible    'RejectedTag should be visible.'
    END

Verify WorkFlow History for Rejection
    [Documentation]    Verifies that the workflow history correctly logs the details of a rejection.
    ...
    ...    *Arguments:*
    ...    - `${expectedList}`: A list of expected values to find in the history log (e.g., user, stage, details). The current date is prepended automatically.
    [Arguments]    ${expectedList}
    ${date}    Get Formatted Current Date
    Insert Into List    ${expectedList}    0    ${date}
    Switch to Documents
    Click    ${WorkFLow_History}
    ${tableData}    Get Elements    //td[not(ul)]
    @{actualText}    Create List  
    FOR    ${data}    IN    @{tableData}
        ${text}    Get Text    ${data}
        ${trimValue}    Strip String    ${text}
        Append To List    ${actualText}    ${trimValue}
    END
    ${length}    Get Length    ${expectedList}
    Log       ${length}
    FOR     ${index}    IN RANGE    0    ${length} - 1
        ${expectedTextValue}=     Set Variable    ${expectedList[${index}]}
        ${actualTextValue}=    Set Variable    ${actualText[${index}]}
        IF    ${index} == 0
            Should Contain    ${actualTextValue}    ${expectedTextValue}    
        ELSE
            Should Be Equal    ${expectedTextValue}    ${actualTextValue}
        END
    END
    ${rejectionReasons}    Get Elements    //tbody[@test-id='assets-workflow-history']//tr[1]//td//li
    @{actualReasons}    Create List    
    FOR    ${reason}    IN    @{rejectionReasons}
        ${reasonText}    Get Text    ${reason}
        ${trimText}    Strip String    ${reasonText}
        Append To List    ${actualReasons}    ${reasonText}
    END
    Log    'Actual Text -> @{actualText}'

Reactive the Rejected Submission
    [Documentation]    Activates a submission that was previously rejected.
    ...    It handles clicking the 'Reactive' button and any confirmation dialogs, waiting for the submission to leave the rejected state.
    Sleep    3s
    ${status}    Run Keyword And Return Status    Wait For Elements State    ${processingStageInLeftMenu}    visible    timeout=5s
    ${rejectStatus}    Run Keyword And Return Status    Wait For Elements State    ${RejectProcessing}    visible    timeout=5s
    IF    ${status} == True or ${rejectStatus} == True
        Log    'Processing Stage is visible'
        Wait For Processing Stage    ""
    END
    Click    ${Reactive}
    Wait For Elements State    ${ReactivatePopup}    visible    timeout=30s
    ${acceptButton}    Run Keyword and Return Status    Wait For Elements State    ${AcceptButtonInReactive}    visible    timeout=${element_timeout}
    IF    ${acceptButton}
        Click    ${AcceptButtonInReactive}
    ELSE
        Click    ${Reactive}
        Click    ${AcceptButtonInReactive}
    END
    Click    ${Side_Bar_Risk360_Button}
    Switch to Documents
    Sleep    3s
    ${reactiveButtonStatus}    Run Keyword And Return Status    Wait For Elements State    ${Reactive}    visible    timeout=10s
    IF    ${reactiveButtonStatus}
        Switch to Documents
        Click    ${Side_Bar_Risk360_Button}
        Click    ${Reactive}
        Click    ${AcceptButtonInReactive}
        Wait For Elements State    ${Reactive}    detached    timeout=${element_timeout}
    ELSE
       Log    Reactive button is hidden
    END
    Click Answers Tab
    # Wait For Elements State    ${InDraftTag}    visible    timeout=300s
    ${status1}    Run Keyword And Return Status    Wait For Elements State    ${processingStage1}    visible    timeout=10s
    IF    ${status1}
        Wait For Elements State    ${processingStage1}    hidden    timeout=${upload_procesing_timeout}
    ELSE
        ${status2}        Run Keyword And Return Status    Wait For Elements State    ${processingStage2}    visible    timeout=10s
        IF    ${status2}
            Wait For Elements State    ${processingStage2}    hidden    timeout=${upload_procesing_timeout}
        END
    END
    Wait For Processing Stage
    Switch to Documents

Create new submission with SOV and Loss run
    [Documentation]    Creates a new submission by uploading multiple files, specifically an SOV and a Loss Run.
    ...
    ...    *Arguments:*
    ...    - `${FileName}`: A list of file names to upload from the `uploads` directory.
    ...    - `@{submission_column_names}`: A list of column names to configure on the submissions page.
    ...
    ...    *Returns:*
    ...    - The ID of the newly created submission.
    [Arguments]    ${FileName}    @{submission_column_names}
        Select Date Filter option    Today
        Click All submissions option
        Rearrange Submission Page Columns    @{submission_column_names}
        Log Step    'Creating New Submission!'
        Wait For Elements State    ${NewButton}    visible
        Click    ${NewButton}
        Sleep    3s
        ${status}    Run Keyword And Return Status    Get Element States    ${SelectPage}    validate    value & visible    'SelectPage should be visible.'
        IF    ${status}  
        Select Options By    ${SelectPage}    text    100
        END
        Sleep    2s
        # ${existingSubmissionCount1}    Get Element Count    ${ProcessingStatusCount}
        # Log    ${existingSubmissionCount1}
        Wait For Elements State    ${CreateSubmissionTab}    visible
        Click    ${UploadSupportingDocuments}
        Wait For Elements State    ${BrowseFile}    visible
        FOR    ${file}    IN    @{FileName}
            ${AbsolutePath}=    Normalize Path    ${path}${file}
            Upload File By Selector    ${UploadFile}    ${AbsolutePath}
        END
        Sleep    2s
        Scroll To Element    ${CreateSubmissionButton}
        Wait For Elements State    ${CreateSubmissionButton}    enabled
        Click    ${CreateSubmissionButton}
        Sleep    5s
        Wait For Elements State    ${Processing}    visible    timeout=60s
        #  Click My submissions option
        # Sleep    2s
        # Click All submissions option
        # Wait For Elements State    ${ProcessingStatus}    visible
        #  ${existingSubmissionCount2}    Get Element Count    ${ProcessingStatusCount}
        # Log    ${existingSubmissionCount2}
        # IF    ${existingSubmissionCount2} == ${existingSubmissionCount1}
        #    ${index}    Evaluate    ${existingSubmissionCount2} + 1
        #    ${locator}    Catenate    SEPARATOR=    ${ExistingProcessingStatus}    ${index}    ]  
        #     Wait For Elements State    ${locator}    visible
        # END
        Wait For Elements State    ${ProcessingStatus}    visible    timeout=120s    
        ${retrive_submission_id}    Get Text    ${Locator_SubmissionId}
        ${get_submission_id}    Strip String    ${retrive_submission_id}
        Wait For Elements State    ${ProcessingStatus}    detached    timeout=${upload_procesing_timeout}
        # Wait For Elements State    ${CloseSubmissionPreview}    visible    timeout=60s
        # Click    ${CloseSubmissionPreview}
        Log Step    'New Submission ID -> ${get_submission_id}'
        RETURN    ${get_submission_id}

Open uploaded SOV File
    [Documentation]    Navigates to the 'Documents' section and opens the uploaded SOV file for viewing.
     Switch to Documents
     Wait For Elements State    ${Files}    visible
     Get Element States    ${SOV}    validate    value & visible    'SOV should be visible.'
     Click    ${SOV}
     Wait For Elements State    ${FileOption}    visible
     Click    ${FileOption}

Verify datas are matching for the uploaded SOV file
    [Documentation]    Compares the data visible in the SOV file viewer with the contents of the original Excel file.
    ...
    ...    *Arguments:*
    ...    - `${file}`: The name of the Excel file in the `uploads` directory to compare against.
    [Arguments]    ${file}
    ${AbsolutePath}=    Normalize Path    ${path}${file}
     Set Viewport Size    1920    1080
     Wait For Elements State    xpath=//iframe[@class='spreadsheet-viewer-iframe']    visible
     ${tableValues}    Get Elements    xpath=//iframe[@class='spreadsheet-viewer-iframe'] >>> xpath=//tr//td//div[normalize-space() and contains(@class,'value')]
     ${actualText}    Create List
     FOR    ${value}    IN    @{tableValues}
         ${getText}    Get Text    ${value}
         ${trimText}    Strip String    ${getText}
         Append To List    ${actualText}    ${trimText}
     END
     Log    ${actualText}
     Set Viewport Size    1280    720
     Compare Excel With Ui List    ${AbsolutePath}    ${actualText}
     
Verify Loss run file is pending for stage 2
    [Documentation]    Verifies that the uploaded Loss Run file is marked as 'Pending Stage 2'.
    Switch To Documents
    Scroll To Element    ${LossRunFile}
    Get Element States    ${LossRunFile}    validate    enabled    'LossRunFile should be enabled.'
    Get Element States    ${PendingStage2}    validate    value & visible    'PendingStage2 should be visible.'

Verify Properties datas matching for applied columns given in the uploaded SOV file
    [Documentation]    Verifies that the data in the 'Properties' table (from the SOV) matches expected values for a given set of selected columns.
    ...    It includes complex formulas in the documentation to explain how totals are calculated, which is critical for maintaining tests.
    ...
    ...    *Arguments:*
    ...    - `${options}`: A list of column names to select from the column dropdown.
    ...    - `${expectedValues}`: A list of expected numerical values from the visible table data.
    [Arguments]    ${options}    ${expectedValues}
    Click    ${SOV_Properties}
    Wait For Elements State    ${PropertiesTable}    visible
    Click    ${Column_Dropdown}
    FOR    ${option}    IN    @{options}
        ${option}    Catenate    SEPARATOR=    ${SelectOption1}    ${option}    ${SelectOption2}
        Scroll To Element    ${option}
        Check Checkbox    ${option}
    END
    Click    ${Column_Dropdown}
    ${rows}    Get Elements    ${Properties_Row}
    ${length}    Get Length    ${rows}
    ${index}    Set Variable    0
    ${actualListOfValues}    Create List   
    FOR    ${i}    IN RANGE     ${index}      ${length}
        ${tableData}    Catenate    SEPARATOR=    ${Properties_Data1}    ${i+1}    ${Properties_Data2}
        ${listOfData}    Get Elements    ${tableData} 
        FOR    ${data}    IN    @{listOfData}
            ${text}    Get Text    ${data}
            ${trimValue}    Strip String    ${text}
            IF    "${trimValue}" != ""
                ${has_dollar}=    Run Keyword And Return Status    Should Contain    ${trimValue}    $
                Should Be True    ${has_dollar}
                ${actualtrimValue}=    Replace String    ${trimValue}    $    ${EMPTY}
                ${actualtrimValue}=    Replace String    ${actualtrimValue}    ,    ${EMPTY}
                ${clean}    Strip String    ${actualtrimValue}
                ${value}    Convert To Number    ${clean}
                Append To List    ${actualListOfValues}    ${value}
            END
        END
    END
    Log    ${actualListOfValues}
    Lists Should Be Equal    ${expectedValues}    ${actualListOfValues}
    Click    ${Column_Dropdown}
    Wait For Elements State    ${ClearAll}    visible
    Click    ${ClearAll}

Verify Properties datas for the given dropdown options
    [Documentation]    A data-driven keyword that iterates through multiple sets of dropdown options and expected values to verify the 'Properties' table.
    ...    It calls `Verify Properties datas matching for applied columns given in the uploaded SOV file` repeatedly.
    ...
    ...    *Arguments:*
    ...    - `${length}`: The number of option/value sets to test. This is used to loop through a dictionary defined in a variable file.
    [Arguments]    ${length}
    FOR    ${index}    IN RANGE    0    ${length}
        ${dropdownOptions}    Get From List    ${TC_E2E_003['dropdownOptions']}    ${index}
        ${values}    Get From List    ${TC_E2E_003['values']}    ${index}
        Verify Properties datas matching for applied columns given in the uploaded SOV file    ${TC_E2E_003['${dropdownOptions}']}      ${TC_E2E_003['${values}']}
   END

Verify Sanction Screening Flagged is visible in the submission
    [Documentation]    Verifies that the 'Sanction Screening Flagged' indicator is visible on the submission.
    Get Element States    ${SanctionScreeningFlagged}    validate    value & visible    'SanctionScreeningFlagged should be visible.'

Verify Task Number in the submission
    [Documentation]    Verifies that the task number displayed on the submission matches the expected number.
    ...
    ...    *Arguments:*
    ...    - `${expected_taskNumber}`: The expected task number.
    [Arguments]    ${expected_taskNumber}
    Wait For Elements State    ${TaskNumber}    visible
    ${get_taskNumber}    Get Text    ${TaskNumber}
    ${actual_taskNumber}    Strip String    ${get_taskNumber}
    Should Be Equal    ${actual_taskNumber}    ${expected_taskNumber}

Verify and click the Task In Submission
    [Documentation]    Verifies the task link is visible within the submission and then clicks it to open the task details.
    Get Element States    ${TaskInSubmission}    validate    value & visible    'TaskInSubmission should be visible.'
    Click    ${TaskInSubmission}

Verify the auto generated task details
    [Documentation]    Verifies the details of the automatically generated Sanction Screening task.
    ...
    ...    *Arguments:*
    ...    - `${expected_taskDetails}`: A list of expected string values for the task details. The current date is appended for comparison.
    [Arguments]    ${expected_taskDetails}
    ${CreatedDate}    Get Formatted Current Date
    Append To List    ${expected_taskDetails}    ${CreatedDate}
    ${actual_taskDetails}    Create List
    FOR    ${taskDetail}    IN    @{SanctionScreeningTaskDetails}
        ${text}    Get Text    ${SanctionScreeningTaskDetails['${taskDetail}']}
        ${trimText}    Strip String    ${text}
        Append To List    ${actual_taskDetails}    ${trimText}
    END
    ${length}    Get Length    ${expected_taskDetails}
    FOR    ${index}    IN RANGE    0    ${length}
        ${expectedTextValue}=     Set Variable    ${expected_taskDetails[${index}]}
        ${actualTextValue}=    Set Variable    ${actual_taskDetails[${index}]}
        IF    ${index} == ${length-1}
            Should Contain    ${actualTextValue}    ${expectedTextValue}    
        ELSE
            Should Be Equal    ${expectedTextValue}    ${actualTextValue}
        END
    END
   
Complete Task with the given reason
    [Documentation]    Completes the open task with a specified reason.
    ...
    ...    *Arguments:*
    ...    - `${reason}`: The reason for completing the task (e.g., 'False Positive'). This must match one of the checkbox labels in the completion dialog.
    [Arguments]    ${reason}
    Wait For Elements State    ${CompleteTaskButton}    visible
    Click    ${CompleteTaskButton}
    Wait For Elements State    ${TaskCompleteDialog}    visible
    ${reason}    Catenate    SEPARATOR=    ${SanctionScreeningSelectReason}    ${reason}']
    Check Checkbox    ${reason}
    Get Element States    ${reason}    validate    value & enabled    'Reason should be enabled.'
    Click    ${CompleteTaskButtonInDialog}
    Wait For Elements State    ${TaskCompleteDialog}    detached

Verify the task is completed and sanction label is appears as per the reason
    [Documentation]    Verifies that the task shows as completed and that the correct sanction label ('False Positive', 'Sanction Screening Flagged', or 'Sanction Screening Clear') is displayed based on the completion reason.
    ...
    ...    *Arguments:*
    ...    - `${reason}`: The reason the task was completed with, used to determine which label should be visible.
    [Arguments]    ${reason}
    Scroll To Element    ${TaskCompletedMessage}
    Wait For Elements State    ${TaskCompletedMessage}    visible
     ${CompletedReason}    Catenate    SEPARATOR=    ${TaskCompletedReason}    ${reason}']
    Get Element States    ${CompletedReason}    validate    value & visible    'CompletedReason should be visible.'
    IF    '${reason}' == 'False Positive'
        Get Element States    ${FalsePositiveLabel}    validate    value & visible    'FalsePositiveLabel should be visible.'
    ELSE IF    '${reason}' == 'Confirmed – TRUE HIT'
        Get Element States    ${SanctionScreeningFlagged}    validate    value & visible    'SanctionScreeningFlagged should be visible.'
    ELSE
        Get Element States    ${SanctionScreeningClear}    validate    value & visible    'SanctionScreeningClear should be visible.'
    END

Verify Sanction Screening Flagged is not visible 
    [Documentation]    Verifies that the 'Sanction Screening Flagged' indicator is *not* visible on the submission.
    Sleep    2s
    ${is_hidden}    Run Keyword And Return Status  Get Element States    ${SanctionScreeningFlagged}    validate    hidden
    Should Be True    ${is_hidden}    Sanction Screening Flagged should be hidden

Navigate To All Submissions page from submissions
    [Documentation]    Navigates to the main 'All Submissions' page from within a submission.
    ${visible}    Run Keyword And Return Status    Wait For Elements State    ${Home}    visible    timeout=5s
    IF    ${visible}
        Click    ${Home}
        Sleep    3s
        Wait For Elements State    ${SearchSubmissionButton}    visible
        Click All submissions option
    END

Verify Stage is updated in the submission
    [Documentation]    Verifies that the stage of the submission is updated correctly.
    ...    It checks for the visibility of the stage indicator and compares it with the expected stage.
    ...
    ...    *Arguments:*
    ...    - `${expected_stage}`: The expected stage of the submission.
    [Arguments]    ${expected_stage}
    ${status}    Run Keyword And Return Status    Wait For Elements State    ${EditSubmission}    visible    timeout=10s
    IF    ${status}
        Switch to Documents
        Click    ${Side_Bar_Risk360_Button}
    END
    ${stage}    Catenate    SEPARATOR=    ${StageLocator1}    ${expected_stage}    ${StageLocator2} 
    ${status}    Run Keyword And Return Status    Get Element States    ${stage}    validate    value & visible    
    Should Be True    ${status}

Verify Submission updated in Stage 2
    [Documentation]    Verifies that a submission has been updated after advancing to Stage 2.
    ...    It checks for the disappearance of processing indicators and the appearance of an 'Updated' message.
    Click Answers Tab
    Switch to Documents
    ${status}    Run Keyword And Return Status    Wait For Elements State    ${processingStage2}    hidden    timeout=${element_timeout}
    IF    ${status}
        Log    'Processing Stage 2 is hidden'
    ELSE
        Click Answers Tab
        Click   ${Side_Bar_Risk360_Button}
       Wait Until Element Is Hidden With Polling    ${processingStage2}
    END
    Switch to Documents
    Click    ${Side_Bar_Risk360_Button}
     ${status}    Run Keyword And Return Status    Wait For Elements State    ${processingStage2}    visible
    IF    ${status}
        Wait Until Element Is Hidden With Polling    ${processingStage2}
        Log    'Processing Stage 2 is hidden'
        Get Element States    ${UpdatedSubmission}    validate    value & visible    'UpdatedSubmission should be visible.'
    ELSE
    Sleep    2s
        Get Element States    ${UpdatedSubmission}    validate    value & visible    'UpdatedSubmission should be visible.'
    END

Verify Submission updated in the Current Stage
    [Documentation]    Verifies that a submission has been updated after advancing to Stage 2.
    ...    It checks for the disappearance of processing indicators and the appearance of an 'Updated' message.
    [Arguments]    ${stageNo}
    Click Answers Tab
    Switch to Documents
    ${stage}    Catenate    SEPARATOR=    ${processingStage}    ${stageNo}    ')]
    ${status}    Run Keyword And Return Status    Wait For Elements State    ${stage}    hidden    timeout=${element_timeout}
    IF    ${status}
        Log    'Processing Stage ${stageNo} is hidden'
    ELSE
        Click Answers Tab
        Click   ${Side_Bar_Risk360_Button}
        Wait For Elements State    ${stage}    hidden    timeout=${upload_procesing_timeout}
    END
    Switch to Documents
    Click    ${Side_Bar_Risk360_Button}
     ${status1}    Run Keyword And Return Status    Wait For Elements State    ${stage}    visible    timeout=10s    
    IF    ${status1}
        Log    'Processing Stage ${stageNo} is hidden'
        Wait For Elements State    ${stage}    hidden    timeout=${upload_procesing_timeout}
    END
    

Advance Stage
    [Documentation]    Clicks the 'Advance Stage' button and waits for the submission to move to the next stage.
    [Arguments]    ${stageNo}
    ${saveSubmissionStatus}    Run Keyword And Return Status    Wait For Elements State    ${SaveSubmission}    visible    timeout=20s
    IF    ${saveSubmissionStatus}
        Run Keyword And Continue On Failure    Save Submission And verify popup
    END
    Wait For Elements State    ${Workflow_Advance_Stage}    visible    
    Click    ${Workflow_Advance_Stage}
    ${stage}    Catenate    SEPARATOR=    ${processingStage}    ${stageNo}    ')]
    Wait For Elements State    ${stage}    visible    timeout=${element_timeout}
    ${status}    Run Keyword And Return Status    Wait For Elements State    ${stage}    hidden    timeout=${processing_stage_timeout}
    IF    ${status}
        Log Step    Processing Stage ${stageNo} hidden
    ELSE
        Click    ${Side_Bar_Risk360_Button}
        Switch to Documents
        ${checkEditSubmission}    Run Keyword And Return Status    Wait For Elements State    ${EditSubmission}    visible    timeout=${element_timeout}
        IF    ${checkEditSubmission} 
            Log    Processing Stage ${stageNo} hidden
        ELSE
        Wait For Elements State   ${stage}   hidden    timeout=120s
        END
    END 

Save And Close for Child Submission
     [Documentation]    Verifies the 'Finish' tab is correctly displayed and then clicks the 'Save and Close' button.
    Wait For Elements State    ${All_Done}    visible   
    Get Element States    ${Please_Review_Msg}    validate    value & visible    'Please_Review_Msg should be visible.'
    Get Element States    ${SaveAndClose}    validate    value & visible    'SaveAndClose should be visible.'
    Click    ${SaveAndClose}

Create Child Submission  
    [Arguments]    ${product}
    Click Coverage Tab   
    Wait For Elements State    ${CoverageProductButton}    visible
    Click    ${CoverageProductButton} 
    Wait For Elements State    ${AddValueButton}    visible
    Click    ${AddValueButton} 
    Wait For Elements State    ${CoverageProductDropdown}    visible
    Click    ${CoverageProductDropdown}
    ${value}    Catenate    SEPARATOR=    ${CoverageProductSelect}    ${product}    '])[2]
    Wait For Elements State    ${value}    visible
    Click    ${value}
    Get Element States    ${CoverageUserMod}    validate    value & visible    
    Click Finish Tab
    Save And Close for Child Submission

Wait For Processing Stage
    [Arguments]    ${stageNo}=''
    IF    ${stageNo} == ''
        ${stage}=    Catenate    SEPARATOR=    ${processingStage}    ')]
    ELSE
        ${stage}=    Catenate    SEPARATOR=    ${processingStage}    ${stageNo}    ')]
    END
    ${status}    Run Keyword And Return Status    Wait For Elements State    ${stage}    visible    timeout=10s
    ${rejectStatus}    Run Keyword And Return Status    Wait For Elements State    ${RejectProcessing}    visible    timeout=10s
    IF    ${status}
        Wait For Elements State    ${stage}    hidden    timeout=${upload_procesing_timeout}
    ELSE IF    ${rejectStatus}
          Wait For Elements State    ${RejectProcessing}    hidden    timeout=${upload_procesing_timeout}      
    END

Verify Summary Menu is displayed
    Wait For Elements State    ${SummaryTab}    visible 
    Scroll To Element    ${SummaryTab}

Switch To Summary Tab
    [Arguments]    ${expectedHeader}
    Scroll To Element    ${SummaryTab}
    Wait For Elements State    ${SummaryTab}    visible
    Click    ${SummaryTab}
    ${actualHeader}    Get Text    ${SummaryHeader}
    Run Keyword And Continue On Failure    Should Be Equal    ${actualHeader}    ${expectedHeader}

Verify Premium Amount 
    Wait For Elements State    ${PremiumAmount}    visible
    # ${actualAmount}    Get Text    ${PremiumAmount}
    # ${premiumValue}    Convert To Number    ${actualAmount}
    # Should Be True    ${premiumValue} >= 0
    

Verify Policy Information In Summary Tab
    [Arguments]    ${data}
    ${PolicyTexts}    Get Elements    ${FieldsInPolicyInfromation}
    ${actualPolicyFields}    Create List
    FOR    ${fields}    IN    @{PolicyTexts}
        ${text}    Get Text    ${fields}
        ${trimText}    Strip String    ${text}
        Append To List    ${actualPolicyFields}    ${trimText}
    END
    Lists Should Be Equal    ${data['PolicyFields']}    ${actualPolicyFields}
    Click    ${permium_Btn_Loc}
    Wait For Elements State    ${premium_field_loc}    visible    5s
    Fill Text    ${premium_field_loc}    ${data['premiumAmount']}
    #verify Attachment point
    Get Element States    ${AttachmentPoint}    validate    value & visible
    Click    ${AttachmentPoint}
    Wait For Elements State    ${AttachmentPointInput}    visible
    Fill Text    ${AttachmentPointInput}    ${data['AttachmentPoint']}
    #policy number
    ${checkPolicyNumber}    Get Text    ${PolicyNumberInInfo}
    ${isPolicyEmpty}    Run Keyword And Return Status    Should Be Equal    ${checkPolicyNumber}     Edit
    IF    ${isPolicyEmpty}
        Click    ${PolicyNumberInInfo}
        Wait For Elements State    ${PolicyNumberInput}    visible
        Fill Text    ${PolicyNumberInput}    ${data['PolicyNumber']}
    END
    #Class of business
    Get Element States    ${ClassOfBuisness}    validate    value & visible
    Click    ${ClassOfBuisness}
    ${ClassOfBusinessdropdownValue}    Catenate    SEPARATOR=    ${ClassOfBuisnessDropdown}    ${data['ClassOfBusiness']}']
    Get Element States    ${ClassOfBusinessdropdownValue}    validate    value & visible
    Click    ${ClassOfBusinessdropdownValue}
    #placement type
    Get Element States    ${PlacementType}    validate    value & visible
    Click    ${PlacementType}
    ${PlacementTypedropdownValue}    Catenate    SEPARATOR=    ${PlacementTypeOption}    ${data['PlacementType']}']
    Get Element States    ${PlacementTypedropdownValue}    validate    value & visible
    Click    ${PlacementTypedropdownValue}
    #verify mailed date is not displayed
    ${date}    Get Text    ${MailedDate}
    Should Be Equal    ${data['MailedDate']}    ${date}

Verify Policy Information Fields In Summary Tab
    [Arguments]    ${expected_data}
    ${PolicyTexts}    Get Elements    ${FieldsInPolicyInfromation}
    ${actualPolicyFields}    Create List
    FOR    ${fields}    IN    @{PolicyTexts}
        ${text}    Get Text    ${fields}
        ${trimText}    Strip String    ${text}
        Append To List    ${actualPolicyFields}    ${trimText}
    END
    Run Keyword And Continue On Failure     Lists Should Be Equal    ${expected_data}    ${actualPolicyFields}

Verify Summary Table Data
    [Arguments]    ${expectedTableHeader}    ${expectedTableData}
    @{actualTableHeader}    Create List
    @{actualTableData}    Create List
    Wait For Elements State    ${AccountHistoryTable}
    @{header}    Get Elements    ${AccountHistoryTableHeader}
    @{tableData}    Get Elements    ${AccountHistory} 
    FOR    ${element}    IN    @{header}
        ${text}    Get Text    ${element}
        ${trimText}    Strip String    ${text}
        Append To List    ${actualTableHeader}    ${trimText}    
    END  
    FOR    ${data}    IN    @{tableData}
        ${text}    Get Text    ${data}
        ${trimText}    Strip String    ${text}
        Append To List    ${actualTableData}    ${trimText}    
    END    
    Lists Should Be Equal    ${expectedTableHeader}    ${actualTableHeader}
    Log    ${actualTableData}
    FOR    ${data1}    IN    @{actualTableData}
    List Should Contain Value    ${expectedTableData}    ${data1}
    END

Get New Submission ID After Child Submission
    Wait For Elements State    ${NewSubmissionID}    visible
    ${text}    Get Text    ${NewSubmissionID}
    ${trimText}    Strip String    ${text}
    ${new_id}    Convert To Lower Case    ${trimText}
    RETURN    ${new_id}

Wait Until Element Is Hidden With Polling
    [Documentation]    Waits until the given element is hidden, polling every 60 seconds up to 600 seconds.
    ...    This keyword checks the element's state every 60 seconds (polling) instead of waiting the full timeout at once.
    ...    *Arguments:*
    ...    - `${element}`: The locator of the element to check for hidden state.
    [Arguments]    ${element}
    ${max_wait}    Set Variable    600
    ${interval}    Set Variable    60
    ${elapsed}     Set Variable    0
    ${is_hidden}   Set Variable    False
    FOR    ${i}    IN RANGE    0    ${max_wait}    ${interval}
        ${is_hidden}    Run Keyword And Return Status    Wait For Elements State    ${element}    hidden    timeout=${interval}s
        IF    ${is_hidden}
            Log    Element is hidden after ${elapsed} seconds
            Exit For Loop
        ELSE
            Log    Element still visible after ${elapsed} seconds, polling again...
            ${elapsed}    Evaluate    ${elapsed} + ${interval}
             Click Answers Tab
             Click   ${Side_Bar_Risk360_Button}
             Switch to Documents
        END
    END
    Should Be True    ${is_hidden}    Element was not hidden after ${max_wait} seconds

Add Lob in the Clearnce Tab for Product Type
    [Arguments]    ${product}
    Click Coverage Tab   
    Wait For Elements State    ${CoverageProductButton}    visible
    Click    ${CoverageProductButton} 
    Wait For Elements State    ${AddValueButton}    visible
    Click    ${AddValueButton} 
    Wait For Elements State    ${CoverageProductDropdown}    visible
    Click    ${CoverageProductDropdown}
    ${value}    Catenate    SEPARATOR=    ${CoverageProductSelect}    ${product}    '])[2]
    Wait For Elements State    ${value}    visible
    Click    ${value}
    Get Element States    ${CoverageUserMod}    validate    value & visible    
    Hover    ${NewLob}
    Wait For Elements State    ${RemoveLob}    visible
    Click    ${RemoveLob}

Add LOB if not present
    [Arguments]    ${product}    ${Expected_Product}    
    ${Actual_Product_Text}    Create List 
    Click Coverage Tab 
    ${status}    Run Keyword And Return Status    Wait For Elements State    ${EmptyProductType}    visible
    IF    ${status}
        Click    ${EmptyProductType}
        Click    ${ProductDropdown1}
          ${Product_DropDownElements}    Get Elements    ${Product_DropDownElement}
    FOR    ${element}    IN    @{Product_DropDownElements}
        ${Product_Text}    Get Text    ${element}
        ${Product_Text}    Strip String    ${Product_Text}
        Append To List    ${Actual_Product_Text}    ${Product_Text}     
    END
        Log    ${Actual_Product_Text}
        Log    ${Expected_Product}
        Run Keyword And Continue On Failure    Lists Should Be Equal    ${Expected_Product}    ${Actual_Product_Text}        

        ${value}    Catenate    SEPARATOR=    ${CoverageProductSelect}    ${product}    '])[1]
        Wait For Elements State    ${value}    visible
        Click    ${value}
    END

Not Taken and Verify the Tag name
    [Documentation]    Rejects a submission, fills out the rejection reason, and verifies the submission tag changes accordingly.
    ...
    ...    *Arguments:*
    ...    - `${NotTakenReasons}`: A list of reasons for the rejection.
    ...    - `${data_details}`: A text description of the rejection details.
    ...    - `${action}`: Either 'Cancel' to cancel the rejection or any other value to proceed.
    [Arguments]    ${NotTakenReasons}    ${data_details}    ${action}
    Click    ${WorkFLow_NotTaken}
    Wait For Elements State    ${UpdateWorkflowStage}    visible
    Get Element States    ${SelectReason}    validate    value & visible    'SelectReason should be visible.'
    FOR     ${NotTakenReason}    IN    @{NotTakenReasons}
    ${reason}    Catenate    SEPARATOR=    ${ReasonForReject1}    ${NotTakenReason}    ${ReasonForReject2}
    Check Checkbox    ${reason}
    END
    Type Text    ${Details}    ${data_details}
    IF    '${action}' == 'Cancel'
        Get Element States    ${SelectReason}    validate    value & enabled    'SelectReason should be enabled.'
        Click    ${CancelButtonInReject}
        Verify WorkFlow Options Advance Stage and Not Taken
        Get Element States    ${QuotedTag}    validate    value & visible    'QuotedTag should be visible.'
    ELSE
         Get Element States    ${AcceptButton}    validate    value & enabled    'AcceptButton should be enabled.'
         Click    ${AcceptButton}
         Wait For Processing Stage
         Get Element States    ${Reactive}    validate    value & visible    'Reactive should be visible.'
         Get Element States    ${NotTakenTag}    validate    value & visible    'RejectedTag should be visible.'
    END

Verify WorkFlow Options Advance Stage and Not Taken
    [Documentation]    Verifies that the 'Advance Stage' and 'Reject' buttons are visible in the workflow options.
    Get Element States    ${Workflow_Advance_Stage}    validate    value & visible    'Workflow_Advance_Stage should be visible.'
    Get Element States    ${WorkFLow_NotTaken}    validate    value & visible    'WorkFLow_NotTaken should be visible.'

Verify the Error popup when mandate fields left empty
    [Documentation]    Verifies the 'Finish' tab is correctly displayed and then clicks the 'Save and Close' button and handle the Error popup.
    [Arguments]    ${expected_field} 
    Click Finish Tab
    Get Element States    ${SaveAndClose}    validate    value & visible    'SaveAndClose should be visible.'
    Click    ${SaveAndClose}
    ${error_Message}    Run Keyword And Return Status    Get Element States    ${Error_Saving_popup}
    IF    ${error_Message} == True 
     ${actualmessage}    Get Text    ${Error_Saving_popup}                
     Should Be Equal    ${actualmessage}    Error saving user modifications    
    ${Elements1}    Get Elements    ${missing_required_field}
    ${ActualValues}    Create List    
    FOR    ${element}    IN    @{Elements1}
         ${actualmessage1}    Get Text    ${element}
     ${actual}    Strip String    ${actualmessage1}  
        Append To List    ${ActualValues}    ${actual}    
    END
    Lists Should Be Equal   ${ActualValues}    ${expected_field['expected_error_field1']}
    END
    Wait For Elements State    ${processingInSubmission}    visible    timeout=30s
    Click    ${processingInSubmission}
    Wait For Elements State    ${UnderwriterName}    visible    timeout=30s
    Click    ${UnderwriterName}
    Type Text    ${UnderwriterInput}    ${expected_field['UnderwriterName']}
    Click    ${UnderwriterEmail}
    Type Text    ${UnderwriterEmailInput}    ${expected_field['UnderwriterEmail']}
    Click Finish Tab
    Get Element States    ${SaveAndClose}    validate    value & visible    'SaveAndClose should be visible.'
    Click    ${SaveAndClose}
    ${error_Message}    Run Keyword And Return Status    Get Element States    ${Error_Saving_popup}
    IF    ${error_Message} == True 
     ${actualmessage}    Get Text    ${Error_Saving_popup}                
     Should Be Equal    ${actualmessage}    Error saving user modifications
    ${missing_required2}    Run Keyword And Return Status    Get Element States    ${Error_mess}
    ${actualmessage2}    Get Text    ${Error_mess}
     ${actual}    Strip String    ${actualmessage2}                
     Should Be Equal    ${actual}    ${expected_field['expected_error_field2']}
    END
    # Click Answers Tab
    # Click and verify Clearance tab

verify Clearance Tab  
    [Documentation]    verify the Clearance tab
    ...    ${Expected_Values}    expected Product Segment value And Product value in the Coverage tab
    [Arguments]    ${Expected_Values}
    Click and verify Clearance tab
    Click Coverage Tab
     ${Acutal_List}    Create List
    FOR    ${Exceptedelement}    IN    @{TC_E2E_023['CoverageHeader']}
    ${Locator}    Catenate    SEPARATOR=    ${Loc_Clearance_ProductName}    ${Exceptedelement}    ${Loc_Clearance_SegmentName}
    # Wait For Elements State    ${Locator}
    ${ActualProductName}    Get Text    ${Locator}
   Append To List    ${Acutal_List}    ${ActualProductName}
    END
    Run Keyword And Continue On Failure    Lists Should Be Equal    ${Acutal_List}    ${Expected_Values}

Verify Advance Stage is InActive
    [Documentation]    This Method is used Verify the 'Advance Stage' is Not Active
    Get Element States    ${Workflow_Advance_Stage}    validate    hidden

Create new submission in processing
    [Documentation]    Creates a new submission by uploading a specified file.
    ...    This keyword handles the full UI flow for creating a submission: setting filters, rearranging columns, clicking 'New', uploading the file, and waiting for processing to complete.
    ...
    ...    *Arguments:*
    ...    - `${file_name}`: The name of the file to upload from the `uploads` directory.
    ...    - `@{submission_column_names}`: A list of column names to configure on the submissions page.
    ...
    ...    *Returns:*
    ...    - The ID of the newly created submission.
    [Arguments]    ${file_name}    @{submission_column_names}
    ${AbsolutePath}=    Normalize Path    ${path}${file_name}
    Log    ${AbsolutePath}
        # Select Date Filter option    Today
        Click All submissions option
        Rearrange Submission Page Columns    @{submission_column_names}
        Log Step    'Creating New Submission!'
        Wait For Elements State    ${NewButton}    visible
        Click    ${NewButton}
        Sleep    3s
        ${status}    Run Keyword And Return Status    Get Element States    ${SelectPage}    validate    value & visible    'SelectPage should be visible.'
        IF    ${status}  
        Select Options By    ${SelectPage}    text    100
        END
        Sleep    2s
        # ${existingSubmissionCount1}    Get Element Count    ${ProcessingStatusCount}
        # Log    ${existingSubmissionCount1}
        Wait For Elements State    ${CreateSubmissionTab}    visible
        Click    ${UploadSupportingDocuments}
        Wait For Elements State    ${BrowseFile}    visible
        Upload File By Selector    ${UploadFile}    ${AbsolutePath}
        Sleep    2s
        Scroll To Element    ${CreateSubmissionButton}
        Wait For Elements State    ${CreateSubmissionButton}    enabled
        Click    ${CreateSubmissionButton}
        Sleep    5s
        Wait For Elements State    ${Processing}    visible 
        # Click My submissions option
        # Sleep    2s
        # Click All submissions option
        # Wait For Elements State    ${ProcessingStatus}    visible
        #  ${existingSubmissionCount2}    Get Element Count    ${ProcessingStatusCount}
        # Log    ${existingSubmissionCount2}
        # IF    ${existingSubmissionCount2} == ${existingSubmissionCount1}
        #    ${index}    Evaluate    ${existingSubmissionCount2} + 1
        #    ${locator}    Catenate    SEPARATOR=    ${ExistingProcessingStatus}    ${index}    ]  
        #     Wait For Elements State    ${locator}    visible
        # END
        Wait For Elements State    ${ProcessingStatus}    visible    timeout=120s    
        ${retrive_submission_id}    Get Text    ${Locator_SubmissionId}
        ${get_submission_id}    Strip String    ${retrive_submission_id}
        # Wait For Elements State    ${ProcessingStatus}    detached    timeout=600s
        # Wait For Elements State    ${CloseSubmissionPreview}    visible    timeout=60s
        # Click    ${CloseSubmissionPreview}
        Log Step    'New Submission ID -> ${get_submission_id}'
        RETURN    ${get_submission_id} 

Verify System displays task reassignment pop-up for completed tasks
    [Documentation]    This method is used Convr task tab

    [Arguments]    ${ColumnNames}    ${expected_text}    ${Assign_To}

    Click    ${Convr_Task_tab}
    Click All tasks option
    Rearrange Submission Page Columns    @{ColumnNames}
    Click    ${Convr_Status_Filter_Button}
    Click    ${Convr_Select_All_Option}
    Click    ${Convr_Completed_Option}
    Click    ${Convr_Status_Elements}
    Click    ${Convr_Status_Elements}    button=right
    ${result}    Get Text    ${Convr_Reassign}
    Should Be Equal    ${result}    ${expected_text}
    Click    ${Convr_Status_Filter_Button}
    Click    ${Convr_Select_All_Option}
    Click    ${Convr_Select_All_Option}
    Click    ${Convr_Created_Option}
    Click    ${Convr_Status_Elements}
    Click    ${Convr_Status_Elements}    button=right
    Click    ${Convr_Reassign}
    Wait For Elements State    ${Convr_Reassign_Input_Field}
    Fill Text    ${Convr_Reassign_Input_Field}    ${Assign_To}
    click    ${Convr_Reassign_Option}
    Get Element States    ${Convr_Reassign_Sucess_popup}    validate    value & visible 
    Wait For Elements State    ${Cancel_Filter_Button}    visible    5s
    click    ${Cancel_Filter_Button}
   
verify the Effective date in Convr Task Tab 
    [Documentation]    This method is used to verify the Effective Date In Convr Task Tab
    ...    ${Date}    we need to pass the Date in this format "dd/mm/yyy"
    ...    ${Date_1}    we need to pass the Date in this format "mm/dd/yyy"    
    [Arguments]    ${ColumnNames}    ${Date}    ${Date_1}
    Click    ${Convr_Task_tab}
    Click All tasks option
    Set_Page_Size    20
    Rearrange Submission Page Columns    @{ColumnNames}
    Click    ${Convr_EffDate_Filter_Button}
    type Text    ${Convr_Effdate_field}    ${Date}
    ${elements}    Get Elements    ${Convr_Effdate_Elements}
    FOR    ${element}    IN    @{elements}
        ${effective_Date}    Get Text    ${element}
        Should Be Equal    ${effective_Date}    ${Date_1}  
    END    
    Wait For Elements State    ${Convr_Submission_tab}    visible    5s
    click    ${Convr_Submission_tab}
    Wait For Elements State    ${Convr_Submission_tab}    visible    5s
   
Set_Page_Size 
    [Documentation]    This method is used to the Set the Page Size
    ...    ${Size}    we need to give the Size value 
    [Arguments]    ${Size}  
    Wait For Elements State    ${Convr_Page_Size}    visible    5s
    Click    ${Convr_Page_Size}
    ${element}    Catenate    SEPARATOR=    ${Convr_page_Option}    ${Size}'] 
    Click    ${element}



Verify datas in Underwriter Reference file
    [Documentation]    Verifies the contents of the 'UserModification' file in the 'Documents' section.
    ...    It compares a list of expected text values with the actual values found in the document.
    ...
    ...    *Arguments:*
    ...    - `${expectedText}`: A list of strings with the expected values.
    [Arguments]    ${expectedText}
    Switch to Documents
    Scroll To Element    ${underwriter_reference_Doc}
    Wait For Elements State    ${underwriter_reference_Doc}    visible    timeout=${element_timeout}
    Click    ${underwriter_reference_Doc}
    @{variables}    Get Elements    ${UserModificationVariable}
    @{values}    Get Elements    ${UserModificationValue}
    @{actualText}    Create List    
    FOR    ${value}    IN    @{values}
        ${text}    Get Text    ${value}
        ${trimValue}    Strip String    ${text}
        ${Text_Value}=    Replace String    ${trimValue}    "    ${EMPTY}
        Append To List    ${actualText}    ${Text_Value}
    END
    Log    ${expectedText}
    Log    ${actualText}
    Lists Should Be Equal    ${expectedText}    ${actualText}

Verify the Eml data in processing tab
    [Documentation]    Fills in the Underwriter and Operations contact information in the 'Processing' tab.
    ...
    ...    *Arguments:*
    ...    - `${Expected_Value}`: The Expected value .
    [Arguments]    ${Expected_Value}   
    ${Actual_Value}    Create List
    Wait For Elements State    ${UnderwriterName}    visible    timeout=${element_timeout}
    ${Actual_UnderwriterName}    Get Text    ${UnderwriterName}
    Append To List    ${Actual_Value}    ${Actual_UnderwriterName}
      Get Element States    ${UnderwriterEmail}    validate    value & visible    'UnderwriterEmail should be visible.'
    ${Actual_UnderwriterEmail}    Get Text    ${UnderwriterEmail}
    Append To List    ${Actual_Value}    ${Actual_UnderwriterEmail}
    Get Element States    ${UnderwrittingOffice}    validate    value & visible    'UnderwrittingOffice should be visible.'
    ${Actual_UnderwrittingOffice}    Get Text    ${UnderwrittingOffice}
    Append To List    ${Actual_Value}    ${Actual_UnderwrittingOffice}
    Get Element States    ${OperationsName}    validate    value & visible    'OperationsName should be visible.'
    ${Actual_OperationsName}    Get Text    ${OperationsName}
    Append To List    ${Actual_Value}    ${Actual_OperationsName}
    Get Element States    ${OperationsEmail}    validate    value & visible    'OperationsEmail should be visible.'
    ${Actual_OperationsEmail}    Get Text    ${OperationsEmail}
    Append To List    ${Actual_Value}    ${Actual_OperationsEmail}
    Get Element States    ${Channel}    validate    value & visible    'Channel should be visible.'
    ${Actual_Channel}    Get Text    ${Channel}
    Append To List    ${Actual_Value}    ${Actual_Channel}
   Get Element States    ${Rep_Office}    validate    value & visible    'Rep Office should be visible.'
    ${Actual_Repoffice}    Get Text    ${Rep_Office}
    Append To List    ${Actual_Value}    ${Actual_Repoffice}
    ${Actual_Direct_Assumed}    Get Text    ${Direct_Assumed}
    Append To List    ${Actual_Value}    ${Actual_Direct_Assumed}
    Run Keyword And Continue On Failure    Lists Should Be Equal    ${Expected_Value}    ${Actual_Value}


verify the Eml data in Coverage tab
    [Documentation]
    ...    This method is used to verify the Coverage Tab
    ...    ${Expecte_Product_Name}    The product name 
    ...    ${Expected_Product_Segment_Name}    The product segment Name
    [Arguments]    ${Expecte_Product_Name}    ${Expected_Product_Segment_Name} 
    Click Coverage Tab
    ${Product_Name}    Get Text    ${CoverageProductButton}  
    Run Keyword And Continue On Failure    Should Be Equal    ${Expecte_Product_Name}    ${Product_Name} 
    ${Product_Segment_Name}    Get Text    ${Clearance_Product_Segment}  
    Run Keyword And Continue On Failure    Should Be Equal    ${Expected_Product_Segment_Name}    ${Product_Segment_Name}

Verify Eml Data in Producer Tab
    [Documentation]    Verifies that the text of specific fields in the 'Producer' tab matches the expected data.
    ...    The fields checked are hardcoded within the keyword.
    ...
    ...    *Arguments:*
    ...    - `@{ExpectedPDFText}`: A list of strings containing the expected text for each verified field.
    [Arguments]    ${ExpectedPDFText}
    @{locators}     Create List    ${Agency}    ${ProducerName}    ${ProducerEmailButton}    
    @{ActualPDFText}    Create List
    FOR    ${locator}    IN    @{locators}
        Scroll To Element    ${locator}
        ${text}    Get Text    ${locator}
        ${trimText}    Strip String    ${text}
        Append To List    ${ActualPDFText}    ${trimText}
    END
    Log    ${ExpectedPDFText}
    Log    ${ActualPDFText}
    Run Keyword And Continue On Failure    Lists Should Be Equal    ${ExpectedPDFText}    ${ActualPDFText}

Verify EML PDF Data in Producer Tab
    [Documentation]    Verifies that the text of specific fields in the 'Producer' tab matches the expected data.
    ...    The fields checked are hardcoded within the keyword.
    ...
    ...    *Arguments:*
    ...    - `${ExpectedPDFText}`: A list of strings containing the expected text for each verified field.
    [Arguments]    ${ExpectedPDFText}
    @{locators}     Create List    ${Agency}    ${ProducerName}    ${ProducerAddress}    ${ProducerAddressStreet}    ${ProducerAddress2}    ${ProducerAddressCity}    ${ProducerAddressState}    ${ProducerPostalCode}    ${ProducerCountry}    ${ProducerCodeButton}    ${ProducerEmailButton}    ${Producer_Phone_number}
    @{ActualPDFText}    Create List
    FOR    ${locator}    IN    @{locators}
        Scroll To Element    ${locator}
        ${text}    Get Text    ${locator}
        ${trimText}    Strip String    ${text}
        Append To List    ${ActualPDFText}    ${trimText}
    END
    Log    ${ExpectedPDFText}
    Log    ${ActualPDFText}
    Lists Should Be Equal    ${ExpectedPDFText}    ${ActualPDFText}    

Verify EML Data the Coverage Tab
    [Documentation]    Verifies the effective date, expiration date, and product type in the 'Coverage' tab.
    ...
    ...    *Arguments:*
    ...    - `${data_expected_eff_date}`: The expected effective date.
    ...    - `${data_expected_expiry_date}`: The expected expiration date.
    ...    - `${data_expected_product}`: The expected product type.
    ...    ${Property_Segment_value}`: The expected product segment type.
    ...    ${Facultative_Reinsurance}`: The expected Facultative Reinsurance type.
        [Arguments]    ${data_expected_eff_date}    ${data_expected_expiry_date}    ${data_expected_product}    ${Property_Segment_value}    ${Facultative_Reinsurance}    
     Wait For Elements State    ${EffectiveDate}    visible    timeout=${element_timeout}
     ${actualEffectiveDate}    Get Text    ${EffectiveDate}
     ${trimEffectiveDate}    Strip String    ${actualEffectiveDate}
     Run Keyword And Continue On Failure    Should Be Equal    ${data_expected_eff_date}    ${trimEffectiveDate}
     ${actualExpirationDate}    Get Text    ${ExpirationDate}
     ${trimExpirationDate}    Strip String    ${actualExpirationDate}
     Run Keyword And Continue On Failure    Should Be Equal    ${data_expected_expiry_date}    ${trimExpirationDate}  
     ${Product_Name}    Get Text    ${CoverageProductButton}  
     Run Keyword And Continue On Failure    Should Be Equal    ${data_expected_product}    ${Product_Name} 
     ${Product_Segment_Name}    Get Text    ${Clearance_Product_Segment}  
     Run Keyword And Continue On Failure    Should Be Equal    ${Property_Segment_value}    ${Product_Segment_Name}  
     ${Facultative_Reinsurance_Name}    Get Text    ${Facultative_Reinsurance_loc}  
     Run Keyword And Continue On Failure    Should Be Equal    ${Facultative_Reinsurance}    ${Facultative_Reinsurance_Name}  
  
Verify Product field dropdown values in coverage tab
    [Documentation]    This method is used to verify  the Product field dropdown values
    ...    ${Expected_Product_Field}    We need to pass the Expected Values in list

    [Arguments]    ${Expected_Product_Field}

    ${Actual_Product_Text}    Create List    
    Wait For Elements State    ${CoverageProductButton}    visible
    Click    ${CoverageProductButton} 
    Wait For Elements State    ${ProductDropdown1}    visible
    Click    ${ProductDropdown1}
    ${Product_DropDownElements}    Get Elements    ${Product_DropDownElement}
    FOR    ${element}    IN    @{Product_DropDownElements}
        ${Product_Text}    Strip String    Get Text    ${element}
        Append To List    ${Actual_Product_Text}    ${Product_Text}     
    END
    Lists Should Be Equal    ${Expected_Product_Field}    ${Actual_Product_Text}
