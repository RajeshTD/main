*** Settings ***
Resource     ../../utils/common_keywords.robot
Variables     ../locators/documents_locators.py

*** Variables ***
${path}             ${CURDIR}/../../uploads/
${DownloadPath}     ${CURDIR}/../../downloads/
${testDataPath}     ${CURDIR}/../../testdata/
${ActualMsgFileName}    ActualMsg.msg
${ActualClaimsFileName}     ActualClaims.xlsx
${ExpectedClaimsFileName}     ExpectedClaims.xlsx
${ActualPoliciesFileName}     ActualPolicies.csv
${ExpectedPoliciesFileName}     ExpectedPolicies.csv
${ActualSchemaFileName}     ActualSchema.json
${ExpectedSchemaFileName}     ExpectedSchema.json

*** Keywords ***
Upload SOV and Loss Run Documents
    [Documentation]    Uploads multiple documents (like SOV and Loss Run) to the submission.
    ...
    ...    *Arguments:*
    ...    - `@{FileName}`: A list of file names to be uploaded from the `uploads` directory.
    [Arguments]    @{FileName}
    Switch to Documents
    FOR    ${file}    IN    @{FileName}
            ${AbsolutePath}=    Normalize Path    ${path}${file}
            Upload File By Selector    ${UploadFile}    ${AbsolutePath}
            Sleep    2s
    END
    FOR    ${file}    IN    @{FileName}
        ${isArchive} =   Run Keyword And Return Status    Get Element States    ${ArchiveIcon}    validate    value & visible    'ArchiveIcon should be visible.'
        IF   ${isArchive}
            # ${AbsolutePath}=    Normalize Path    ${path}${file}
            ${ArchieveFile}=    Catenate    SEPARATOR=    ${ArchiveButton1}    ${file}    ${ArchiveButton2}
            Click    ${ArchieveFile}
            Sleep    2s
        END
    END
    Wait For Elements State    ${UploadButton}    visible
    Click    ${UploadButton}

Wait for Upload to Complete
    [Documentation]    Waits for the document upload and processing to complete.
    ...    It monitors several processing indicators to ensure all background tasks are finished.
    Wait For Elements State    ${processingStage2}    visible    timeout=30s
    Wait For Elements State    ${processingStage2}    hidden    timeout=600s
    Wait For Elements State    ${LossRunProcessing}    detached    timeout=600s
    Wait For Elements State   ${LossRunFile}    visible    timeout=120s

Verify Claims Data From Loss Run File
    [Documentation]    Downloads the claims data (as an Excel file) extracted from the Loss Run document and compares it with an expected data file.
    ...    It ignores certain columns that may contain dynamic data (like row IDs or coordinates).
    Switch To Documents
    Scroll To Element    ${LossRunFile}
    Get Element States    ${LossRunFile}    validate    enabled    'LossRunFile should be enabled.'
    Click    ${LossRunFile}
    Wait For Elements State    ${Claims}    visible
    Click    ${Claims}
    Wait For Elements State    ${DownloadDropdown}    visible
    Click    ${DownloadDropdown}
    Wait For Elements State    ${DownloadData}    visible
    ${promise}    Promise To Wait For Download    ${DownloadPath}${ActualClaimsFileName}
    Click    ${DownloadData}
    ${fileObject}    Wait For     ${promise}
    File Should Exist    ${fileObject}[saveAs]
    ${cols_to_ignore}=    Create List    row_id    x1    x2    y1    y2
    Compare Excel Files    ${testDataPath}${ExpectedClaimsFileName}    ${DownloadPath}${ActualClaimsFileName}    ignore_columns=${cols_to_ignore}

Verify Policies Data From Loss Run File
    [Documentation]    Downloads the policies data (as a CSV file) from the Loss Run document and compares it with an expected data file.
    Switch To Documents
    Scroll To Element    ${LossRunFile}
    Get Element States    ${LossRunFile}    validate    enabled    'LossRunFile should be enabled.'
    Click    ${LossRunFile}
    Wait For Elements State    ${Policies}    visible
    Click    ${Policies}
    Wait For Elements State    ${DownloadDropdown}    visible
    Click    ${DownloadDropdown}
    Wait For Elements State    ${DownloadData}    visible
    ${promise}    Promise To Wait For Download    ${DownloadPath}${ActualPoliciesFileName}
    Click    ${DownloadData}
    ${fileObject}    Wait For     ${promise}
    File Should Exist    ${fileObject}[saveAs]
    Compare Excel Files    ${testDataPath}${ExpectedPoliciesFileName}    ${DownloadPath}${ActualPoliciesFileName}

Verify Analysis Data From Loss Run File
    [Documentation]    Verifies the data displayed in the 'Analysis' section for a Loss Run file.
    ...    It compares both the summary card data and the data in the main table with expected values.
    ...
    ...    *Arguments:*
    ...    - `@{CardName}`: A list of labels for the summary cards to verify.
    ...    - `@{expectedCardData}`: A list of expected string values for the summary cards.
    ...    - `@{expectedTableData}`: A list of expected string values for the data in the analysis table.
    [Arguments]    ${CardName}    ${expectedCardData}    ${expectedTableData}
    Wait For Elements State    ${Analysis}    visible
    ${actualAnalysisData}    Create List    
    Click    ${Analysis}
    FOR    ${data}    IN    @{CardName}
        ${locator}    Catenate    SEPARATOR=    ${CardDatas1}    ${data}    ${CardDatas2}
        Wait For Elements State    ${locator}    visible
        ${actualData}    Get Text    ${locator}
        ${trimData}    Strip String    ${actualData}
        Append To List    ${actualAnalysisData}    ${trimData}
    END
    Should Be Equal    ${actualAnalysisData}    ${expectedCardData}
    ${tableData}    Get Elements    ${AnalysisTableData}
    ${tableDatas}    Create List
    FOR    ${data_value}    IN    @{tableData}
        ${text}    Get Text    ${data_value}
        ${trimmedData}    Strip String    ${text}
        Append To List     ${tableDatas}    ${trimmedData}
    END
    Should Be Equal    ${tableDatas}    ${expectedTableData}

Verify Schema by downloading the json file
    [Documentation]    Downloads the submission schema as a JSON file and compares it with an expected schema file.
    ...    This is used to validate the data structure of the submission.
    ...    Handles both single values and list results from JSON queries.
    ...    Examples:
    ...    - Single value query: 'd3Submission.d3Company.name'
    ...    - List query: 'd3Submission.d3Company.naics.*.code'
    [Arguments]    ${queryList}    @{expectedModification}
    Switch To Documents
    Scroll To Element    ${DownloadSchema}
    Get Element States    ${DownloadSchema}    validate    enabled    'DownloadSchema should be enabled.'
    Click    ${DownloadSchema}
    ${promise}    Promise To Wait For Download    ${DownloadPath}${ActualSchemaFileName}
    ${fileObject}    Wait For     ${promise}
    File Should Exist    ${fileObject}[saveAs]
    
    # Verify file is not empty
    ${size}    Get File Size    ${fileObject}[saveAs]
    Should Be True    ${size} > 0    Downloaded schema file is empty
    
    ${actualDataInSchema}    Create List
    FOR    ${query}    IN    @{queryList}
        ${result}=    Get Json Value By Query    ${DownloadPath}${ActualSchemaFileName}    ${query}
        
        # Handle both single values and lists
        ${is_list}=    Evaluate    isinstance($result, list)
        IF    ${is_list}
            Log    Processing list result for query '${query}'
            FOR    ${item}    IN    @{result}
                # Ensure all values are converted to strings and normalized
                ${strValue}=    Convert To String    ${item}
                ${trimmedItem}=    Strip String    ${strValue}
                Append To List    ${actualDataInSchema}    ${trimmedItem}
            END
        ELSE
            Log    Processing single value for query '${query}'
            # Ensure all values are converted to strings and normalized
            ${strValue}=    Convert To String    ${result}
            ${trimmedData}=    Strip String    ${strValue}
            Append To List    ${actualDataInSchema}    ${trimmedData}
        END
    END
    
    Log List    ${actualDataInSchema}    
    
    # If expectedModification is provided, compare with actual data
    ${expectedLength}    Get Length    ${expectedModification}
    IF    ${expectedLength} > 0
        ${actualLength}    Get Length    ${actualDataInSchema}
        Should Be Equal As Integers    ${actualLength}    ${expectedLength}    
        ...    Actual and expected data length mismatch. Actual: ${actualLength}, Expected: ${expectedLength}
        
        FOR    ${index}    ${expected}    IN ENUMERATE    @{expectedModification}
            # Convert both values to strings for comparison
            ${expectedStr}=    Convert To String    ${expected}
            ${expectedTrimmed}=    Strip String    ${expectedStr}
            # Remove surrounding quotes if present
            ${expectedTrimmed}=    Evaluate    str('${expectedTrimmed}').strip('"').strip("'")
            
            ${actualStr}=    Convert To String    ${actualDataInSchema}[${index}]
            ${actualTrimmed}=    Strip String    ${actualStr}
            # Remove surrounding quotes if present
            ${actualTrimmed}=    Evaluate    str('${actualTrimmed}').strip('"').strip("'")
            
            # Log the types and values being compared
            Log    Comparing at index ${index}:
            Log    Expected (${expectedTrimmed}) type: ${expectedStr.__class__.__name__}
            Log    Actual (${actualTrimmed}) type: ${actualStr.__class__.__name__}
            Log    After quote stripping - Expected: '${expectedTrimmed}', Actual: '${actualTrimmed}'
            
            Should Be Equal As Strings    ${actualTrimmed}    ${expectedTrimmed}    
            ...    Mismatch at index ${index}. Expected: '${expectedTrimmed}', Actual: '${actualTrimmed}'
        END
    END

Verify WorkFlow History
    [Documentation]    Verifies that the workflow history log contains a set of expected events or entries.
    ...    It reads the entire history table and checks for the presence of each expected value. It skips date validation.
    ...
    ...    *Arguments:*
    ...    - `@{expectedList}`: A list of strings that are expected to be found in the workflow history table.
    [Arguments]    ${expectedList}
    Switch to Documents
    Click    ${WorkFLow_History}
    Sleep    3s
    ${tableRows}    Get Element Count   //tbody//tr
    Log    ${tableRows}
    @{actualText}    Create List  
    FOR    ${index}    IN RANGE    1    ${tableRows + 1} 
        ${td}    Get Elements     //tbody//tr[${index}]//td[not(ul)]
        ${row_items_count}    Get Length    ${td}
        FOR    ${td_index}    IN RANGE    ${row_items_count}
            ${text}    Get Text    ${td}[${td_index}]
            ${trimValue}    Strip String    ${text}
            # First column (index 0) in each row is a date
            IF    ${td_index} == 0
                Log    >${trimValue}<
                ${is_valid_date}    Run Keyword And Return Status    Should Match Regexp    ${trimValue}    ^[A-Za-z]{3}, [A-Za-z]{3} \\d{1,2} \\d{4}, \\d{2}:\\d{2}:\\d{2} [A-Z]{3}(?:[+-]\\d{1,2}:\\d{2})?$
            ELSE
                Append To List    ${actualText}    ${trimValue}
            END
        END
    END
    Log    ${actualText}
    Log    ${expectedList}
    FOR    ${expected_value}    IN    @{expectedList}
        Log    ${expected_value}
        List Should Contain Value    ${actualText}    ${expected_value}    msg=Workflow history data mismatch - Missing expected value: ${expected_value}
    END

Wait for Upload to Complete for SOV and Loss Run
    [Documentation]    Waits for the document upload and processing to complete.
    ...    It monitors several processing indicators to ensure all background tasks are finished.
    [Arguments]    ${stageNo}
    ${stage}    Catenate    SEPARATOR=    ${processingStage}    ${stageNo}    ')]
    Wait For Elements State    ${stage}    visible    timeout=30s
    Wait For Elements State    ${stage}    hidden    timeout=1200s
    Wait For Elements State    ${LossRunProcessing}    detached    timeout=1200s
    Wait For Elements State   ${LossRunFile}    visible    timeout=120s

Verify Schema section is available in Documents Page
    [Documentation]    Verifies that the schema section is available in the documents page.
    Switch to Documents
    ${status}    Run Keyword And Return Status    Wait For Elements State    ${SchemaSection}    visible    timeout=10s    
    Should Be True    ${status}
    Click    ${SchemaSection}
    Wait For Elements State   ${SchemaJson}    visible    timeout=10s

Remove Document after Upload
    [Documentation]    Uploads multiple documents (like SOV and Loss Run) to the submission.
    ...
    ...    *Arguments:*
    ...    - `@{FileName}`: A list of file names to be uploaded from the `uploads` directory.
    [Arguments]    @{FileName}
    Switch to Documents
    FOR    ${file}    IN    @{FileName}
            ${AbsolutePath}=    Normalize Path    ${path}${file}
            Upload File By Selector    ${UploadFile}    ${AbsolutePath}
            Sleep    2s
    END
    FOR    ${file}    IN    @{FileName}
            # ${AbsolutePath}=    Normalize Path    ${path}${file}
            ${isArchive} =   Run Keyword And Return Status    Get Element States    ${ArchiveIcon}    validate    value & visible    'ArchiveIcon should be visible.'
            IF   ${isArchive}
            ${ArchieveFile}=    Catenate    SEPARATOR=    ${ArchiveButton1}    ${file}    ${ArchiveButton2}
            Click    ${ArchieveFile}
            Sleep    2s
            END
    END
    FOR    ${file}    IN    @{FileName}
     ${remove}    Catenate    SEPARATOR=    ${CloseIconInDocumentsPrefix}    ${file}    ${CloseIconInDocumentsSuffix}
           
            ${isPDF} =  Run Keyword And Return Status    Should Contain    ${file}    pdf   
            ${isExcel} =  Run Keyword And Return Status    Should Contain    ${file}    xls
            ${isEml} =  Run Keyword And Return Status    Should Contain    ${file}    eml
            IF    ${isPDF}
                Run Keyword And Continue On Failure     Get Element States    ${PDFIcon}    Validate    value & visible
                 Click    ${remove}
                Run Keyword And Continue On Failure     Get Element States    ${remove}    Validate    hidden    'Remove button should be visible for PDF file.'
                Sleep    1s
                Run Keyword And Continue On Failure    Get Element States    ${PDFIcon}    Validate    hidden 
            ELSE IF    ${isExcel}
                Run Keyword And Continue On Failure    Get Element States    ${ExcelIcon}    Validate    value & visible
                Click    ${remove}
                Run Keyword And Continue On Failure    Get Element States    ${remove}    Validate    hidden    'Remove button should be visible for Excel file.'
               Sleep    1s
                Run Keyword And Continue On Failure    Get Element States    ${ExcelIcon}    Validate    hidden
            
            ELSE IF    ${isEml}
                Run Keyword And Continue On Failure    Get Element States    ${ExcelIcon}    Validate    value & visible
                Click    ${remove}
                Run Keyword And Continue On Failure    Get Element States    ${remove}    Validate    hidden    'Remove button should be visible for Excel file.'
               Sleep    1s
                Run Keyword And Continue On Failure    Get Element States    ${ExcelIcon}    Validate    hidden
            END
        END

verify that the Reprocess button is not Available in Document Tab

    [Documentation]    This method is verify the Reprocess button  not Availabe in the Document Tab
    [Arguments]    ${DropDown_Option}   

  
    Switch to Documents
    Wait For Elements State    ${More_Option_Sov}
    Click    ${More_Option_Sov}
    Wait For Elements State    ${Stop_Option}
    Click    ${Stop_Option}
    Get Element States    ${Asset_Stop_Popup}    validate    value & visible
    Wait For Elements State    ${More_Option_Sov}
    Click    ${More_Option_Sov}
    Wait For Elements State    ${Force_HITL}
    Click    ${Force_HITL}
    Get Element States    ${Forcing_HITL_popup}    validate    value & visible
    Wait For Elements State    ${Sov_DropDown_Option}    visible    5s
    sleep    10s
    Select Options By    ${Sov_DropDown_Option}    text    ${DropDown_Option}
    Get Element States    ${reprocess_msg}    validate    value & visible
    Get Element States    ${Bug_Reprocess_Button_Doc_Tab}    validate    value & detached
    Get Element States    ${Bug_Reprocess_Msg_Doc_Tab}    validate    value & detached



# verify the Email Body Document

#     [Documentation]    This method is used to verify the Email Body Documents

#     [Arguments]    ${file_name}    ${expected_body_Msg}    
    
#     Switch to Documents
#     ${element}    Catenate    SEPARATOR=    ${Email_Body_1}    ${file_name}']
#     Scroll To Element    ${element}
#     Click    ${element}
#     ${text1}    Get Text    ${Email_Body_msg}
#     ${actual_normalized}=    Replace String    ${text1}    \n    ${EMPTY}
#     ${Exceptedvalue}    Strip String    ${expected_body_Msg}
#     Log    ${Exceptedvalue}
#     Log    ${actual_normalized}
#     Run Keyword And Continue On Failure    Should Be Equal As Strings    ${Exceptedvalue.strip()}    ${actual_normalized.strip()}
verify the Email Body Document

    [Documentation]    This method is used to verify the Email Body Documents
    [Arguments]    ${file_name}    ${expected_body_Msg}    
 
    Switch to Documents
    ${element}    Catenate    SEPARATOR=    ${Email_Body_1}    ${file_name}']
    Scroll To Element    ${element}
    Click    ${element}
    ${text1}=    Get Text    ${Email_Body_msg}
 
    # Normalize actual text (remove newlines, collapse spaces)
    ${actual_normalized}=    Replace String    ${text1}    \n    ${SPACE}
    ${actual_normalized}=    Replace String    ${actual_normalized}    \r    ${EMPTY}
    ${actual_normalized}=    Replace String Using Regexp    ${actual_normalized}    \\s+    ${SPACE}
    ${actual_normalized}=    Strip String    ${actual_normalized}
 
    # Normalize expected text (remove newlines, collapse spaces)
    ${expected_clean}=    Replace String    ${expected_body_Msg}    \n    ${SPACE}
    ${expected_clean}=    Replace String    ${expected_clean}    \r    ${EMPTY}
    ${expected_clean}=    Replace String Using Regexp    ${expected_clean}    \\s+    ${SPACE}
    ${expected_clean}=    Strip String    ${expected_clean}
 
    # Final check
    Run Keyword And Continue On Failure    Should Be Equal    ${expected_clean}    ${actual_normalized}
    Click    ${Document_Back_button}
 
# Verify The Email Body Document
#     [Documentation]    This method is used to verify the Email Body Documents
#     [Arguments]    ${expected_body_Msg}    

#     Switch to Documents
#     Scroll To Element    ${Email_Body_Doc}
#     Click    ${Email_Body_Doc}
#     ${text1}=    Get Text    ${Email_Body_msg}

#     # Normalize: remove newlines, collapse multiple spaces, strip leading/trailing
#     ${actual_normalized}=    Evaluate    re.sub(r"\s+", " ", """${text1}""").strip()    re
#     ${expected_normalized}=    Evaluate    re.sub(r"\s+", " ", """${expected_body_Msg}""").strip()    re
#     ${actual_normalized}=    Replace String    ${actual_normalized}    \n    ${EMPTY}
#     Run Keyword And Continue On Failure    Should Contain    ${expected_normalized}    ${actual_normalized}


verify the colour of the processed and archived
    [Documentation]    This method is used to verify the colour of the processed and archived in document tab

    Switch to Documents
    ${Colour}=    Get Style    ${Doc_Processed_loc}    color
    ${Colour_name}    Get Colour Name    ${Colour}    
    Run Keyword And Continue On Failure    Should Be Equal    ${Colour_name}    indigo
    ${Colour}=    Get Style    ${Doc_Archived_loc}    color
    Log    ${Colour}
    ${Colour_name}    Get Colour Name    ${Colour}    
    Run Keyword And Continue On Failure    Should Be Equal    ${Colour_name}    grayish-blue
     ${Colour}=    Get Style    ${Doc_External_links_loc}    color
    Log    ${Colour}
    ${Colour_name}    Get Colour Name    ${Colour}    
    Run Keyword And Continue On Failure    Should Be Equal    ${Colour_name}    grayish-blue
    Click    ${Doc_Archived_loc} 
    Click    ${Search_file_loc} 
    ${Colour}=    Get Style    ${Doc_Archived_loc}    color
    ${Colour_name}    Get Colour Name    ${Colour}    
    Run Keyword And Continue On Failure    Should Be Equal    ${Colour_name}    indigo
    ${Colour}=    Get Style    ${Doc_Processed_loc}    color
    ${Colour_name}    Get Colour Name    ${Colour}    
    Run Keyword And Continue On Failure    Should Be Equal    ${Colour_name}    grayish-blue 
     ${Colour}=    Get Style    ${Doc_External_links_loc}    color
    Log    ${Colour}
    ${Colour_name}    Get Colour Name    ${Colour}    
    Run Keyword And Continue On Failure    Should Be Equal    ${Colour_name}    grayish-blue

verify the Msg file dowload in msg format 
    [Documentation]     This method is used to verify the msg file dowloded in the .msg format   
    ...    ${filename}    we need to pass the file name 
    ...    ${extension} ew need to pass the file format (eg : .msg , .eml ,.pdf)
    [Arguments]    ${filename}    ${extension}
     Switch to Documents
    Scroll To    ${Email_body_more_option} 
     Wait For Elements State    ${Email_body_more_option}    visible
    Click    ${Email_body_more_option}
    Wait For Elements State    ${Email_body_dowload_option}    visible
    ${promise}    Promise To Wait For Download    ${DownloadPath}${ActualMsgFileName}
    Click    ${Email_body_dowload_option}
    ${fileObject}    Wait For     ${promise}
    File Should Exist    ${fileObject}[saveAs]
    Should Contain    ${fileObject}[suggestedFilename]    ${filename}  
    Should Contain    ${fileObject}[suggestedFilename]    ${extension}

verify the more options fields
    [Documentation]    This method is used for the verify the more options
    [Arguments]    ${Expected_value}
    ${Actual_value}    Create List
    Click    ${Email_body_more_option}
    ${elements}    Get Elements    ${Document_more_options_fields}
    FOR    ${element}    IN    @{elements}
        ${values}    Get Text    ${element}
        ${values}    Strip String    ${values}
        Append To List    ${Actual_value}    ${values}  
    END       
        Lists Should Be Equal    ${Expected_value}    ${Actual_value}

verify the file info details
    [Documentation]    This method is used for verify the document info detials
    [Arguments]    ${file_name}    ${data}

    verify the more options fields    ${data['More_fields']}
    ${today}=    Get Current Date    result_format=%b %d, %Y
    Insert Into List    ${data['expected_data']}    5    ${today}
    Insert Into List    ${data['expected_data']}    6    ${today}
    Insert Into List    ${data['expected_data']}    0    ${file_name}
    Append To List    ${data['expected_data']}    ${file_name}    
    ${Actual_Fields_name}    Create List
    ${Actual_info_value}    Create List
    Click    ${Email_body_info_option}
    ${info_fields}    Get Elements    ${Document_info_detials_field}
    FOR    ${element}    IN    @{info_fields}
        ${Info_field_name}    Get Text    ${element}
        ${Info_field_name}    Strip String    ${Info_field_name}
        Append To List    ${Actual_Fields_name}    ${Info_field_name}    
    END
    Run Keyword And Continue On Failure    Lists Should Be Equal    ${data['info_fields']}    ${Actual_Fields_name}
    ${info_values}    Get Elements    ${Document_info_detials_value}
    FOR    ${element}    IN    @{info_values}
        ${Info_field_value}    Get Text    ${element}
        ${Info_field_value}    Strip String    ${Info_field_value}
        Append To List    ${Actual_info_value}    ${Info_field_value}  
    END
    Log    ${data['expected_data']}
    Log    ${Actual_info_value}
    ${length}    Get Length    ${Actual_info_value}
    FOR    ${counter}    IN RANGE    0    ${length}    
       ${expected_item}=    Get From List    ${data['expected_data']}    ${counter}
        ${actual_item}=      Get From List    ${Actual_info_value}    ${counter}
        Run Keyword And Continue On Failure    Should Contain    ${actual_item}    ${expected_item}
    END
delete the given file in documentTab
    [Documentation]    This method is used to delete the given type file 
    [Arguments]    @{document_type_data}
    
    FOR    ${type}    IN    @{document_type_data}
    ${locator}    Catenate    SEPARATOR=    ${more_option}    ${type}'] 
    ${Documents}    Get Elements    ${locator}
        FOR    ${element}    IN    @{Documents}
        ${locator_delete}    Catenate    SEPARATOR=    ${Docment_delete_option1}    ${type}'] 
         Click    ${element}
         Click    ${locator_delete}
        
        END   
   
    END
  







