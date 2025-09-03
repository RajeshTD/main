*** Settings ***
Resource    ../../utils/common_keywords.robot
Library    ../../libraries/ScreenshotListener.py    False
Test Setup    Launch URL and Login in to the application
Test Teardown    Run Keywords    Close Context    Close Browser

*** Test Cases ***
TC_E2E_001
    [Tags]    E2E-WithoutSov    
    [Documentation]    End to End Testing for New Submission - In Draft Stage: This stage is primarily for Submission Clearance process
    # Create User If the User is not present    ${NewUser}
    # Create User If the User is not present    ${ReferralUser}
    # Select Impersonate option from the actions    ${NewUser['email']}    ${NewUser['search_user']}
    Run Keyword And Continue On Failure    Verify My Assignments Tab is displayed as a default tab
    ${submission_id}    Create New Submission    ${TC_E2E_001['FileName']}    @{TC_E2E_001['SubmissionColumnNames']}
    Set Suite Variable   ${submission_id_1}    ${submission_id}
    Select Submission using submission id    ${submission_id}    @{TC_E2E_001['SubmissionColumnNames']}
    Run Keyword And Continue On Failure    Verify Submission page is displayed
    Run Keyword And Continue On Failure    Verify All Side menu options are Displayed
    Switch To Summary Tab    ${TC_E2E_001['SummaryHeader']}
    Run Keyword And Continue On Failure    Verify Summary Table Data    ${TC_E2E_001['SummaryTableHeader']}    ${TC_E2E_001['SummaryTableData']}
    Run Keyword And Continue On Failure    Verify Policy Information Fields In Summary Tab     ${TC_E2E_001['PolicyFields']}   
    Run Keyword And Continue On Failure    Verify the Workflow Reflected in Summary tab    ${TC_E2E_001['AdvanceTo']}
    Click Edit Submission
    Run Keyword And Continue On Failure    Click and verify Clearance tab
    # Run Keyword And Continue On Failure     Verify the Error popup when mandate fields left empty    ${TC_E2E_001}
    Click Insured Tab
    Run Keyword And Continue On Failure    Verify PDF Data in Insured Tab    @{TC_E2E_001['expectedPDFText']}
    Fill the data for issue fields    ${TC_E2E_001['SicCode']}    ${TC_E2E_001['SicDescription']}    ${TC_E2E_001['NAICSCode']}
    Run Keyword And Continue On Failure    Verify User Mod is message for updated fields
    Click Processing Tab                    
    Fill the data for issue fields in processing    ${TC_E2E_001['UnderwriterName']}    ${TC_E2E_001['UnderwriterEmail']}    ${TC_E2E_001['OperationsName']}        ${TC_E2E_001['OperationsEmail']}    ${TC_E2E_001['UnderwrittingOffice']}    ${TC_E2E_001['Channel']}
    Click Producer Tab
    Run Keyword And Continue On Failure    Verify PDF Data in Producer Tab    @{TC_E2E_001['expectedTextInProducer']}
    Fill the data for issues field in Producer    ${TC_E2E_001['ProducerName']}      ${TC_E2E_001['ProducerEmail']} 
    Click Coverage Tab
    Run Keyword And Continue On Failure    Verify the Coverage data    ${TC_E2E_001['EffectiveDate']}     ${TC_E2E_001['ExpirationDate']}     ${TC_E2E_001['Product']}
    Fill the data for issues field in Coverage    ${TC_E2E_001['Covered']}    
    Click Issues Tab
    @{expectedIssues}    Create List    ${TC_E2E_001['SicCode']}    ${TC_E2E_001['SicDescription']}    ${TC_E2E_001['NAICSCode']}    ${TC_E2E_001['UnderwriterName']}    ${TC_E2E_001['UnderwriterEmail']}    ${TC_E2E_001['UnderwrittingOffice']}     ${TC_E2E_001['OperationsName']}    ${TC_E2E_001['OperationsEmail']}    ${TC_E2E_001['Channel']}    ${TC_E2E_001['ProducerName']}
    Run Keyword And Continue On Failure    Verify updated datas in Issues Tab    @{expectedIssues}
    Click Finish Tab
    Run Keyword And Continue On Failure    Verify and click the save and close button
    Switch to Documents
    @{expectedModification}    Create List    "${TC_E2E_001['SicCode']}"    "${TC_E2E_001['SicDescription']}"    "${TC_E2E_001['NAICSCode']}"    "${TC_E2E_001['UnderwriterName']}"    "${TC_E2E_001['UnderwriterEmail']}"    "${TC_E2E_001['UnderwrittingOffice']}"     "${TC_E2E_001['OperationsName']}"    "${TC_E2E_001['OperationsEmail']}"    "${TC_E2E_001['Channel']}"    "${TC_E2E_001['ProducerName']}"    "${TC_E2E_001['ProducerEmail']}"    "${TC_E2E_001['Covered']['Product']}"    "${TC_E2E_001['Covered']['ProductSegment']}"    
    Run Keyword And Continue On Failure    Verify datas in UserModification file    @{expectedModification}
    Run Keyword And Continue On Failure    Verify Schema by downloading the json file    ${TC_E2E_001['queryList']}    @{expectedModification}
    Create New Task    ${TC_E2E_001['taskdata']}
    Run Keyword And Continue On Failure    Verify the created task details    ${TC_E2E_001['taskDetails']}
    Run Keyword And Continue On Failure    verify Edit Delete and Complete task Buttons are present on the right side of task list
    Run Keyword And Continue On Failure    Verify Edit Icon is Clickable and Functional    ${TC_E2E_001['priority']}
    Run Keyword And Continue On Failure    Verify the created task details    ${TC_E2E_001['taskupdateddetails']}
    Click Answers Tab
    Run Keyword And Continue On Failure    Select the Created Task    ${TC_E2E_001['taskdata']}
    Run Keyword And Continue On Failure    Verify Delete Icon is Clickable and Functional    ${TC_E2E_001['taskupdateddetails']}
    Create New Mail    ${TC_E2E_001['emailData']}
    Run Keyword And Continue On Failure    Verify Email Sent Successfully
    Run Keyword And Continue On Failure    Verify Sent Email    ${TC_E2E_001['emailVerify']}
    Run Keyword And Continue On Failure    Save and verify mail in Draft    ${TC_E2E_001['emailData']} 
    Discard the Created Email    ${TC_E2E_001['emailData']}      
    Create New Mail With Missing Data    ${TC_E2E_001['emailData_Mising']}    ${TC_E2E_001['Expected_PopUp']}  
    Run Keyword And Continue On Failure    Verify WorkFlow History    ${TC_E2E_001['expectedWorkFlowHistory']}
    Run Keyword And Continue On Failure    Save Submission And verify popup
    Run Keyword And Continue On Failure    Verify Submission updated
    Run Keyword And Continue On Failure    Verify WorkFlow Options Advance Stage and Reject

TC_E2E_007
    [Tags]    E2E-WithoutSov    
    [Documentation]    End to End Testing for New Submission - (Cleared to Under Review Stage) with SOV Loss run"
    # Create User If the User is not present    ${NewUser}
    # Select Impersonate option from the actions    ${NewUser['email']}    ${NewUser['search_user']}
    Run Keyword And Continue On Failure    Verify My Assignments Tab is displayed as a default tab
    Click All submissions option
    Select Submission using submission id    ${submission_id_1}    @{TC_E2E_007['SubmissionColumnNames']}
    Run Keyword And Continue On Failure    Verify Submission page is displayed
    Advance Stage 2
    Run Keyword And Continue On Failure    Verify Stage is updated in the submission    ${TC_E2E_007['stage']}
    Run Keyword And Continue On Failure    Verify All Side menu options are Displayed
    Switch To Summary Tab    ${TC_E2E_007['SummaryHeader']}
    Run Keyword And Continue On Failure    Verify Summary Table Data    ${TC_E2E_007['SummaryTableHeader']}    ${TC_E2E_007['SummaryTableData']}
    Run Keyword And Continue On Failure    Verify Policy Information Fields In Summary Tab     ${TC_E2E_007['PolicyFields']}   
    Run Keyword And Continue On Failure    Verify the Workflow Reflected in Summary tab    ${TC_E2E_007['AdvanceTo']}
    Run Keyword And Continue On Failure    Verify Schema section is available in Documents Page
    Click Edit Submission
    Click Answers Tab
    Run Keyword And Continue On Failure    Verify Answers Lists    ${TC_E2E_007['expectedQuestion']}
    Run Keyword And Continue On Failure    Verify Company Website Link    ${TC_E2E_007['expectedTitle']}
    Run Keyword And Continue On Failure    Verify Risk360 Card Pages Navigation    ${TC_E2E_007['Risk360_Card_Names']}    ${TC_E2E_007['Risk360_Card_Pages_Names']}
    Create New Task    ${TC_E2E_007['taskdata']}
    Run Keyword And Continue On Failure    Verify the created task details    ${TC_E2E_007['taskDetails']}
    Run Keyword And Continue On Failure    verify Edit Delete and Complete task Buttons are present on the right side of task list
    Run Keyword And Continue On Failure    Verify Edit Icon is Clickable and Functional    ${TC_E2E_007['priority']}
    Run Keyword And Continue On Failure    Verify the created task details    ${TC_E2E_007['taskupdateddetails']}
    Click Answers Tab
    Run Keyword And Continue On Failure    Select the Created Task    ${TC_E2E_007['taskdata']}
    Run Keyword And Continue On Failure    Verify Delete Icon is Clickable and Functional    ${TC_E2E_007['taskupdateddetails']}
    Run Keyword And Continue On Failure    Remove Document after Upload     @{TC_E2E_007['FileName']}
    Create New Mail    ${TC_E2E_007['emailData']}
    Run Keyword And Continue On Failure    Verify Email Sent Successfully
    Run Keyword And Continue On Failure    Verify Sent Email    ${TC_E2E_007['emailVerify']}
    Run Keyword And Continue On Failure    Save and verify mail in Draft    ${TC_E2E_007['emailData']} 
    Discard the Created Email    ${TC_E2E_007['emailData']}      
    Create New Mail With Missing Data    ${TC_E2E_007['emailData_Mising']}    ${TC_E2E_007['Expected_PopUp']}
    Upload SOV and Loss Run Documents    @{TC_E2E_007['FileName']}
    Wait for Upload to Complete
    Open uploaded SOV File   
    Run Keyword And Continue On Failure    Verify datas are matching for the uploaded SOV file    ${TC_E2E_003['SOVFile']}
    ${length}    Get Length    ${TC_E2E_003['dropdownOptions']}
    Run Keyword And Continue On Failure    Verify Properties datas for the given dropdown options    ${length}
    Run Keyword And Continue On Failure    Verify Claims Data From Loss Run File
    # Verify Policies Data From Loss Run File
    Run Keyword And Continue On Failure    Verify Analysis Data From Loss Run File    ${TC_E2E_007['CardName']}    ${TC_E2E_007['expectedAnalysisData']}    ${TC_E2E_007['expectedTableData']}
    # Run Keyword And Continue On Failure    Verify WorkFlow History    ${TC_E2E_007['expectedWorkFlowHistory']}
    Run Keyword And Continue On Failure    Save Submission And verify popup
    Run Keyword And Continue On Failure    Verify Submission updated in Stage 2
    Run Keyword And Continue On Failure    Verify WorkFlow Options Advance Stage and Reject

TC_E2E_011
    [Tags]    E2E-WithoutSov    
    [Documentation]    End to End Testing for New Submission - (Under Review stage + Child submission)  with SOV and LR upload"
    # Create User If the User is not present    ${NewUser}
    # Select Impersonate option from the actions    ${NewUser['email']}    ${NewUser['search_user']}
    Run Keyword And Continue On Failure    Verify My Assignments Tab is displayed as a default tab
    Click All submissions option
    Select Submission using submission id    ${submission_id_1}   @{TC_E2E_011['SubmissionColumnNames']}
    Run Keyword And Continue On Failure    Verify Submission page is displayed
    Advance Stage    ${TC_E2E_011['stageNo']}    
    Run Keyword And Continue On Failure    Verify Stage is updated in the submission    ${TC_E2E_011['stage']}
    Click Edit Submission
    Click and verify Clearance tab
    Create Child Submission    ${TC_E2E_011['productName']}
    Wait For Processing Stage    ${TC_E2E_011['stageNo']}
    ${newSubmissionID}    Get New Submission ID After Child Submission
    Set Suite Variable    ${new_submission_id_1}   ${newSubmissionID}  
    Navigate To All Submissions page from submissions 
    Select Submission using submission id    ${new_submission_id_1}    @{TC_E2E_011['SubmissionColumnNames']}
    Wait For Processing Stage    ${TC_E2E_011['stageNo']}
    Run Keyword And Continue On Failure    Verify Summary Menu is displayed
    Switch To Summary Tab    ${TC_E2E_011['SummaryHeader']}
    Run Keyword And Continue On Failure    Verify Premium Amount    
    Run Keyword And Continue On Failure    Enter the Policy Information    ${TC_E2E_011['PolicyInfo']}
    Run Keyword And Continue On Failure    Verify Summary Table Data    ${TC_E2E_011['SummaryTableHeader']}    ${TC_E2E_011['SummaryTableData']}
    Run Keyword And Continue On Failure    Verify the Workflow Reflected in Summary tab    ${TC_E2E_011['AdvanceTo']}
    Run Keyword And Continue On Failure    Verify Schema section is available in Documents Page
    Click Answers Tab
    Run Keyword And Continue On Failure    Complete Forms Tab Details Filling    ${TC_Forms_01}
    Click Answers Tab
    Click Edit Submission
    Run Keyword And Continue On Failure    Verify Answers Lists    ${TC_E2E_011['expectedQuestion']}
    Run Keyword And Continue On Failure    Verify Risk360 Card Pages Navigation    ${TC_E2E_011['Risk360_Card_Names']}    ${TC_E2E_011['Risk360_Card_Pages_Names']}
    Create New Task    ${TC_E2E_011['taskdata']}
    Run Keyword And Continue On Failure    Verify the created task details    ${TC_E2E_011['taskDetails']}
    Run Keyword And Continue On Failure    verify Edit Delete and Complete task Buttons are present on the right side of task list
    Run Keyword And Continue On Failure    Verify Edit Icon is Clickable and Functional    ${TC_E2E_011['priority']}
    Run Keyword And Continue On Failure    Verify the created task details    ${TC_E2E_011['taskupdateddetails']}
    Click Answers Tab
    Run Keyword And Continue On Failure    Select the Created Task    ${TC_E2E_011['taskdata']}
    Run Keyword And Continue On Failure    Verify Delete Icon is Clickable and Functional    ${TC_E2E_011['taskupdateddetails']}
    Run Keyword And Continue On Failure    Remove Document after Upload     @{TC_E2E_011['FileName']}
    Create New Mail    ${TC_E2E_011['emailData']}
    Run Keyword And Continue On Failure    Verify Email Sent Successfully
    Run Keyword And Continue On Failure    Verify Sent Email    ${TC_E2E_011['emailVerify']}
    Run Keyword And Continue On Failure    Save and verify mail in Draft    ${TC_E2E_011['emailData']} 
    Discard the Created Email    ${TC_E2E_011['emailData']}      
    Create New Mail With Missing Data    ${TC_E2E_011['emailData_Mising']}    ${TC_E2E_011['Expected_PopUp']}
    Upload SOV and Loss Run Documents    @{TC_E2E_011['FileName']}
    Wait for Upload to Complete for SOV and Loss Run    ${TC_E2E_011['stageNo']}
    Open uploaded SOV File   
    Run Keyword And Continue On Failure    Verify datas are matching for the uploaded SOV file    ${TC_E2E_003['SOVFile']}
    ${length}    Get Length    ${TC_E2E_003['dropdownOptions']}
    Run Keyword And Continue On Failure    Verify Properties datas for the given dropdown options    ${length}
    Run Keyword And Continue On Failure    Verify Claims Data From Loss Run File
    # Verify Policies Data From Loss Run File
    Run Keyword And Continue On Failure    Verify Analysis Data From Loss Run File    ${TC_E2E_011['CardName']}    ${TC_E2E_011['expectedAnalysisData']}    ${TC_E2E_011['expectedTableData']}
    # Verify Schema by downloading the json file
    Run Keyword And Continue On Failure    Verify WorkFlow History    ${TC_E2E_011['expectedWorkFlowHistory']}
    Save Submission And verify popup
    Run Keyword And Continue On Failure    Verify Submission updated in the Current Stage    ${TC_E2E_011['stageNo']}
    Run Keyword And Continue On Failure    Verify WorkFlow Options Advance Stage and Reject

TC_E2E_017
    [Tags]    E2E-WithoutSov    
    [Documentation]    End to End Testing for New Submission - (Quoted Stage)  with SOV and LR upload"
    # Create User If the User is not present    ${NewUser}
    # Select Impersonate option from the actions    ${NewUser['email']}    ${NewUser['search_user']}
    Run Keyword And Continue On Failure    Verify My Assignments Tab is displayed as a default tab
    Click All submissions option
    Select Submission using submission id    ${new_submission_id_1}    @{TC_E2E_017['SubmissionColumnNames']}
    Run Keyword And Continue On Failure    Verify Submission page is displayed
    Advance Stage    ${TC_E2E_017['stageNo']}
    Run Keyword And Continue On Failure    Verify Stage is updated in the submission    ${TC_E2E_017['stage']}
    Click Edit Submission
    Run Keyword And Continue On Failure    Verify Summary Menu is displayed
    Switch To Summary Tab    ${TC_E2E_017['SummaryHeader']}
    Run Keyword And Continue On Failure     Verify Policy Information In Summary Tab    ${TC_E2E_017['PolicyInfo']}   
    Run Keyword And Continue On Failure    Verify Summary Table Data    ${TC_E2E_017['SummaryTableHeader']}    ${TC_E2E_017['SummaryTableData']}
    Run Keyword And Continue On Failure    Verify the Workflow Reflected in Summary tab    ${TC_E2E_017['AdvanceTo']}
    Run Keyword And Continue On Failure    Verify Schema section is available in Documents Page
    Click Answers Tab
    Run Keyword And Continue On Failure    Complete Forms Tab Details Verification    ${TC_Forms_01}
    Run Keyword And Continue On Failure    Complete Forms Tab Details Filling    ${TC_Forms_02}
    Run Keyword And Continue On Failure    Complete Forms Tab Details Verification    ${TC_Forms_02}
    Click Answers Tab
    Run Keyword And Continue On Failure    Verify Answers Lists    ${TC_E2E_017['expectedQuestion']}
    Run Keyword And Continue On Failure    Verify Risk360 Card Pages Navigation    ${TC_E2E_017['Risk360_Card_Names']}    ${TC_E2E_017['Risk360_Card_Pages_Names']}
    Create New Task    ${TC_E2E_017['taskdata']}
    Run Keyword And Continue On Failure    Verify the created task details    ${TC_E2E_017['taskDetails']}
    Run Keyword And Continue On Failure    verify Edit Delete and Complete task Buttons are present on the right side of task list
    Run Keyword And Continue On Failure    Verify Edit Icon is Clickable and Functional    ${TC_E2E_017['priority']}
    Run Keyword And Continue On Failure    Verify the created task details    ${TC_E2E_017['taskupdateddetails']}
    Click Answers Tab
    Run Keyword And Continue On Failure    Select the Created Task    ${TC_E2E_017['taskdata']}
    Run Keyword And Continue On Failure    Verify Delete Icon is Clickable and Functional    ${TC_E2E_017['taskupdateddetails']}
    Run Keyword And Continue On Failure    Remove Document after Upload     @{TC_E2E_017['FileName']}
    Create New Mail    ${TC_E2E_017['emailData']}
    Run Keyword And Continue On Failure    Verify Email Sent Successfully
    Run Keyword And Continue On Failure    Verify Sent Email    ${TC_E2E_017['emailVerify']}
    Run Keyword And Continue On Failure    Save and verify mail in Draft    ${TC_E2E_017['emailData']} 
    Discard the Created Email    ${TC_E2E_017['emailData']}      
    Create New Mail With Missing Data    ${TC_E2E_017['emailData_Mising']}    ${TC_E2E_017['Expected_PopUp']}
    Upload SOV and Loss Run Documents    @{TC_E2E_017['FileName']}
    Wait for Upload to Complete for SOV and Loss Run    ${TC_E2E_017['stageNo']}
    Open uploaded SOV File   
    Run Keyword And Continue On Failure    Verify datas are matching for the uploaded SOV file    ${TC_E2E_003['SOVFile']}
    ${length}    Get Length    ${TC_E2E_003['dropdownOptions']}
    Run Keyword And Continue On Failure    Verify Properties datas for the given dropdown options    ${length}
    Run Keyword And Continue On Failure    Verify Claims Data From Loss Run File
    # Verify Policies Data From Loss Run File
    Run Keyword And Continue On Failure    Verify Analysis Data From Loss Run File    ${TC_E2E_017['CardName']}    ${TC_E2E_017['expectedAnalysisData']}    ${TC_E2E_017['expectedTableData']}
    # Verify Schema by downloading the json file
    Run Keyword And Continue On Failure    Verify WorkFlow History    ${TC_E2E_017['expectedWorkFlowHistory']}
    Save Submission And verify popup
    Run Keyword And Continue On Failure    Verify Submission updated in the Current Stage    ${TC_E2E_017['stageNo']}

TC_E2E_023
    [Tags]    E2E-WithoutSov
    [Documentation]    End to End Testing for New Submission - (Under Review stage + Child submission)  with SOV and LR upload"
    # Create User If the User is not present    ${NewUser}
    # Select Impersonate option from the actions    ${NewUser['email']}    ${NewUser['search_user']}
    Run Keyword And Continue On Failure    Verify My Assignments Tab is displayed as a default tab
    Click All submissions option
    Select Submission using submission id    ${new_submission_id_1}    @{TC_E2E_017['SubmissionColumnNames']}
    Run Keyword And Continue On Failure    Verify Submission page is displayed
    #  Run Pre-requiste for Step 1 2 3 & 4
    Advance Stage    ${TC_E2E_023['stageNo']}
    Run Keyword And Continue On Failure    Verify Stage is updated in the submission    ${TC_E2E_023['stage']}
    Run Keyword And Continue On Failure    Verify Summary Menu is displayed
    Click Edit Submission
    Run Keyword And Continue On Failure    Verify All Side menu options are Displayed
    Run Keyword And Continue On Failure    Verify Policy PDF is Generated and Available in Documents Tab    ${TC_E2E_023['PolicyInfo']}
    Switch to Summary
    # Run Keyword And Continue On Failure    verify Header Displayed    ${TC_E2E_023['stage']}    ${TC_E2E_023['Tab_Name']}
    Run Keyword And Continue On Failure    Verify Summary Table Data    ${TC_E2E_011['SummaryTableHeader']}    ${TC_E2E_023['SummaryTableData']}
    Run Keyword And Continue On Failure    Verify Policy Information Details from Summary Tab    ${TC_E2E_017['PolicyInfo']}    ${TC_Forms_01}    
    Run Keyword And Continue On Failure    Enter the Policy Information    ${TC_E2E_023['PolicyInfo']}
    #  Verify the Workflow in Summary Tab
    #Issue: The Child Submission in the Summary Tab is not stable.
    #Impact: We are unable to verify if the dependent child is displayed/present as expected
    Run Keyword And Continue On Failure    Verify Child Submission Should be Displayed in Summary Tab    ${TC_E2E_017['product']}
    Run Keyword And Continue On Failure    verify Account History are editable    ${new_submission_id_1}    ${TC_E2E_024['stage']}    ${TC_E2E_023['PolicyInfo']} 
    # Step No 11 to 13[Forms Verification Pending, Changes need to be done]
       #Complete Forms Tab Details Filling    ${TC_Forms_01}
    Click Answers Tab
    Run Keyword And Continue On Failure    Complete Forms Tab Details Verification    ${TC_Forms_02}
    Run Keyword And Continue On Failure    Complete Forms Tab Details Filling    ${TC_Forms_01}
    Run Keyword And Continue On Failure    Complete Forms Tab Details Verification    ${TC_Forms_01}
    Click and verify Clearance tab
    #  Answer Tab
    Click Answers Tab
    Run Keyword And Continue On Failure    Verify Answers Lists    ${TC_E2E_008['expectedQuestion']}
    # Risk360 Tab
    Run Keyword And Continue On Failure    Verify Company Website Link    ${TC_E2E_008['expectedTitle']}
    Run Keyword And Continue On Failure    Verify Risk360 Card Pages Navigation    ${TC_E2E_008['Risk360_Card_Names']}    ${TC_E2E_008['Risk360_Card_Pages_Names']}
    # Task tab
    Create New Task    ${TC_E2E_024['taskdata']}
    Run Keyword And Continue On Failure    Select the Created Task    ${TC_E2E_024['taskdata']}
    Run Keyword And Continue On Failure    Verify the created task details    ${TC_E2E_024['taskDetails']}
    Run Keyword And Continue On Failure    verify Edit Delete and Complete task Buttons are present on the right side of task list
    Run Keyword And Continue On Failure    Verify Edit Icon is Clickable and Functional    ${TC_E2E_024['priority']}
    Run Keyword And Continue On Failure    Verify the created task details    ${TC_E2E_024['taskupdateddetails']}
    Click Answers Tab
    Run Keyword And Continue On Failure    Select the Created Task    ${TC_E2E_024['taskdata']}
    Run Keyword And Continue On Failure    Verify Delete Icon is Clickable and Functional    ${TC_E2E_024['taskupdateddetails']}
    #Email Tab
    Run Keyword And Continue On Failure    Verify Discard Button visible    ${TC_Email_001['DraftemailData']}
    Save and verify mail in Draft    ${TC_Email_001['DraftemailData']}
    Create New Mail With Missing Data    ${TC_Email_001['emailData_Mising']}    ${TC_Email_001['Expected_PopUp']}
    # Document Tab
    Upload SOV and Loss Run Documents    @{TC_E2E_022['FileName']}
    Wait for Upload to Complete for SOV and Loss Run    ${TC_E2E_023['stageNo']}
    Open uploaded SOV File
    Run Keyword And Continue On Failure    Verify datas are matching for the uploaded SOV file    ${TC_E2E_022['SOVFile']}
    ${length}    Get Length    ${TC_E2E_003['dropdownOptions']}
    Run Keyword And Continue On Failure    Verify Properties datas for the given dropdown options    ${length}
    Run Keyword And Continue On Failure    Verify Claims Data From Loss Run File
    Run Keyword And Continue On Failure    Verify Policies Data From Loss Run File
    Run Keyword And Continue On Failure    Verify Analysis Data From Loss Run File    ${TC_E2E_022['CardName']}    ${TC_E2E_022['expectedAnalysisData']}    ${TC_E2E_022['expectedTableData']}
    #Clearance Tab--Verification
    Run Keyword And Continue On Failure    verify Clearance Tab    ${TC_E2E_023['ProductName']}
    #WorkFlow History ----Integration needed for execution ,
    Run Keyword And Continue On Failure    Verify WorkFlow History    ${TC_E2E_023['expectedWorkFlowHistory']}
    Save Submission And verify popup
    Run Keyword And Continue On Failure    Verify Submission updated in the Current Stage    ${TC_E2E_023['stageNo']}

TC_E2E_024
    [Tags]    E2E-WithoutSov
    [Documentation]    End to End Testing for New Submission - (Under Review stage + Child submission)  with SOV and LR upload"
    Create User If the User is not present    ${NewUser}
    Select Impersonate option from the actions    ${NewUser['email']}    ${NewUser['search_user']}
    Run Keyword And Continue On Failure    Verify My Assignments Tab is displayed as a default tab
    Click All submissions option
    Select Submission using submission id    ${new_submission_id_1}    @{TC_E2E_017['SubmissionColumnNames']}
    Run Keyword And Continue On Failure    Verify Submission page is displayed
    Advance Stage    ${TC_E2E_024['stageNo']}
    Run Keyword And Continue On Failure    Verify Stage is updated in the submission    ${TC_E2E_024['stage']}
    Run Keyword And Continue On Failure    Verify Summary Menu is displayed
    Click Edit Submission
    Run Keyword And Continue On Failure    Verify All Side menu options are Displayed
    Run Keyword And Continue On Failure    Verify Policy PDF is Generated and Available in Documents Tab    ${TC_E2E_024['PolicyInfo']}
    Switch to Summary
    # Run Keyword And Continue On Failure    verify Header Displayed    ${TC_E2E_024['stage']}    ${TC_E2E_024['Tab_Name']}
    Run Keyword And Continue On Failure    Verify Summary Table Data    ${TC_E2E_011['SummaryTableHeader']}    ${TC_E2E_024['SummaryTableData']}
    Run Keyword And Continue On Failure    Verify Policy Information Details from Summary Tab    ${TC_E2E_017['PolicyInfo']}    ${TC_Forms_01}    
    Run Keyword And Continue On Failure    Enter the Policy Information    ${TC_E2E_024['PolicyInfo']}
    #Issue: The Child Submission in the Summary Tab is not stable.
    #Impact: We are unable to verify if the dependent child is displayed/present as expected
    Run Keyword And Continue On Failure    Verify Child Submission Should be Displayed in Summary Tab    ${TC_E2E_017['product']}
    Run Keyword And Continue On Failure    verify Account History are editable    ${new_submission_id_1}    ${TC_E2E_024['stage']}    ${TC_E2E_024['PolicyInfo']}
    # Step No 11 to 13[Forms Verification Pending, Changes need to be done]
    Click Answers Tab
    Run Keyword And Continue On Failure    Complete Forms Tab Details Verification    ${TC_Forms_01}
    Run Keyword And Continue On Failure    Complete Forms Tab Details Filling    ${TC_Forms_02}
    Run Keyword And Continue On Failure    Complete Forms Tab Details Verification    ${TC_Forms_02}
    Run Keyword And Continue On Failure    Click and verify Clearance tab
    #  Answer Tab
    Click Answers Tab
    Run Keyword And Continue On Failure    Verify Answers Lists    ${TC_E2E_024['expectedQuestion']}
    # Risk360 Tab
    Run Keyword And Continue On Failure    Verify Company Website Link    ${TC_E2E_024['expectedTitle']}
    Run Keyword And Continue On Failure    Verify Risk360 Card Pages Navigation    ${TC_E2E_024['Risk360_Card_Names']}    ${TC_E2E_024['Risk360_Card_Pages_Names']}
    # Task tab
    Create New Task    ${TC_E2E_024['taskdata']}
    Run Keyword And Continue On Failure    Select the Created Task    ${TC_E2E_024['taskdata']}
    Run Keyword And Continue On Failure    Verify the created task details    ${TC_E2E_024['taskDetails']}
    Run Keyword And Continue On Failure    verify Edit Delete and Complete task Buttons are present on the right side of task list
    Run Keyword And Continue On Failure    Verify Edit Icon is Clickable and Functional    ${TC_E2E_024['priority']}
    Run Keyword And Continue On Failure    Verify the created task details    ${TC_E2E_024['taskupdateddetails']}
    Click Answers Tab
    Run Keyword And Continue On Failure    Select the Created Task    ${TC_E2E_024['taskdata']}
    Run Keyword And Continue On Failure    Verify Delete Icon is Clickable and Functional    ${TC_E2E_024['taskupdateddetails']}
    #Email Tab
    Run Keyword And Continue On Failure    Verify Discard Button visible    ${TC_Email_001['DraftemailData']}
    Save and verify mail in Draft    ${TC_Email_001['DraftemailData']}
    Create New Mail With Missing Data    ${TC_Email_001['emailData_Mising']}    ${TC_Email_001['Expected_PopUp']}
    # Document Tab
    Upload SOV and Loss Run Documents    @{TC_E2E_022['FileName']}
    Wait for Upload to Complete for SOV and Loss Run    ${TC_E2E_024['stageNo']}
    Open uploaded SOV File  
    Run Keyword And Continue On Failure    Verify datas are matching for the uploaded SOV file    ${TC_E2E_022['SOVFile']}
    ${length}    Get Length    ${TC_E2E_003['dropdownOptions']}
    Run Keyword And Continue On Failure    Verify Properties datas for the given dropdown options    ${length}
    Run Keyword And Continue On Failure    Verify Claims Data From Loss Run File
    Run Keyword And Continue On Failure    Verify Policies Data From Loss Run File
    Run Keyword And Continue On Failure    Verify Analysis Data From Loss Run File    ${TC_E2E_022['CardName']}    ${TC_E2E_022['expectedAnalysisData']}    ${TC_E2E_022['expectedTableData']}
    #Clearance Tab--Verification
    Run Keyword And Continue On Failure    verify Clearance Tab    ${TC_E2E_024['ProductName']}
    #WorkFlow History ----Integration needed for execution ,
    Run Keyword And Continue On Failure    Verify WorkFlow History    ${TC_E2E_024['expectedWorkFlowHistory']}
    Save Submission And verify popup
    Run Keyword And Continue On Failure    Verify Submission updated in the Current Stage    ${TC_E2E_024['stageNo']}

TC_E2E_025
    [Tags]    E2E-WithoutSov
    [Documentation]    End to End Testing for New Submission - (Under Review stage + Child submission)  with SOV and LR upload"
    Create User If the User is not present    ${NewUser}
    Select Impersonate option from the actions    ${NewUser['email']}    ${NewUser['search_user']}
    Run Keyword And Continue On Failure    Verify My Assignments Tab is displayed as a default tab
    Click All submissions option
    Select Submission using submission id    ${new_submission_id_1}    @{TC_E2E_017['SubmissionColumnNames']}
    Run Keyword And Continue On Failure    Verify Submission page is displayed
    # Run Pre-requiste for Step 1 2 3 & 4
    Advance Stage    ${TC_E2E_025['stageNo']} 
    Run Keyword And Continue On Failure    Verify Stage is updated in the submission    ${TC_E2E_025['stage']}
    # Task Tab
    Click Answers Tab
    Wait For Elements State    ${TaskClick}    visible
    Click    ${TaskClick}
    Run Keyword And Continue On Failure    Verify the auto generated task details    ${TC_E2E_025['taskDetails1']}
    Run Keyword And Continue On Failure    Complete Task with the given reason for Booking stage    ${TC_E2E_025['taskreason']}
    Run Keyword And Continue On Failure    Verify the task is completed and sanction label is appears as per the reason for booking    ${TC_E2E_025['taskreason']}
    Run Keyword And Continue On Failure    Click Edit Submission
    Run Keyword And Continue On Failure    Verify All Side menu options are Displayed
    Run Keyword And Continue On Failure    Verify Policy PDF is Generated and Available in Documents Tab    ${TC_E2E_024['PolicyInfo']}
    Run Keyword And Continue On Failure    Switch to Summary
    # Run Keyword And Continue On Failure    verify Header Displayed    ${TC_E2E_025['stage']}    ${TC_E2E_025['Tab_Name']}
    Run Keyword And Continue On Failure    Verify Summary Table Data    ${TC_E2E_011['SummaryTableHeader']}    ${TC_E2E_025['SummaryTableData']}
    Run Keyword And Continue On Failure    Verify Policy Information Details from Summary Tab    ${TC_E2E_017['PolicyInfo']}    ${TC_Forms_01}    
    Run Keyword And Continue On Failure    Enter the Policy Information    ${TC_E2E_025['PolicyInfo']}
    Run Keyword And Continue On Failure    verify the entered Policy Information    ${TC_E2E_025['PolicyInfo']}
    Run Keyword And Continue On Failure    Verify Child Submission Should be Displayed in Summary Tab    ${TC_E2E_017['product']}
    Run Keyword And Continue On Failure    verify Account History are editable    ${new_submission_id_1}    ${TC_E2E_024['stage']}    ${TC_E2E_025['PolicyInfo']} 
    # Step No 11 to 13[Forms Verification Pending, Changes need to be done]
    Click Answers Tab
    Run Keyword And Continue On Failure    Complete Forms Tab Details Verification    ${TC_Forms_02}
    Run Keyword And Continue On Failure    Complete Forms Tab Details Filling    ${TC_Forms_01}
    Run Keyword And Continue On Failure    Complete Forms Tab Details Verification    ${TC_Forms_01}
    #  Answer Tab
    Click Answers Tab
    Run Keyword And Continue On Failure    Verify Answers Lists    ${TC_E2E_025['expectedQuestion']}
    # Risk360 Tab
    Run Keyword And Continue On Failure    Verify Company Website Link    ${TC_E2E_025['expectedTitle']}
    Run Keyword And Continue On Failure    Verify Risk360 Card Pages Navigation    ${TC_E2E_025['Risk360_Card_Names']}    ${TC_E2E_025['Risk360_Card_Pages_Names']}
    # Task tab
    Run Keyword And Continue On Failure    Create New Task    ${TC_E2E_025['taskdata']}
    Run Keyword And Continue On Failure    Select the Created Task    ${TC_E2E_025['taskdata']}
    Run Keyword And Continue On Failure    Verify the created task details    ${TC_E2E_025['taskDetails']}
    Run Keyword And Continue On Failure    verify Edit Delete and Complete task Buttons are present on the right side of task list
    Run Keyword And Continue On Failure    Verify Edit Icon is Clickable and Functional    ${TC_E2E_025['priority']}
    Run Keyword And Continue On Failure    Verify the created task details    ${TC_E2E_025['taskupdateddetails']}
    Click Answers Tab
    Run Keyword And Continue On Failure    Select the Created Task    ${TC_E2E_025['taskdata']}
    Run Keyword And Continue On Failure    Verify Delete Icon is Clickable and Functional    ${TC_E2E_025['taskupdateddetails']} 
    #Email Tab 
    Run Keyword And Continue On Failure    Verify Discard Button visible    ${TC_E2E_025['DraftemailData']}
    Run Keyword And Continue On Failure    Save and verify mail in Draft    ${TC_E2E_025['DraftemailData']}
    Run Keyword And Continue On Failure    Create New Mail With Missing Data    ${TC_E2E_025['emailData_Mising']}    ${TC_Email_001['Expected_PopUp']}
    # Document Tab
    Run Keyword And Continue On Failure    Upload SOV and Loss Run Documents    @{TC_E2E_022['FileName']}
    Run Keyword And Continue On Failure    Wait for Upload to Complete for SOV and Loss Run    ${TC_E2E_025['stageNo']}
    Run Keyword And Continue On Failure    Open uploaded SOV File   
    Run Keyword And Continue On Failure    Verify datas are matching for the uploaded SOV file    ${TC_E2E_022['SOVFile']}
    ${length}    Get Length    ${TC_E2E_003['dropdownOptions']}
    Run Keyword And Continue On Failure    Verify Properties datas for the given dropdown options    ${length}
    Run Keyword And Continue On Failure    Verify Claims Data From Loss Run File
    Run Keyword And Continue On Failure    Verify Policies Data From Loss Run File
    Run Keyword And Continue On Failure    Verify Analysis Data From Loss Run File    ${TC_E2E_022['CardName']}    ${TC_E2E_022['expectedAnalysisData']}    ${TC_E2E_022['expectedTableData']}
   #Clearance Tab--Verification
    Run Keyword And Continue On Failure    verify Clearance Tab    ${TC_E2E_025['ProductName']} 
    Run Keyword And Continue On Failure    Verify WorkFlow History    ${TC_E2E_025['expectedWorkFlowHistory']}
    Save Submission And verify popup
    Run Keyword And Continue On Failure    Verify Submission updated in the Current Stage    ${TC_E2E_025['stageNo']}

TC_E2E_026
    [Tags]    E2E-WithoutSov
    [Documentation]    End to End Testing for New Submission - (Under Review stage + Child submission)  with SOV and LR upload"
    Create User If the User is not present    ${NewUser}
    Select Impersonate option from the actions    ${NewUser['email']}    ${NewUser['search_user']}
    Run Keyword And Continue On Failure    Verify My Assignments Tab is displayed as a default tab
    Click All submissions option
    Select Submission using submission id    ${new_submission_id_1}    @{TC_E2E_017['SubmissionColumnNames']}
    Run Keyword And Continue On Failure    Verify Submission page is displayed
    Advance Stage    ${TC_E2E_026['stageNo']}
    Run Keyword And Continue On Failure    Verify Stage is updated in the submission    ${TC_E2E_026['stage']}
    Click Edit Submission
    Verify Summary Menu is displayed
    Run Keyword And Continue On Failure    Verify All Side menu options are Displayed
    Run Keyword And Continue On Failure    Verify Policy PDF is Generated and Available in Documents Tab    ${TC_E2E_025['PolicyInfo']}
    Run Keyword And Continue On Failure    Switch to Summary
    # Run Keyword And Continue On Failure    verify Header Displayed    ${TC_E2E_026['stage']}    ${TC_E2E_026['Tab_Name']}
    Run Keyword And Continue On Failure    Verify Summary Table Data    ${TC_E2E_026['SummaryTableHeader']}    ${TC_E2E_026['SummaryTableData']}
    Run Keyword And Continue On Failure    Verify Policy Information Details from Summary Tab    ${TC_E2E_026['PolicyInfo']}    ${TC_Forms_01}    
    Run Keyword And Continue On Failure    Enter the Policy Information    ${TC_E2E_026['PolicyInfo']}
    Run Keyword And Continue On Failure    verify the entered Policy Information    ${TC_E2E_026['PolicyInfo']}
    Run Keyword And Continue On Failure    Verify Child Submission Should be Displayed in Summary Tab    ${TC_E2E_017['product']}
    Run Keyword And Continue On Failure    verify Account History are editable    ${new_submission_id_1}    ${TC_E2E_026['stage']}    ${TC_E2E_026['PolicyInfo']} 
    #  Answer Tab
    Click Answers Tab
    Run Keyword And Continue On Failure    Verify Answers Lists    ${TC_E2E_026['expectedQuestion']}
    Run Keyword And Continue On Failure    Complete Forms Tab Details Verification    ${TC_Forms_01}
    Run Keyword And Continue On Failure    Complete Forms Tab Details Filling    ${TC_Forms_02}
    Run Keyword And Continue On Failure    Complete Forms Tab Details Verification    ${TC_Forms_02}
    Click Answers Tab
    # Risk360 Tab
    Run Keyword And Continue On Failure    Verify Company Website Link    ${TC_E2E_026['expectedTitle']}
    Run Keyword And Continue On Failure    Verify Risk360 Card Pages Navigation    ${TC_E2E_026['Risk360_Card_Names']}    ${TC_E2E_026['Risk360_Card_Pages_Names']}
   # Task tab
    Click Answers Tab
    Run Keyword And Continue On Failure    Create New Task    ${TC_E2E_026['taskdata']}
    Run Keyword And Continue On Failure    Select the Created Task    ${TC_E2E_026['taskdata']}
    Run Keyword And Continue On Failure    Verify the created task details    ${TC_E2E_026['taskDetails']}
    Run Keyword And Continue On Failure    verify Edit Delete and Complete task Buttons are present on the right side of task list
    Run Keyword And Continue On Failure    Verify Edit Icon is Clickable and Functional    ${TC_E2E_026['priority']}
    Run Keyword And Continue On Failure    Verify the created task details    ${TC_E2E_026['taskupdateddetails']}
    Click Answers Tab
    Run Keyword And Continue On Failure    Select the Created Task    ${TC_E2E_026['taskdata']}
    Run Keyword And Continue On Failure    Verify Delete Icon is Clickable and Functional    ${TC_E2E_026['taskupdateddetails']}
    #Email Tab
    Run Keyword And Continue On Failure    Verify Discard Button visible    ${TC_E2E_026['DraftemailData']}
    Run Keyword And Continue On Failure    Save and verify mail in Draft    ${TC_E2E_026['DraftemailData']}
    Run Keyword And Continue On Failure    Create New Mail With Missing Data    ${TC_E2E_026['emailData_Mising']}    ${TC_E2E_026['Expected_PopUp']}
    # Document Tab
    Run Keyword And Continue On Failure    Upload SOV and Loss Run Documents    @{TC_E2E_022['FileName']}
    Run Keyword And Continue On Failure    Wait for Upload to Complete for SOV and Loss Run    ${TC_E2E_026['stageNo']}
    Run Keyword And Continue On Failure    Open uploaded SOV File   
    Run Keyword And Continue On Failure    Verify datas are matching for the uploaded SOV file    ${TC_E2E_022['SOVFile']}
    ${length}    Get Length    ${TC_E2E_003['dropdownOptions']}
    Run Keyword And Continue On Failure    Verify Properties datas for the given dropdown options    ${length}
    Run Keyword And Continue On Failure    Verify Claims Data From Loss Run File
    Run Keyword And Continue On Failure    Verify Policies Data From Loss Run File
    Run Keyword And Continue On Failure    Verify Analysis Data From Loss Run File    ${TC_E2E_022['CardName']}    ${TC_E2E_022['expectedAnalysisData']}    ${TC_E2E_022['expectedTableData']}  
    # clearance tab
    Run Keyword And Continue On Failure    verify Clearance Tab    ${TC_E2E_026['ProductName']}
    Run Keyword And Continue On Failure    Verify WorkFlow History    ${TC_E2E_026['expectedWorkFlowHistory']}
    Run Keyword And Continue On Failure    Save Submission And verify popup
    Run Keyword And Continue On Failure    Verify Advance Stage is InActive

TC_E2E_002
    [Tags]    E2E-Reject
    [Documentation]    End to End Testing for Reject Submission - In Draft Stage: This stage is primarily for Submission Clearance process
    Create User If the User is not present    ${NewUser}
    Select Impersonate option from the actions    ${NewUser['email']}    ${NewUser['search_user']}
    Run Keyword And Continue On Failure    Verify My Assignments Tab is displayed as a default tab
    ${submission_id}    Create New Submission    ${TC_E2E_002['FileName']}    @{TC_E2E_002['SubmissionColumnNames']}
    Set Suite Variable   ${submission_id_reject}    ${submission_id}
    Select Submission using submission id    ${submission_id}    @{TC_E2E_002['SubmissionColumnNames']}
    Run Keyword And Continue On Failure    Verify Submission page is displayed
    Click Edit Submission
    Run Keyword And Continue On Failure    Click and verify Clearance tab
    Click Insured Tab
    Run Keyword And Continue On Failure    Verify PDF Data in Insured Tab    @{TC_E2E_002['expectedPDFText']}
    Fill the data for issue fields    ${TC_E2E_002['SicCode']}    ${TC_E2E_002['SicDescription']}    ${TC_E2E_002['NAICSCode']}
    Run Keyword And Continue On Failure    Verify User Mod is message for updated fields
    Click Processing Tab
    Fill the data for issue fields in processing    ${TC_E2E_002['UnderwriterName']}    ${TC_E2E_002['UnderwriterEmail']}    ${TC_E2E_002['OperationsName']}      
    ...    ${TC_E2E_002['OperationsEmail']}    ${TC_E2E_002['UnderwrittingOffice']}    ${TC_E2E_002['Channel']}
    Click Producer Tab
    Run Keyword And Continue On Failure    Verify PDF Data in Producer Tab    @{TC_E2E_002['expectedTextInProducer']}
    Fill the data for issues field in Producer    ${TC_E2E_002['ProducerName']}      ${TC_E2E_002['ProducerEmail']}
    Click Coverage Tab
    Run Keyword And Continue On Failure    Verify the Coverage data    ${TC_E2E_002['EffectiveDate']}     ${TC_E2E_002['ExpirationDate']}     ${TC_E2E_002['Product']}
    Fill the data for issues field in Coverage    ${TC_E2E_002['Covered']}
    Click Issues Tab
     @{expectedIssues}    Create List    ${TC_E2E_002['SicCode']}    ${TC_E2E_002['SicDescription']} 
     ...    ${TC_E2E_002['NAICSCode']}    ${TC_E2E_002['UnderwriterName']}    ${TC_E2E_002['UnderwriterEmail']} 
     ...    ${TC_E2E_002['UnderwrittingOffice']}     ${TC_E2E_002['OperationsName']}    ${TC_E2E_002['OperationsEmail']}    ${TC_E2E_002['Channel']}    ${TC_E2E_002['ProducerName']}
    Run Keyword And Continue On Failure    Verify updated datas in Issues Tab    @{expectedIssues}
    Click Finish Tab
    Run Keyword And Continue On Failure    Verify and click the save and close button
    Switch to Documents
     @{expectedModification}    Create List    "${TC_E2E_002['SicCode']}"    "${TC_E2E_002['SicDescription']}"  
     ...    "${TC_E2E_002['NAICSCode']}"    "${TC_E2E_002['UnderwriterName']}"    "${TC_E2E_002['UnderwriterEmail']}"   
     ...    "${TC_E2E_002['UnderwrittingOffice']}"     "${TC_E2E_002['OperationsName']}"    "${TC_E2E_002['OperationsEmail']}"    "${TC_E2E_002['Channel']}"   
     ...    "${TC_E2E_002['ProducerName']}"    "${TC_E2E_002['ProducerEmail']}"    "${TC_E2E_002['Covered']['Product']}"    "${TC_E2E_002['Covered']['ProductSegment']}" 
    Run Keyword And Continue On Failure    Verify datas in UserModification file    @{expectedModification}
    Run Keyword And Continue On Failure    Verify WorkFlow Options Advance Stage and Reject
    Reject Submission and Verify the Tag name    ${TC_E2E_002['FailureReasons']}    ${TC_E2E_002['FailureDetails']}    ${TC_E2E_002['Action']}
    Run Keyword And Continue On Failure    Verify WorkFlow History for Rejection    ${TC_E2E_002['WorkFlowHistory']}
    Reactive the Rejected Submission
    Save Submission And verify popup
    Run Keyword And Continue On Failure    Verify Submission updated

TC_E2E_009
    [Tags]    E2E-Reject
    [Documentation]    End to End Testing for New Submission - (Cleared to Under Review Stage) with Reject & Reactivate"
    Create User If the User is not present    ${NewUser}
    Select Impersonate option from the actions    ${NewUser['email']}    ${NewUser['search_user']}
    Run Keyword And Continue On Failure    Verify My Assignments Tab is displayed as a default tab
    Click All submissions option
    Select Submission using submission id    ${submission_id_reject}    @{TC_E2E_009['SubmissionColumnNames']}
    Run Keyword And Continue On Failure    Verify Submission page is displayed
    Advance Stage 2
    Run Keyword And Continue On Failure    Verify Stage is updated in the submission    ${TC_E2E_009['stage']}
    Click Edit Submission
    Click Answers Tab
    Run Keyword And Continue On Failure    Verify Answers Lists    ${TC_E2E_009['expectedQuestion']}
    Run Keyword And Continue On Failure    Verify Company Website Link    ${TC_E2E_009['expectedTitle']}
    Run Keyword And Continue On Failure    Verify Risk360 Card Pages Navigation    ${TC_E2E_009['Risk360_Card_Names']}    ${TC_E2E_009['Risk360_Card_Pages_Names']}
    Create New Task    ${TC_E2E_009['taskdata']}
    Run Keyword And Continue On Failure    Verify the created task details    ${TC_E2E_009['taskDetails']}
    Create New Mail    ${TC_E2E_009['emailData']}
    Run Keyword And Continue On Failure    Verify Email Sent Successfully
    Run Keyword And Continue On Failure    Verify Sent Email    ${TC_E2E_009['emailVerify']}
    Upload SOV and Loss Run Documents    @{TC_E2E_009['FileName']}
    Wait for Upload to Complete
    Open uploaded SOV File   
    Run Keyword And Continue On Failure    Verify datas are matching for the uploaded SOV file    ${TC_E2E_003['SOVFile']}
    ${length}    Get Length    ${TC_E2E_003['dropdownOptions']}
    Run Keyword And Continue On Failure    Verify Properties datas for the given dropdown options    ${length}
    Run Keyword And Continue On Failure    Verify Claims Data From Loss Run File
    # Verify Policies Data From Loss Run File
    Run Keyword And Continue On Failure    Verify Analysis Data From Loss Run File    ${TC_E2E_009['CardName']}    ${TC_E2E_009['expectedAnalysisData']}    ${TC_E2E_009['expectedTableData']}
    # Verify Schema by downloading the json file
    Run Keyword And Continue On Failure    Verify WorkFlow History    ${TC_E2E_009['expectedWorkFlowHistory']}
    Run Keyword And Continue On Failure    Reject Submission and Verify the Tag name    ${TC_E2E_002['FailureReasons']}    ${TC_E2E_002['FailureDetails']}    ${TC_E2E_002['Action']}
    Reactive the Rejected Submission
    Run Keyword And Continue On Failure    Save Submission And verify popup
    Run Keyword And Continue On Failure    Verify Submission updated in Stage 2
    Run Keyword And Continue On Failure    Verify WorkFlow Options Advance Stage and Reject

TC_E2E_013
    [Tags]    E2E-Reject
    [Documentation]    End to End Testing for New Submission - (Under Review stage + Child submission)  Reject and Reactivate Submission"
    Create User If the User is not present    ${NewUser}
    Select Impersonate option from the actions    ${NewUser['email']}    ${NewUser['search_user']}
    Run Keyword And Continue On Failure    Verify My Assignments Tab is displayed as a default tab
    Click All submissions option
    Select Submission using submission id    ${submission_id_reject}    @{TC_E2E_013['SubmissionColumnNames']}
    Run Keyword And Continue On Failure    Verify Submission page is displayed
    Advance Stage    ${TC_E2E_013['stageNo']}    
    Run Keyword And Continue On Failure    Verify Stage is updated in the submission    ${TC_E2E_013['stage']}
    Click Edit Submission
    Click and verify Clearance tab
    Create Child Submission    ${TC_E2E_013['productName']}
    Wait For Processing Stage    ${TC_E2E_013['stageNo']}
    ${newSubmissionID}    Get New Submission ID After Child Submission
    Set Suite Variable    ${new_submission_id_reject}   ${newSubmissionID}  
    Navigate To All Submissions page from submissions 
    Select Submission using submission id    ${new_submission_id_reject}    @{TC_E2E_013['SubmissionColumnNames']}
    Wait For Processing Stage    ${TC_E2E_013['stageNo']}
    Run Keyword And Continue On Failure    Verify Summary Menu is displayed
    Switch To Summary Tab    ${TC_E2E_013['SummaryHeader']}
    Run Keyword And Continue On Failure    Verify Premium Amount    
    Run Keyword And Continue On Failure    Verify Summary Table Data    ${TC_E2E_013['SummaryTableHeader']}    ${TC_E2E_013['SummaryTableData']}
    Click Answers Tab
    Click Edit Submission
    Run Keyword And Continue On Failure    Verify Answers Lists    ${TC_E2E_013['expectedQuestion']}
    Run Keyword And Continue On Failure    Verify Risk360 Card Pages Navigation    ${TC_E2E_013['Risk360_Card_Names']}    ${TC_E2E_013['Risk360_Card_Pages_Names']}
    Create New Task    ${TC_E2E_013['taskdata']}
    Run Keyword And Continue On Failure    Verify the created task details    ${TC_E2E_013['taskDetails']}
    Create New Mail    ${TC_E2E_013['emailData']}
    Run Keyword And Continue On Failure    Verify Email Sent Successfully
    Run Keyword And Continue On Failure    Verify Sent Email    ${TC_E2E_013['emailVerify']}
    Upload SOV and Loss Run Documents    @{TC_E2E_013['FileName']}
    Wait for Upload to Complete for SOV and Loss Run    ${TC_E2E_013['stageNo']}
    Open uploaded SOV File   
    Run Keyword And Continue On Failure    Verify datas are matching for the uploaded SOV file    ${TC_E2E_003['SOVFile']}
    ${length}    Get Length    ${TC_E2E_003['dropdownOptions']}
    Run Keyword And Continue On Failure    Verify Properties datas for the given dropdown options    ${length}
    Run Keyword And Continue On Failure    Verify Claims Data From Loss Run File
    # Verify Policies Data From Loss Run File
    Run Keyword And Continue On Failure    Verify Analysis Data From Loss Run File    ${TC_E2E_013['CardName']}    ${TC_E2E_013['expectedAnalysisData']}    ${TC_E2E_013['expectedTableData']}
    # Verify Schema by downloading the json file
    Run Keyword And Continue On Failure    Verify WorkFlow History    ${TC_E2E_013['expectedWorkFlowHistory']}
    Reject Submission and Verify the Tag name    ${TC_E2E_002['FailureReasons']}    ${TC_E2E_002['FailureDetails']}    ${TC_E2E_002['Action']}
    Reactive the Rejected Submission
    Save Submission And verify popup
    Run Keyword And Continue On Failure    Verify Submission updated in the Current Stage    ${TC_E2E_013['stageNo']}
    Run Keyword And Continue On Failure    Verify WorkFlow Options Advance Stage and Reject

TC_E2E_003
    [Tags]    E2E-WithSov
     [Documentation]    End to End Testing for New Submission - In Draft Stage: SOV Losss run
    Create User If the User is not present    ${NewUser}
    Select Impersonate option from the actions    ${NewUser['email']}    ${NewUser['search_user']}
    Run Keyword And Continue On Failure    Verify My Assignments Tab is displayed as a default tab
   ${submission_id}    Create new submission with SOV and Loss run    ${TC_E2E_003['FileName']}    @{TC_E2E_003['SubmissionColumnNames']}
   Set Suite Variable   ${submission_id_sov}    ${submission_id}
    Select Submission using submission id   ${submission_id}    @{TC_E2E_003['SubmissionColumnNames']}
    Run Keyword And Continue On Failure    Verify Submission page is displayed
   Click Edit Submission
   Run Keyword And Continue On Failure    Click and verify Clearance tab
   Click Insured Tab
   Run Keyword And Continue On Failure    Verify PDF Data in Insured Tab    @{TC_E2E_003['expectedPDFText']}
   Fill the data for issue fields    ${TC_E2E_003['SicCode']}    ${TC_E2E_003['SicDescription']}    ${TC_E2E_003['NAICSCode']}
   Run Keyword And Continue On Failure    Verify User Mod is message for updated fields
   Click Processing Tab
    Fill the data for issue fields in processing    ${TC_E2E_003['UnderwriterName']}    ${TC_E2E_003['UnderwriterEmail']}    ${TC_E2E_003['OperationsName']}      
    ...    ${TC_E2E_003['OperationsEmail']}    ${TC_E2E_003['UnderwrittingOffice']}    ${TC_E2E_003['Channel']}
   Click Producer Tab
   Run Keyword And Continue On Failure    Verify PDF Data in Producer Tab    @{TC_E2E_003['expectedTextInProducer']}
   Fill the data for issues field in Producer    ${TC_E2E_003['ProducerName']}      ${TC_E2E_003['ProducerEmail']}
   Click Coverage Tab
   Run Keyword And Continue On Failure    Verify the Coverage data    ${TC_E2E_003['EffectiveDate']}     ${TC_E2E_003['ExpirationDate']}     ${TC_E2E_003['Product']}
    Fill the data for issues field in Coverage    ${TC_E2E_003['Covered']}
   Click Issues Tab
   @{expectedIssues}    Create List    ${TC_E2E_003['SicCode']}    ${TC_E2E_003['SicDescription']} 
     ...    ${TC_E2E_003['NAICSCode']}    ${TC_E2E_003['UnderwriterName']}    ${TC_E2E_003['UnderwriterEmail']} 
     ...    ${TC_E2E_003['UnderwrittingOffice']}     ${TC_E2E_003['OperationsName']}    ${TC_E2E_003['OperationsEmail']}    ${TC_E2E_003['Channel']}    ${TC_E2E_003['ProducerName']}
   Click Finish Tab
   Run Keyword And Continue On Failure    Verify and click the save and close button
   Switch to Documents
    @{expectedModification}    Create List    "${TC_E2E_003['SicCode']}"    "${TC_E2E_003['SicDescription']}"  
     ...    "${TC_E2E_003['NAICSCode']}"    "${TC_E2E_003['UnderwriterName']}"    "${TC_E2E_003['UnderwriterEmail']}"   
     ...    "${TC_E2E_003['UnderwrittingOffice']}"     "${TC_E2E_003['OperationsName']}"    "${TC_E2E_003['OperationsEmail']}"    "${TC_E2E_003['Channel']}"   
     ...    "${TC_E2E_003['ProducerName']}"    "${TC_E2E_003['ProducerEmail']}"    "${TC_E2E_003['Covered']['Product']}"    "${TC_E2E_003['Covered']['ProductSegment']}" 
   Run Keyword And Continue On Failure    Verify datas in UserModification file    @{expectedModification}
   Open uploaded SOV File   
   Run Keyword And Continue On Failure    Verify datas are matching for the uploaded SOV file    ${TC_E2E_003['SOVFile']}
   ${length}    Get Length    ${TC_E2E_003['dropdownOptions']}
   Run Keyword And Continue On Failure    Verify Properties datas for the given dropdown options    ${length}
   Run Keyword And Continue On Failure    Verify Loss run file is pending for stage 2
   Save Submission And verify popup
   Run Keyword And Continue On Failure    Verify Submission updated
   Run Keyword And Continue On Failure    Verify WorkFlow Options Advance Stage and Reject

TC_E2E_008
    [Tags]    E2E-WithSov
    [Documentation]    End to End Testing for New Submission - (Cleared to Under Review Stage) without SOV Loss run upload in Stage 2, since we have uploaded in Stage 1"
    Create User If the User is not present    ${NewUser}
    Select Impersonate option from the actions    ${NewUser['email']}    ${NewUser['search_user']}
    Run Keyword And Continue On Failure    Verify My Assignments Tab is displayed as a default tab
    Click All submissions option
    Select Submission using submission id    ${submission_id_sov}    @{TC_E2E_008['SubmissionColumnNames']}
    Run Keyword And Continue On Failure    Verify Submission page is displayed
    Advance Stage 2
    Run Keyword And Continue On Failure    Verify Stage is updated in the submission    ${TC_E2E_008['stage']}
    Click Edit Submission
    Click Answers Tab
    Run Keyword And Continue On Failure    Verify Answers Lists    ${TC_E2E_008['expectedQuestion']}
    Run Keyword And Continue On Failure    Verify Company Website Link    ${TC_E2E_008['expectedTitle']}
    Run Keyword And Continue On Failure    Verify Risk360 Card Pages Navigation    ${TC_E2E_008['Risk360_Card_Names']}    ${TC_E2E_008['Risk360_Card_Pages_Names']}
    Create New Task    ${TC_E2E_008['taskdata']}
    Run Keyword And Continue On Failure    Verify the created task details    ${TC_E2E_008['taskDetails']}
    Create New Mail    ${TC_E2E_008['emailData']}
    Run Keyword And Continue On Failure    Verify Email Sent Successfully
    Run Keyword And Continue On Failure    Verify Sent Email    ${TC_E2E_008['emailVerify']}
    Open uploaded SOV File   
    Run Keyword And Continue On Failure    Verify datas are matching for the uploaded SOV file    ${TC_E2E_003['SOVFile']}
    ${length}    Get Length    ${TC_E2E_003['dropdownOptions']}
    Run Keyword And Continue On Failure    Verify Properties datas for the given dropdown options    ${length}
    Run Keyword And Continue On Failure    Verify Claims Data From Loss Run File
    # Verify Policies Data From Loss Run File
    Run Keyword And Continue On Failure    Verify Analysis Data From Loss Run File    ${TC_E2E_008['CardName']}    ${TC_E2E_008['expectedAnalysisData']}    ${TC_E2E_008['expectedTableData']}
    # Verify Schema by downloading the json file
    Run Keyword And Continue On Failure    Verify WorkFlow History    ${TC_E2E_008['expectedWorkFlowHistory']}
    Run Keyword And Continue On Failure    Save Submission And verify popup
    Run Keyword And Continue On Failure    Verify Submission updated in Stage 2
    Run Keyword And Continue On Failure    Verify WorkFlow Options Advance Stage and Reject

TC_E2E_012
    [Tags]    E2E-WithSov
    [Documentation]    End to End Testing for New Submission - (Under Review stage + Child submission)  without SOV and LR upload"
    Create User If the User is not present    ${NewUser}
    Select Impersonate option from the actions    ${NewUser['email']}    ${NewUser['search_user']}
    Run Keyword And Continue On Failure    Verify My Assignments Tab is displayed as a default tab
    Click All submissions option
    Select Submission using submission id    ${submission_id_sov}    @{TC_E2E_012['SubmissionColumnNames']}
    Run Keyword And Continue On Failure    Verify Submission page is displayed
    Advance Stage    ${TC_E2E_012['stageNo']}    
    Run Keyword And Continue On Failure    Verify Stage is updated in the submission    ${TC_E2E_012['stage']}
    Click Edit Submission
    Click and verify Clearance tab
    Create Child Submission    ${TC_E2E_012['productName']}
    Wait For Processing Stage    ${TC_E2E_012['stageNo']}
    ${newSubmissionID}    Get New Submission ID After Child Submission
    Set Suite Variable    ${new_submission_id_sov}   ${newSubmissionID}  
    Navigate To All Submissions page from submissions 
    Select Submission using submission id    ${new_submission_id_sov}    @{TC_E2E_012['SubmissionColumnNames']}
    Wait For Processing Stage    ${TC_E2E_012['stageNo']}
    Run Keyword And Continue On Failure    Verify Summary Menu is displayed
    Switch To Summary Tab    ${TC_E2E_012['SummaryHeader']}
    Run Keyword And Continue On Failure    Verify Premium Amount    
    Run Keyword And Continue On Failure    Verify Summary Table Data    ${TC_E2E_012['SummaryTableHeader']}    ${TC_E2E_012['SummaryTableData']}
    Click Edit Submission
    Click Answers Tab
    Run Keyword And Continue On Failure    Verify Answers Lists    ${TC_E2E_012['expectedQuestion']}
    Run Keyword And Continue On Failure    Verify Company Website Link    ${TC_E2E_012['expectedTitle']}
    Run Keyword And Continue On Failure    Verify Risk360 Card Pages Navigation    ${TC_E2E_012['Risk360_Card_Names']}    ${TC_E2E_012['Risk360_Card_Pages_Names']}
    Create New Task    ${TC_E2E_012['taskdata']}
    Run Keyword And Continue On Failure    Verify the created task details    ${TC_E2E_012['taskDetails']}
    Create New Mail    ${TC_E2E_012['emailData']}
    Run Keyword And Continue On Failure    Verify Email Sent Successfully
    Run Keyword And Continue On Failure    Verify Sent Email    ${TC_E2E_012['emailVerify']}
    Open uploaded SOV File   
    Run Keyword And Continue On Failure    Verify datas are matching for the uploaded SOV file    ${TC_E2E_003['SOVFile']}
    ${length}    Get Length    ${TC_E2E_003['dropdownOptions']}
    Run Keyword And Continue On Failure    Verify Properties datas for the given dropdown options    ${length}
    Run Keyword And Continue On Failure    Verify Claims Data From Loss Run File
    # Verify Policies Data From Loss Run File
    Run Keyword And Continue On Failure    Verify Analysis Data From Loss Run File    ${TC_E2E_012['CardName']}    ${TC_E2E_012['expectedAnalysisData']}    ${TC_E2E_012['expectedTableData']}
    # Verify Schema by downloading the json file
    Run Keyword And Continue On Failure    Verify WorkFlow History    ${TC_E2E_012['expectedWorkFlowHistory']}
    Save Submission And verify popup
    Run Keyword And Continue On Failure    Verify Submission updated in the Current Stage    ${TC_E2E_012['stageNo']}
    Run Keyword And Continue On Failure    Verify WorkFlow Options Advance Stage and Reject

TC_E2E_018
    [Tags]    E2E-WithSov    
    [Documentation]    End to End Testing for New Submission - (Quoted stage)  with SOV and LR upload"
    Create User If the User is not present    ${NewUser}
    Select Impersonate option from the actions    ${NewUser['email']}    ${NewUser['search_user']}
    Run Keyword And Continue On Failure    Verify My Assignments Tab is displayed as a default tab
    Click All submissions option
    Select Submission using submission id    ${new_submission_id_sov}    @{TC_E2E_018['SubmissionColumnNames']}
    Run Keyword And Continue On Failure    Verify Submission page is displayed
    Advance Stage    ${TC_E2E_018['stageNo']}
    Run Keyword And Continue On Failure    Verify Stage is updated in the submission    ${TC_E2E_018['stage']}
    Click Edit Submission
    Run Keyword And Continue On Failure    Verify Summary Menu is displayed
    Switch To Summary Tab    ${TC_E2E_018['SummaryHeader']}
    Run Keyword And Continue On Failure    Run Keyword And Continue On Failure    Verify Policy Information In Summary Tab    ${TC_E2E_018['PolicyInfo']}   
    Run Keyword And Continue On Failure    Verify Summary Table Data    ${TC_E2E_018['SummaryTableHeader']}    ${TC_E2E_018['SummaryTableData']}
    Click Answers Tab
    Run Keyword And Continue On Failure    Verify Answers Lists    ${TC_E2E_018['expectedQuestion']}
    Run Keyword And Continue On Failure    Verify Risk360 Card Pages Navigation    ${TC_E2E_018['Risk360_Card_Names']}    ${TC_E2E_018['Risk360_Card_Pages_Names']}
    Create New Task    ${TC_E2E_018['taskdata']}
    Run Keyword And Continue On Failure    Verify the created task details    ${TC_E2E_018['taskDetails']}
    Create New Mail    ${TC_E2E_018['emailData']}
    Run Keyword And Continue On Failure    Verify Email Sent Successfully
    Run Keyword And Continue On Failure    Verify Sent Email    ${TC_E2E_018['emailVerify']}
    Open uploaded SOV File   
    Run Keyword And Continue On Failure    Verify datas are matching for the uploaded SOV file    ${TC_E2E_003['SOVFile']}
    ${length}    Get Length    ${TC_E2E_003['dropdownOptions']}
    Run Keyword And Continue On Failure    Verify Properties datas for the given dropdown options    ${length}
    Run Keyword And Continue On Failure    Verify Claims Data From Loss Run File
    # Verify Policies Data From Loss Run File
    Run Keyword And Continue On Failure    Verify Analysis Data From Loss Run File    ${TC_E2E_018['CardName']}    ${TC_E2E_018['expectedAnalysisData']}    ${TC_E2E_018['expectedTableData']}
    # Verify Schema by downloading the json file
    Run Keyword And Continue On Failure    Verify WorkFlow History    ${TC_E2E_018['expectedWorkFlowHistory']}
    Save Submission And verify popup
    Run Keyword And Continue On Failure    Verify Submission updated in the Current Stage    ${TC_E2E_018['stageNo']}

TC_E2E_027
    [Tags]    E2E-WithSov
    [Documentation]    End to End Testing for New Submission - (Under Review stage + Child submission)  with SOV and LR upload"
    Create User If the User is not present    ${NewUser}
    Select Impersonate option from the actions    ${NewUser['email']}    ${NewUser['search_user']}
    Run Keyword And Continue On Failure    Verify My Assignments Tab is displayed as a default tab
    Click All submissions option
    Select Submission using submission id    ${new_submission_id_sov}    @{TC_E2E_017['SubmissionColumnNames']}
    Run Keyword And Continue On Failure    Verify Submission page is displayed
    # Run Pre-requiste for Step 1 2 3 & 4
    Advance Stage    ${TC_E2E_027['stageNo']}
    Run Keyword And Continue On Failure    Verify Stage is updated in the submission    ${TC_E2E_027['stage']}
    Run Keyword And Continue On Failure    Verify Summary Menu is displayed
    Click Edit Submission
    # Run Keyword And Continue On Failure    Verify All Side menu options are Displayed
    # Run Keyword And Continue On Failure    Verify Policy PDF is Generated and Available in Documents Tab    ${TC_E2E_023['PolicyInfo']}
    Switch to Summary
    # Run Keyword And Continue On Failure    verify Header Displayed    ${TC_E2E_023['stage']}    ${TC_E2E_023['Tab_Name']}
    # Run Keyword And Continue On Failure    Verify Summary Table Data    ${TC_E2E_011['SummaryTableHeader']}    ${TC_E2E_023['SummaryTableData']}
    # Run Keyword And Continue On Failure    Verify Policy Information Details from Summary Tab    ${TC_E2E_017['PolicyInfo']}    ${TC_Forms_01}    
    # Run Keyword And Continue On Failure    Enter the Policy Information    ${TC_E2E_023['PolicyInfo']}
    #  Verify the Workflow in Summary Tab
    #Issue: The Child Submission in the Summary Tab is not stable.
    #Impact: We are unable to verify if the dependent child is displayed/present as expected
    # Run Keyword And Continue On Failure    Verify Child Submission Should be Displayed in Summary Tab    ${TC_E2E_017['product']}
    # Run Keyword And Continue On Failure    verify Account History are editable    ${new_submission_id_1}    ${TC_E2E_024['stage']} 
    # Step No 11 to 13[Forms Verification Pending, Changes need to be done]
       #Complete Forms Tab Details Filling    ${TC_Forms_01}
    # Click Answers Tab
    # Run Keyword And Continue On Failure    Complete Forms Tab Details Verification    ${TC_Forms_02}
    # Run Keyword And Continue On Failure    Complete Forms Tab Details Filling    ${TC_Forms_01}
    # Run Keyword And Continue On Failure    Complete Forms Tab Details Verification    ${TC_Forms_01}
    # Click and verify Clearance tab
    #  Answer Tab
    Click Answers Tab
    # Run Keyword And Continue On Failure    Verify Answers Lists    ${TC_E2E_008['expectedQuestion']}
    # Risk360 Tab
    Run Keyword And Continue On Failure    Verify Company Website Link    ${TC_E2E_008['expectedTitle']}
    # Run Keyword And Continue On Failure    Verify Risk360 Card Pages Navigation    ${TC_E2E_008['Risk360_Card_Names']}    ${TC_E2E_008['Risk360_Card_Pages_Names']}
    # Task tab
    # Create New Task    ${TC_E2E_024['taskdata']}
    # Run Keyword And Continue On Failure    Select the Created Task    ${TC_E2E_024['taskdata']}
    # Run Keyword And Continue On Failure    Verify the created task details    ${TC_E2E_024['taskDetails']}
    # Run Keyword And Continue On Failure    verify Edit Delete and Complete task Buttons are present on the right side of task list
    # Run Keyword And Continue On Failure    Verify Edit Icon is Clickable and Functional    ${TC_E2E_024['priority']}
    # Run Keyword And Continue On Failure    Verify the created task details    ${TC_E2E_024['taskupdateddetails']}
    # Click Answers Tab
    # Run Keyword And Continue On Failure    Select the Created Task    ${TC_E2E_024['taskdata']}
    # Run Keyword And Continue On Failure    Verify Delete Icon is Clickable and Functional    ${TC_E2E_024['taskupdateddetails']}
    #Email Tab
    # Run Keyword And Continue On Failure    Verify Discard Button visible    ${TC_Email_001['DraftemailData']}
    # Save and verify mail in Draft    ${TC_Email_001['DraftemailData']}
    # Create New Mail With Missing Data    ${TC_Email_001['emailData_Mising']}    ${TC_Email_001['Expected_PopUp']}
    # Document Tab
    Upload SOV and Loss Run Documents    @{TC_E2E_022['FileName']}
    Wait for Upload to Complete for SOV and Loss Run    ${TC_E2E_027['stageNo']}
    Open uploaded SOV File
    Run Keyword And Continue On Failure    Verify datas are matching for the uploaded SOV file    ${TC_E2E_022['SOVFile']}
    ${length}    Get Length    ${TC_E2E_003['dropdownOptions']}
    Run Keyword And Continue On Failure    Verify Properties datas for the given dropdown options    ${length}
    Run Keyword And Continue On Failure    Verify Claims Data From Loss Run File
    Run Keyword And Continue On Failure    Verify Policies Data From Loss Run File
    Run Keyword And Continue On Failure    Verify Analysis Data From Loss Run File    ${TC_E2E_022['CardName']}    ${TC_E2E_022['expectedAnalysisData']}    ${TC_E2E_022['expectedTableData']}
    #Clearance Tab--Verification
    Run Keyword And Continue On Failure    verify Clearance Tab    ${TC_E2E_027['ProductName']}
    #WorkFlow History ----Integration needed for execution ,
    Run Keyword And Continue On Failure    Verify WorkFlow History    ${TC_E2E_027['expectedWorkFlowHistory']}
    Save Submission And verify popup
    Run Keyword And Continue On Failure    Verify Submission updated in the Current Stage    ${TC_E2E_027['stageNo']}

TC_E2E_028
    [Tags]    E2E-WithSov
    [Documentation]    End to End Testing for New Submission - (Under Review stage + Child submission)  with SOV and LR upload"
    Create User If the User is not present    ${NewUser}
    Select Impersonate option from the actions    ${NewUser['email']}    ${NewUser['search_user']}
    Run Keyword And Continue On Failure    Verify My Assignments Tab is displayed as a default tab
    Click All submissions option
    Select Submission using submission id    ${new_submission_id_sov}    @{TC_E2E_017['SubmissionColumnNames']}
    Run Keyword And Continue On Failure    Verify Submission page is displayed
    Advance Stage    ${TC_E2E_028['stageNo']}
    Run Keyword And Continue On Failure    Verify Stage is updated in the submission    ${TC_E2E_028['stage']}
    Run Keyword And Continue On Failure    Verify Summary Menu is displayed
    Click Edit Submission
    # Run Keyword And Continue On Failure    Verify All Side menu options are Displayed
    # Run Keyword And Continue On Failure    Verify Policy PDF is Generated and Available in Documents Tab    ${TC_E2E_024['PolicyInfo']}
    # Switch to Summary
    # Run Keyword And Continue On Failure    verify Header Displayed    ${TC_E2E_024['stage']}    ${TC_E2E_024['Tab_Name']}
    # Run Keyword And Continue On Failure    Verify Summary Table Data    ${TC_E2E_011['SummaryTableHeader']}    ${TC_E2E_024['SummaryTableData']}
    # Run Keyword And Continue On Failure    Verify Policy Information Details from Summary Tab    ${TC_E2E_017['PolicyInfo']}    ${TC_Forms_01}    
    # Run Keyword And Continue On Failure    Enter the Policy Information    ${TC_E2E_024['PolicyInfo']}
    #Issue: The Child Submission in the Summary Tab is not stable.
    #Impact: We are unable to verify if the dependent child is displayed/present as expected
    # Run Keyword And Continue On Failure    Verify Child Submission Should be Displayed in Summary Tab    ${TC_E2E_017['product']}
    # Run Keyword And Continue On Failure    verify Account History are editable    ${new_submission_id_1}    ${TC_E2E_024['stage']}
    # Step No 11 to 13[Forms Verification Pending, Changes need to be done]
    # Click Answers Tab
    # Run Keyword And Continue On Failure    Complete Forms Tab Details Verification    ${TC_Forms_01}
    # Run Keyword And Continue On Failure    Complete Forms Tab Details Filling    ${TC_Forms_02}
    # Run Keyword And Continue On Failure    Complete Forms Tab Details Verification    ${TC_Forms_02}
    # Run Keyword And Continue On Failure    Click and verify Clearance tab
    #  Answer Tab
    Click Answers Tab
    # Run Keyword And Continue On Failure    Verify Answers Lists    ${TC_E2E_024['expectedQuestion']}
    # Risk360 Tab
    Run Keyword And Continue On Failure    Verify Company Website Link    ${TC_E2E_028['expectedTitle']}
    # Run Keyword And Continue On Failure    Verify Risk360 Card Pages Navigation    ${TC_E2E_024['Risk360_Card_Names']}    ${TC_E2E_024['Risk360_Card_Pages_Names']}
    # Task tab
    # Create New Task    ${TC_E2E_024['taskdata']}
    # Run Keyword And Continue On Failure    Select the Created Task    ${TC_E2E_024['taskdata']}
    # Run Keyword And Continue On Failure    Verify the created task details    ${TC_E2E_024['taskDetails']}
    # Run Keyword And Continue On Failure    verify Edit Delete and Complete task Buttons are present on the right side of task list
    # Run Keyword And Continue On Failure    Verify Edit Icon is Clickable and Functional    ${TC_E2E_024['priority']}
    # Run Keyword And Continue On Failure    Verify the created task details    ${TC_E2E_024['taskupdateddetails']}
    # Click Answers Tab
    # Run Keyword And Continue On Failure    Select the Created Task    ${TC_E2E_024['taskdata']}
    # Run Keyword And Continue On Failure    Verify Delete Icon is Clickable and Functional    ${TC_E2E_024['taskupdateddetails']}
    #Email Tab
    # Run Keyword And Continue On Failure    Verify Discard Button visible    ${TC_Email_001['DraftemailData']}
    # Save and verify mail in Draft    ${TC_Email_001['DraftemailData']}
    # Create New Mail With Missing Data    ${TC_Email_001['emailData_Mising']}    ${TC_Email_001['Expected_PopUp']}
    # Document Tab
    Upload SOV and Loss Run Documents    @{TC_E2E_022['FileName']}
    Wait for Upload to Complete for SOV and Loss Run    ${TC_E2E_028['stageNo']}
    Open uploaded SOV File  
    Run Keyword And Continue On Failure    Verify datas are matching for the uploaded SOV file    ${TC_E2E_022['SOVFile']}
    ${length}    Get Length    ${TC_E2E_003['dropdownOptions']}
    Run Keyword And Continue On Failure    Verify Properties datas for the given dropdown options    ${length}
    Run Keyword And Continue On Failure    Verify Claims Data From Loss Run File
    Run Keyword And Continue On Failure    Verify Policies Data From Loss Run File
    Run Keyword And Continue On Failure    Verify Analysis Data From Loss Run File    ${TC_E2E_022['CardName']}    ${TC_E2E_022['expectedAnalysisData']}    ${TC_E2E_022['expectedTableData']}
    #Clearance Tab--Verification
    # Run Keyword And Continue On Failure    verify Clearance Tab    ${TC_E2E_024['ProductName']}
    #WorkFlow History ----Integration needed for execution ,
    Run Keyword And Continue On Failure    Verify WorkFlow History    ${TC_E2E_028['expectedWorkFlowHistory']}
    Save Submission And verify popup
    Run Keyword And Continue On Failure    Verify Submission updated in the Current Stage    ${TC_E2E_028['stageNo']}

TC_E2E_029
    [Tags]    E2E-WithSov
    [Documentation]    End to End Testing for New Submission - (Under Review stage + Child submission)  with SOV and LR upload"
    Create User If the User is not present    ${NewUser}
    Select Impersonate option from the actions    ${NewUser['email']}    ${NewUser['search_user']}
    Run Keyword And Continue On Failure    Verify My Assignments Tab is displayed as a default tab
    Click All submissions option
    Select Submission using submission id    ${new_submission_id_sov}    @{TC_E2E_017['SubmissionColumnNames']}
    Run Keyword And Continue On Failure    Verify Submission page is displayed
    # Run Pre-requiste for Step 1 2 3 & 4
    Advance Stage    ${TC_E2E_029['stageNo']} 
    Run Keyword And Continue On Failure    Verify Stage is updated in the submission    ${TC_E2E_029['stage']}
    # Task Tab
    Click Answers Tab
    Wait For Elements State    ${TaskClick}    visible
    Click    ${TaskClick}
    Run Keyword And Continue On Failure    Verify the auto generated task details    ${TC_E2E_029['taskDetails1']}
    Run Keyword And Continue On Failure    Complete Task with the given reason for Booking stage    ${TC_E2E_029['taskreason']}
    Run Keyword And Continue On Failure    Verify the task is completed and sanction label is appears as per the reason for booking    ${TC_E2E_029['taskreason']}
    Run Keyword And Continue On Failure    Click Edit Submission
    # Run Keyword And Continue On Failure    Verify All Side menu options are Displayed
    # Run Keyword And Continue On Failure    Verify Policy PDF is Generated and Available in Documents Tab    ${TC_E2E_024['PolicyInfo']}
    # Run Keyword And Continue On Failure    Switch to Summary
    # Run Keyword And Continue On Failure    verify Header Displayed    ${TC_E2E_025['stage']}    ${TC_E2E_025['Tab_Name']}
    # Run Keyword And Continue On Failure    Verify Summary Table Data    ${TC_E2E_011['SummaryTableHeader']}    ${TC_E2E_025['SummaryTableData']}
    # Run Keyword And Continue On Failure    Verify Policy Information Details from Summary Tab    ${TC_E2E_017['PolicyInfo']}    ${TC_Forms_01}    
    # Run Keyword And Continue On Failure    Enter the Policy Information    ${TC_E2E_025['PolicyInfo']}
    # Run Keyword And Continue On Failure    verify the entered Policy Information    ${TC_E2E_025['PolicyInfo']}
    # Run Keyword And Continue On Failure    Verify Child Submission Should be Displayed in Summary Tab    ${TC_E2E_017['product']}
    # Run Keyword And Continue On Failure    verify Account History are editable    ${new_submission_id_1}    ${TC_E2E_024['stage']} 
    # Step No 11 to 13[Forms Verification Pending, Changes need to be done]
    # Click Answers Tab
    # Run Keyword And Continue On Failure    Complete Forms Tab Details Verification    ${TC_Forms_02}
    # Run Keyword And Continue On Failure    Complete Forms Tab Details Filling    ${TC_Forms_01}
    # Run Keyword And Continue On Failure    Complete Forms Tab Details Verification    ${TC_Forms_01}
    #  Answer Tab
    Click Answers Tab
    # Run Keyword And Continue On Failure    Verify Answers Lists    ${TC_E2E_025['expectedQuestion']}
    # Risk360 Tab
    Run Keyword And Continue On Failure    Verify Company Website Link    ${TC_E2E_029['expectedTitle']}
    # Run Keyword And Continue On Failure    Verify Risk360 Card Pages Navigation    ${TC_E2E_025['Risk360_Card_Names']}    ${TC_E2E_025['Risk360_Card_Pages_Names']}
    # Task tab
    # Run Keyword And Continue On Failure    Create New Task    ${TC_E2E_025['taskdata']}
    # Run Keyword And Continue On Failure    Select the Created Task    ${TC_E2E_025['taskdata']}
    # Run Keyword And Continue On Failure    Verify the created task details    ${TC_E2E_025['taskDetails']}
    # Run Keyword And Continue On Failure    verify Edit Delete and Complete task Buttons are present on the right side of task list
    # Run Keyword And Continue On Failure    Verify Edit Icon is Clickable and Functional    ${TC_E2E_025['priority']}
    # Run Keyword And Continue On Failure    Verify the created task details    ${TC_E2E_025['taskupdateddetails']}
    # Click Answers Tab
    # Run Keyword And Continue On Failure    Select the Created Task    ${TC_E2E_025['taskdata']}
    # Run Keyword And Continue On Failure    Verify Delete Icon is Clickable and Functional    ${TC_E2E_025['taskupdateddetails']} 
    #Email Tab 
    # Run Keyword And Continue On Failure    Verify Discard Button visible    ${TC_E2E_025['DraftemailData']}
    # Run Keyword And Continue On Failure    Save and verify mail in Draft    ${TC_E2E_025['DraftemailData']}
    # Run Keyword And Continue On Failure    Create New Mail With Missing Data    ${TC_E2E_025['emailData_Mising']}    ${TC_Email_001['Expected_PopUp']}
    # Document Tab
    Run Keyword And Continue On Failure    Upload SOV and Loss Run Documents    @{TC_E2E_022['FileName']}
    Run Keyword And Continue On Failure    Wait for Upload to Complete for SOV and Loss Run    ${TC_E2E_029['stageNo']}
    Run Keyword And Continue On Failure    Open uploaded SOV File   
    Run Keyword And Continue On Failure    Verify datas are matching for the uploaded SOV file    ${TC_E2E_022['SOVFile']}
    ${length}    Get Length    ${TC_E2E_003['dropdownOptions']}
    Run Keyword And Continue On Failure    Verify Properties datas for the given dropdown options    ${length}
    Run Keyword And Continue On Failure    Verify Claims Data From Loss Run File
    Run Keyword And Continue On Failure    Verify Policies Data From Loss Run File
    Run Keyword And Continue On Failure    Verify Analysis Data From Loss Run File    ${TC_E2E_022['CardName']}    ${TC_E2E_022['expectedAnalysisData']}    ${TC_E2E_022['expectedTableData']}
   #Clearance Tab--Verification
    # Run Keyword And Continue On Failure    verify Clearance Tab    ${TC_E2E_025['ProductName']} 
    Run Keyword And Continue On Failure    Verify WorkFlow History    ${TC_E2E_029['expectedWorkFlowHistory']}
    Save Submission And verify popup
    Run Keyword And Continue On Failure    Verify Submission updated in the Current Stage    ${TC_E2E_029['stageNo']}

TC_E2E_030
    [Tags]    E2E-WithSov
    [Documentation]    End to End Testing for New Submission - (Under Review stage + Child submission)  with SOV and LR upload"
    Create User If the User is not present    ${NewUser}
    Select Impersonate option from the actions    ${NewUser['email']}    ${NewUser['search_user']}
    Run Keyword And Continue On Failure    Verify My Assignments Tab is displayed as a default tab
    Click All submissions option
    Select Submission using submission id    ${new_submission_id_sov}    @{TC_E2E_017['SubmissionColumnNames']}
    Run Keyword And Continue On Failure    Verify Submission page is displayed
    Advance Stage    ${TC_E2E_030['stageNo']}
    Run Keyword And Continue On Failure    Verify Stage is updated in the submission    ${TC_E2E_030['stage']}
    Click Edit Submission
    # Verify Summary Menu is displayed
    # Run Keyword And Continue On Failure    Verify All Side menu options are Displayed
    # Run Keyword And Continue On Failure    Verify Policy PDF is Generated and Available in Documents Tab    ${TC_E2E_025['PolicyInfo']}
    # Run Keyword And Continue On Failure    Switch to Summary
    # Run Keyword And Continue On Failure    verify Header Displayed    ${TC_E2E_026['stage']}    ${TC_E2E_026['Tab_Name']}
    # Run Keyword And Continue On Failure    Verify Summary Table Data    ${TC_E2E_026['SummaryTableHeader']}    ${TC_E2E_026['SummaryTableData']}
    # Run Keyword And Continue On Failure    Verify Policy Information Details from Summary Tab    ${TC_E2E_026['PolicyInfo']}    ${TC_Forms_01}    
    # Run Keyword And Continue On Failure    Enter the Policy Information    ${TC_E2E_026['PolicyInfo']}
    # Run Keyword And Continue On Failure    verify the entered Policy Information    ${TC_E2E_026['PolicyInfo']}
    # Run Keyword And Continue On Failure    Verify Child Submission Should be Displayed in Summary Tab    ${TC_E2E_017['product']}
    # Run Keyword And Continue On Failure    verify Account History are editable    ${new_submission_id_1}    ${TC_E2E_026['stage']} 
    #  Answer Tab
    # Click Answers Tab
    # Run Keyword And Continue On Failure    Verify Answers Lists    ${TC_E2E_026['expectedQuestion']}
    # Run Keyword And Continue On Failure    Complete Forms Tab Details Verification    ${TC_Forms_01}
    # Run Keyword And Continue On Failure    Complete Forms Tab Details Filling    ${TC_Forms_02}
    # Run Keyword And Continue On Failure    Complete Forms Tab Details Verification    ${TC_Forms_02}
    Click Answers Tab
    # Risk360 Tab
    Run Keyword And Continue On Failure    Verify Company Website Link    ${TC_E2E_030['expectedTitle']}
    # Run Keyword And Continue On Failure    Verify Risk360 Card Pages Navigation    ${TC_E2E_026['Risk360_Card_Names']}    ${TC_E2E_026['Risk360_Card_Pages_Names']}
   # Task tab
    # Click Answers Tab
    # Run Keyword And Continue On Failure    Create New Task    ${TC_E2E_026['taskdata']}
    # Run Keyword And Continue On Failure    Select the Created Task    ${TC_E2E_026['taskdata']}
    # Run Keyword And Continue On Failure    Verify the created task details    ${TC_E2E_026['taskDetails']}
    # Run Keyword And Continue On Failure    verify Edit Delete and Complete task Buttons are present on the right side of task list
    # Run Keyword And Continue On Failure    Verify Edit Icon is Clickable and Functional    ${TC_E2E_026['priority']}
    # Run Keyword And Continue On Failure    Verify the created task details    ${TC_E2E_026['taskupdateddetails']}
    # Click Answers Tab
    # Run Keyword And Continue On Failure    Select the Created Task    ${TC_E2E_026['taskdata']}
    # Run Keyword And Continue On Failure    Verify Delete Icon is Clickable and Functional    ${TC_E2E_026['taskupdateddetails']}
    #Email Tab
    # Run Keyword And Continue On Failure    Verify Discard Button visible    ${TC_E2E_026['DraftemailData']}
    # Run Keyword And Continue On Failure    Save and verify mail in Draft    ${TC_E2E_026['DraftemailData']}
    # Run Keyword And Continue On Failure    Create New Mail With Missing Data    ${TC_E2E_026['emailData_Mising']}    ${TC_E2E_026['Expected_PopUp']}
    # Document Tab
    Run Keyword And Continue On Failure    Upload SOV and Loss Run Documents    @{TC_E2E_022['FileName']}
    Run Keyword And Continue On Failure    Wait for Upload to Complete for SOV and Loss Run    ${TC_E2E_030['stageNo']}
    Run Keyword And Continue On Failure    Open uploaded SOV File   
    Run Keyword And Continue On Failure    Verify datas are matching for the uploaded SOV file    ${TC_E2E_022['SOVFile']}
    ${length}    Get Length    ${TC_E2E_003['dropdownOptions']}
    Run Keyword And Continue On Failure    Verify Properties datas for the given dropdown options    ${length}
    Run Keyword And Continue On Failure    Verify Claims Data From Loss Run File
    Run Keyword And Continue On Failure    Verify Policies Data From Loss Run File
    Run Keyword And Continue On Failure    Verify Analysis Data From Loss Run File    ${TC_E2E_022['CardName']}    ${TC_E2E_022['expectedAnalysisData']}    ${TC_E2E_022['expectedTableData']}  
    # clearance tab
    # Run Keyword And Continue On Failure    verify Clearance Tab    ${TC_E2E_026['ProductName']}
    Run Keyword And Continue On Failure    Verify WorkFlow History    ${TC_E2E_030['expectedWorkFlowHistory']}
    Run Keyword And Continue On Failure    Save Submission And verify popup
    Run Keyword And Continue On Failure    Verify Advance Stage is InActive

TC_E2E_010
    [Tags]    E2E-Email_Verification
    [Documentation]    End to End Testing for New Submission - With Mail Verifications
    ${submision_id}    Run Pre-requiste Steps for Stage 1
    Set Suite Variable    ${submission_id_email}    ${submision_id} 
    Advance Stage 2
    Run Keyword And Continue On Failure    Verify Stage is updated in the submission    ${TC_E2E_010['stage']}
    Click Edit Submission
    Click Answers Tab
    Run Keyword And Continue On Failure    Verify Answers Lists    ${TC_E2E_010['expectedQuestion']}
    Run Keyword And Continue On Failure    Verify Risk360 Card Pages Navigation    ${TC_E2E_010['Risk360_Card_Names']}    ${TC_E2E_010['Risk360_Card_Pages_Names']}
    Create New Task    ${TC_E2E_010['taskdata']}
    Select Task Card     ${TC_E2E_010['taskdata']['taskName']}
    Run Keyword And Continue On Failure    Verify the created task details    ${TC_E2E_010['taskDetails']}
    Create New Mail For Upload 40 MB File    ${TC_E2E_010['emailData_Upload_40_MB_File']}
    Run Keyword And Continue On Failure    Verify Email Sent Successfully
    Run Keyword And Continue On Failure    Verify Sent Email Data    ${TC_E2E_010['emailVerifyFor40Mb']}    Upload with <40mb file
    Create New Mail For Upload Multiple Files    ${TC_E2E_010['emailData_Upload_Multiple_Files']}
    Run Keyword And Continue On Failure    Verify Email Sent Successfully
    Run Keyword And Continue On Failure    Verify Sent Email Data    ${TC_E2E_010['emailVerifyForMultipleFiles']}    Upload with mulitiple file types
    Create New Mail For Upload Multiple Submission Assets    ${TC_E2E_010['emailData_Upload_Multiple_Submission_Assets']}
    Run Keyword And Continue On Failure    Verify Email Sent Successfully
    Run Keyword And Continue On Failure    Verify Sent Email Data    ${TC_E2E_010['emailVerifyMultipleAssets']}    Upload with muliple assets
    Upload SOV and Loss Run Documents    @{TC_E2E_010['FileName']}
    Wait for Upload to Complete
    Open uploaded SOV File   
    Run Keyword And Continue On Failure    Verify datas are matching for the uploaded SOV file    ${TC_E2E_003['SOVFile']}
    ${length}    Get Length    ${TC_E2E_003['dropdownOptions']}
    Run Keyword And Continue On Failure    Verify Properties datas for the given dropdown options    ${length}
    Run Keyword And Continue On Failure    Verify Claims Data From Loss Run File
    # Verify Policies Data From Loss Run File
    Run Keyword And Continue On Failure    Verify Analysis Data From Loss Run File    ${TC_E2E_010['CardName']}    ${TC_E2E_010['expectedAnalysisData']}    ${TC_E2E_010['expectedTableData']}
    # Verify Schema by downloading the json file
    Run Keyword And Continue On Failure    Save Submission And verify popup
    Run Keyword And Continue On Failure    Verify Submission updated in Stage 2
    Run Keyword And Continue On Failure    Verify WorkFlow Options Advance Stage and Reject

TC_E2E_014
    [Tags]    E2E-Email_Verification
    [Documentation]    End to End Testing for New Submission - (Under Review stage + Child submission)  with Email Verifications"
    Create User If the User is not present    ${NewUser}
    Select Impersonate option from the actions    ${NewUser['email']}    ${NewUser['search_user']}
    Run Keyword And Continue On Failure    Verify My Assignments Tab is displayed as a default tab
    Click All submissions option
    Select Submission using submission id    ${submission_id_email}    @{TC_E2E_014['SubmissionColumnNames']}
    Run Keyword And Continue On Failure    Verify Submission page is displayed
    Advance Stage    ${TC_E2E_014['stageNo']}    
    Run Keyword And Continue On Failure    Verify Stage is updated in the submission    ${TC_E2E_014['stage']}
    Click Edit Submission
    Click and verify Clearance tab
    Create Child Submission    ${TC_E2E_014['productName']}
    Wait For Processing Stage    ${TC_E2E_014['stageNo']}
    ${newSubmissionID}    Get New Submission ID After Child Submission
    Set Suite Variable    ${new_submission_id_email}   ${newSubmissionID}  
    Navigate To All Submissions page from submissions 
    Select Submission using submission id    ${new_submission_id_email}    @{TC_E2E_014['SubmissionColumnNames']}
    Wait For Processing Stage    ${TC_E2E_014['stageNo']}
    Run Keyword And Continue On Failure    Verify Summary Menu is displayed
    Switch To Summary Tab    ${TC_E2E_014['SummaryHeader']}
    Run Keyword And Continue On Failure    Verify Premium Amount    
    Run Keyword And Continue On Failure    Verify Summary Table Data    ${TC_E2E_014['SummaryTableHeader']}    ${TC_E2E_014['SummaryTableData']}
    Click Answers Tab
    Click Edit Submission
    Run Keyword And Continue On Failure    Verify Answers Lists    ${TC_E2E_011['expectedQuestion']}
    Run Keyword And Continue On Failure    Verify Risk360 Card Pages Navigation    ${TC_E2E_011['Risk360_Card_Names']}    ${TC_E2E_014['Risk360_Card_Pages_Names']}
    Create New Task    ${TC_E2E_014['taskdata']}
    Run Keyword And Continue On Failure    Verify the created task details    ${TC_E2E_014['taskDetails']}
    Create New Mail For Upload 40 MB File    ${TC_E2E_014['emailData_Upload_40_MB_File']}
    Run Keyword And Continue On Failure    Verify Email Sent Successfully
    Run Keyword And Continue On Failure    Verify Sent Email Data    ${TC_E2E_014['emailVerifyFor40Mb']}    Upload with <40mb file
    Create New Mail For Upload Multiple Files    ${TC_E2E_014['emailData_Upload_Multiple_Files']}
    Run Keyword And Continue On Failure    Verify Email Sent Successfully
    Run Keyword And Continue On Failure    Verify Sent Email Data    ${TC_E2E_014['emailVerifyForMultipleFiles']}    Upload with mulitiple file types
    Create New Mail For Upload Multiple Submission Assets    ${TC_E2E_014['emailData_Upload_Multiple_Submission_Assets']}
    Run Keyword And Continue On Failure    Verify Email Sent Successfully
    Run Keyword And Continue On Failure    Verify Sent Email Data    ${TC_E2E_014['emailVerifyMultipleAssets']}    Upload with muliple assets
    Upload SOV and Loss Run Documents    @{TC_E2E_014['FileName']}
    Wait for Upload to Complete for SOV and Loss Run    ${TC_E2E_014['stageNo']}
    Open uploaded SOV File   
    Run Keyword And Continue On Failure    Verify datas are matching for the uploaded SOV file    ${TC_E2E_003['SOVFile']}
    ${length}    Get Length    ${TC_E2E_003['dropdownOptions']}
    Run Keyword And Continue On Failure    Verify Properties datas for the given dropdown options    ${length}
    Run Keyword And Continue On Failure    Verify Claims Data From Loss Run File
    # Verify Policies Data From Loss Run File
    Run Keyword And Continue On Failure    Verify Analysis Data From Loss Run File    ${TC_E2E_014['CardName']}    ${TC_E2E_014['expectedAnalysisData']}    ${TC_E2E_014['expectedTableData']}
    # Verify Schema by downloading the json file
    Run Keyword And Continue On Failure    Verify WorkFlow History    ${TC_E2E_011['expectedWorkFlowHistory']}
    Save Submission And verify popup
    Run Keyword And Continue On Failure    Verify Submission updated in the Current Stage    ${TC_E2E_014['stageNo']}
    Run Keyword And Continue On Failure    Verify WorkFlow Options Advance Stage and Reject

TC_E2E_019
    [Tags]    E2E-Email_Verification   
    [Documentation]    End to End Testing for New Submission - (Quoted stage)  Email Verifications"
    Create User If the User is not present    ${NewUser}
    Select Impersonate option from the actions    ${NewUser['email']}    ${NewUser['search_user']}
    Run Keyword And Continue On Failure    Verify My Assignments Tab is displayed as a default tab
    Click All submissions option
    Select Submission using submission id    ${new_submission_id_email}    @{TC_E2E_019['SubmissionColumnNames']}
    Run Keyword And Continue On Failure    Verify Submission page is displayed
    Advance Stage    ${TC_E2E_019['stageNo']}
    Run Keyword And Continue On Failure    Verify Stage is updated in the submission    ${TC_E2E_019['stage']}
    Click Edit Submission
    Run Keyword And Continue On Failure    Verify Summary Menu is displayed
    Switch To Summary Tab    ${TC_E2E_019['SummaryHeader']}
    Run Keyword And Continue On Failure    Verify Policy Information In Summary Tab    ${TC_E2E_019['PolicyInfo']}   
    Run Keyword And Continue On Failure    Verify Summary Table Data    ${TC_E2E_019['SummaryTableHeader']}    ${TC_E2E_019['SummaryTableData']}
    Click Answers Tab
    Run Keyword And Continue On Failure    Verify Answers Lists    ${TC_E2E_019['expectedQuestion']}
    Run Keyword And Continue On Failure    Verify Risk360 Card Pages Navigation    ${TC_E2E_019['Risk360_Card_Names']}    ${TC_E2E_019['Risk360_Card_Pages_Names']}
    Create New Task    ${TC_E2E_019['taskdata']}
    Run Keyword And Continue On Failure    Verify the created task details    ${TC_E2E_019['taskDetails']}
    Create New Mail For Upload 40 MB File    ${TC_E2E_019['emailData_Upload_40_MB_File']}
    Run Keyword And Continue On Failure    Verify Email Sent Successfully
    Run Keyword And Continue On Failure    Verify Sent Email Data    ${TC_E2E_019['emailVerifyFor40Mb']}    Upload with <40mb file
    Create New Mail For Upload Multiple Files    ${TC_E2E_019['emailData_Upload_Multiple_Files']}
    Run Keyword And Continue On Failure    Verify Email Sent Successfully
    Run Keyword And Continue On Failure    Verify Sent Email Data    ${TC_E2E_019['emailVerifyForMultipleFiles']}    Upload with mulitiple file types
    Create New Mail For Upload Multiple Submission Assets    ${TC_E2E_019['emailData_Upload_Multiple_Submission_Assets']}
    Run Keyword And Continue On Failure    Verify Email Sent Successfully
    Run Keyword And Continue On Failure    Verify Sent Email Data    ${TC_E2E_019['emailVerifyMultipleAssets']}    Upload with muliple assets
    Upload SOV and Loss Run Documents    @{TC_E2E_019['FileName']}
    Wait for Upload to Complete for SOV and Loss Run    ${TC_E2E_019['stageNo']}
    Open uploaded SOV File   
    Run Keyword And Continue On Failure    Verify datas are matching for the uploaded SOV file    ${TC_E2E_003['SOVFile']}
    ${length}    Get Length    ${TC_E2E_003['dropdownOptions']}
    Run Keyword And Continue On Failure    Verify Properties datas for the given dropdown options    ${length}
    Run Keyword And Continue On Failure    Verify Claims Data From Loss Run File
    # Verify Policies Data From Loss Run File
    Run Keyword And Continue On Failure    Verify Analysis Data From Loss Run File    ${TC_E2E_019['CardName']}    ${TC_E2E_019['expectedAnalysisData']}    ${TC_E2E_019['expectedTableData']}
    # Verify Schema by downloading the json file
    Run Keyword And Continue On Failure    Verify WorkFlow History    ${TC_E2E_019['expectedWorkFlowHistory']}
    Save Submission And verify popup
    Run Keyword And Continue On Failure    Verify Submission updated in the Current Stage    ${TC_E2E_019['stageNo']}

TC_E2E_015
    [Tags]       E2E-Referral
    [Documentation]    End to End Testing for New Submission - (Under Review stage + Child submission)  with Referral"
    ${submission}    Run Pre-requiste Steps for Stage 1 & 2 
    Advance Stage    ${TC_E2E_015['stageNo']}    
    Run Keyword And Continue On Failure    Verify Stage is updated in the submission    ${TC_E2E_015['stage']}
    Click Edit Submission
    Click and verify Clearance tab
    Create Child Submission    ${TC_E2E_015['productName']}
    Wait For Processing Stage    ${TC_E2E_015['stageNo']}
    Navigate To All Submissions page from submissions 
    Select Submission using submission id    ${submission}    @{TC_E2E_015['SubmissionColumnNames']}
    Wait For Processing Stage    ${TC_E2E_015['stageNo']}
    Run Keyword And Continue On Failure    Verify Summary Menu is displayed
    Switch To Summary Tab    ${TC_E2E_015['SummaryHeader']}
    Run Keyword And Continue On Failure    Verify Premium Amount   
    Run Keyword And Continue On Failure    Verify Summary Table Data    ${TC_E2E_015['SummaryTableHeader']}    ${TC_E2E_015['SummaryTableData']}
    Click Answers Tab
    Click Edit Submission
    Run Keyword And Continue On Failure    Verify Answers Lists    ${TC_E2E_015['expectedQuestion']}
    Run Keyword And Continue On Failure    Verify Risk360 Card Pages Navigation    ${TC_E2E_015['Risk360_Card_Names']}    ${TC_E2E_015['Risk360_Card_Pages_Names']}
    Create New Task    ${TC_E2E_015['taskdata']}
    Run Keyword And Continue On Failure    Verify the created task details    ${TC_E2E_015['taskDetails']}
    Create New Mail    ${TC_E2E_015['emailData']}
    Run Keyword And Continue On Failure    Verify Email Sent Successfully
    Run Keyword And Continue On Failure    Verify Sent Email    ${TC_E2E_015['emailVerify']}
    Upload SOV and Loss Run Documents    @{TC_E2E_015['FileName']}
    Wait for Upload to Complete for SOV and Loss Run    ${TC_E2E_015['stageNo']}
    Open uploaded SOV File   
    Run Keyword And Continue On Failure    Verify datas are matching for the uploaded SOV file    ${TC_E2E_003['SOVFile']}
    ${length}    Get Length    ${TC_E2E_003['dropdownOptions']}
    Run Keyword And Continue On Failure    Verify Properties datas for the given dropdown options    ${length}
    Run Keyword And Continue On Failure    Verify Claims Data From Loss Run File
    # Verify Policies Data From Loss Run File
    Run Keyword And Continue On Failure    Verify Analysis Data From Loss Run File    ${TC_E2E_015['CardName']}    ${TC_E2E_015['expectedAnalysisData']}    ${TC_E2E_015['expectedTableData']}
    # Verify Schema by downloading the json file
    Run Keyword And Continue On Failure    Verify WorkFlow History    ${TC_E2E_015['expectedWorkFlowHistory']}
    Save Submission And verify popup
    Run Keyword And Continue On Failure    Verify Submission updated in the Current Stage    ${TC_E2E_015['stageNo']}
    Run Keyword And Continue On Failure    Verify WorkFlow Options Advance Stage and Reject
    Run Keyword And Continue On Failure    Verify Referral Button 
    Create New Refer Submission    ${TC_E2E_015['Refer']}
    Run Keyword And Continue On Failure    Verify the Refer Submission data    ${TC_E2E_015['Refer']['expectedText']}    
    Run Keyword And Continue On Failure    Verify Referral Pending

TC_E2E_020  
    [Tags]    E2E-Referral
    [Documentation]    End to End Testing for New Submission - (Quoted stage)  with Referral Submission"
    ${submission_id}    Run Pre-requiste for Step 1 2 & 3
    Advance Stage    ${TC_E2E_020['stageNo']}
    Run Keyword And Continue On Failure    Verify Stage is updated in the submission    ${TC_E2E_020['stage']}
    Run Keyword And Continue On Failure    Verify Summary Menu is displayed
    Switch To Summary Tab    ${TC_E2E_020['SummaryHeader']}
    Run Keyword And Continue On Failure    Verify Policy Information In Summary Tab    ${TC_E2E_020['PolicyInfo']}   
    Run Keyword And Continue On Failure    Verify Summary Table Data    ${TC_E2E_020['SummaryTableHeader']}    ${TC_E2E_020['SummaryTableData']}
    Click Answers Tab
    Click Edit Submission
    Run Keyword And Continue On Failure    Verify Answers Lists    ${TC_E2E_020['expectedQuestion']}
    Run Keyword And Continue On Failure    Verify Risk360 Card Pages Navigation    ${TC_E2E_020['Risk360_Card_Names']}    ${TC_E2E_020['Risk360_Card_Pages_Names']}
    Create New Task    ${TC_E2E_020['taskdata']}
    Run Keyword And Continue On Failure    Verify the created task details    ${TC_E2E_020['taskDetails']}
    Create New Mail    ${TC_E2E_020['emailData']}
    Run Keyword And Continue On Failure    Verify Email Sent Successfully
    Run Keyword And Continue On Failure    Verify Sent Email    ${TC_E2E_020['emailVerify']}
    Upload SOV and Loss Run Documents    @{TC_E2E_020['FileName']}
    Wait for Upload to Complete for SOV and Loss Run    ${TC_E2E_020['stageNo']}
    Open uploaded SOV File   
    Run Keyword And Continue On Failure    Verify datas are matching for the uploaded SOV file    ${TC_E2E_003['SOVFile']}
    ${length}    Get Length    ${TC_E2E_003['dropdownOptions']}
    Run Keyword And Continue On Failure    Verify Properties datas for the given dropdown options    ${length}
    Run Keyword And Continue On Failure    Verify Claims Data From Loss Run File
    # Verify Policies Data From Loss Run File
    Run Keyword And Continue On Failure    Verify Analysis Data From Loss Run File    ${TC_E2E_020['CardName']}    ${TC_E2E_020['expectedAnalysisData']}    ${TC_E2E_020['expectedTableData']}
    # Verify Schema by downloading the json file
    Run Keyword And Continue On Failure    Verify WorkFlow History    ${TC_E2E_020['expectedWorkFlowHistory']}
    Save Submission And verify popup
    Run Keyword And Continue On Failure    Verify Submission updated in the Current Stage    ${TC_E2E_020['stageNo']}
    Run Keyword And Continue On Failure    Verify Referral Button 
    Create New Refer Submission    ${TC_E2E_020['Refer']}
    Run Keyword And Continue On Failure    Verify the Refer Submission data    ${TC_E2E_020['Refer']['expectedText']}    
    Run Keyword And Continue On Failure    Verify Referral Pending

TC_E2E_016
    [Tags]    E2E-LostSubmission   
    [Documentation]    End to End Testing for New Submission - (Under Review stage + Child submission)  with Lost"
    ${submission}    Run Pre-requiste Steps for Stage 1 & 2 
    Advance Stage    ${TC_E2E_016['stageNo']}    
    Run Keyword And Continue On Failure    Verify Stage is updated in the submission    ${TC_E2E_016['stage']}
    Click Edit Submission
    Click and verify Clearance tab
    Create Child Submission    ${TC_E2E_016['productName']}
    Wait For Processing Stage    ${TC_E2E_016['stageNo']}
    Navigate To All Submissions page from submissions 
    Select Submission using submission id    ${submission}    @{TC_E2E_016['SubmissionColumnNames']}
    Wait For Processing Stage    ${TC_E2E_016['stageNo']}
    Run Keyword And Continue On Failure    Verify Summary Menu is displayed
    Switch To Summary Tab    ${TC_E2E_016['SummaryHeader']}
    Run Keyword And Continue On Failure    Verify Premium Amount
    Run Keyword And Continue On Failure    Verify Summary Table Data    ${TC_E2E_016['SummaryTableHeader']}    ${TC_E2E_016['SummaryTableData']}
    Click Answers Tab
    Click Edit Submission
    Run Keyword And Continue On Failure    Verify Answers Lists    ${TC_E2E_016['expectedQuestion']}
    Run Keyword And Continue On Failure    Verify Risk360 Card Pages Navigation    ${TC_E2E_016['Risk360_Card_Names']}    ${TC_E2E_016['Risk360_Card_Pages_Names']}
    Create New Task    ${TC_E2E_016['taskdata']}
    Run Keyword And Continue On Failure    Verify the created task details    ${TC_E2E_016['taskDetails']}
    Create New Mail    ${TC_E2E_016['emailData']}
    Run Keyword And Continue On Failure    Verify Email Sent Successfully
    Run Keyword And Continue On Failure    Verify Sent Email    ${TC_E2E_016['emailVerify']}
    Upload SOV and Loss Run Documents    @{TC_E2E_016['FileName']}
    Wait for Upload to Complete for SOV and Loss Run    ${TC_E2E_016['stageNo']}
    Open uploaded SOV File   
    Run Keyword And Continue On Failure    Verify datas are matching for the uploaded SOV file    ${TC_E2E_003['SOVFile']}
    ${length}    Get Length    ${TC_E2E_003['dropdownOptions']}
    Run Keyword And Continue On Failure    Verify Properties datas for the given dropdown options    ${length}
    Run Keyword And Continue On Failure    Verify Claims Data From Loss Run File
    # Verify Policies Data From Loss Run File
    Run Keyword And Continue On Failure    Verify Analysis Data From Loss Run File    ${TC_E2E_016['CardName']}    ${TC_E2E_016['expectedAnalysisData']}    ${TC_E2E_016['expectedTableData']}
    # Verify Schema by downloading the json file
    Run Keyword And Continue On Failure    Verify WorkFlow History    ${TC_E2E_016['expectedWorkFlowHistory']}
    Save Submission And verify popup
    Run Keyword And Continue On Failure    Verify Submission updated in the Current Stage    ${TC_E2E_016['stageNo']}
    Run Keyword And Continue On Failure    Verify WorkFlow Options Advance Stage and Reject
    Lost Submission    ${TC_E2E_016['lost']}
    Run Keyword And Continue On Failure    Verify lost Tagname
    Reactive the Rejected Submission

TC_E2E_021  
    [Tags]    E2E-LostSubmission
    [Documentation]    End to End Testing for New Submission - (Quoted stage)  with Lost Submission"
    ${submission_id}    Run Pre-requiste for Step 1 2 & 3
    Advance Stage    ${TC_E2E_021['stageNo']}
    Run Keyword And Continue On Failure    Verify Stage is updated in the submission    ${TC_E2E_021['stage']}
    Run Keyword And Continue On Failure    Verify Summary Menu is displayed
    Switch To Summary Tab    ${TC_E2E_021['SummaryHeader']}
    Run Keyword And Continue On Failure    Verify Policy Information In Summary Tab    ${TC_E2E_021['PolicyInfo']}   
    Run Keyword And Continue On Failure    Verify Summary Table Data    ${TC_E2E_021['SummaryTableHeader']}    ${TC_E2E_021['SummaryTableData']}
    Click Answers Tab
    Click Edit Submission
    Run Keyword And Continue On Failure    Verify Answers Lists    ${TC_E2E_021['expectedQuestion']}
    Run Keyword And Continue On Failure    Verify Risk360 Card Pages Navigation    ${TC_E2E_021['Risk360_Card_Names']}    ${TC_E2E_021['Risk360_Card_Pages_Names']}
    Create New Task    ${TC_E2E_021['taskdata']}
    Run Keyword And Continue On Failure    Verify the created task details    ${TC_E2E_021['taskDetails']}
    Create New Mail    ${TC_E2E_021['emailData']}
    Run Keyword And Continue On Failure    Verify Email Sent Successfully
    Run Keyword And Continue On Failure    Verify Sent Email    ${TC_E2E_021['emailVerify']}
    Upload SOV and Loss Run Documents    @{TC_E2E_021['FileName']}
    Wait for Upload to Complete for SOV and Loss Run    ${TC_E2E_021['stageNo']}
    Open uploaded SOV File   
    Run Keyword And Continue On Failure    Verify datas are matching for the uploaded SOV file    ${TC_E2E_003['SOVFile']}
    ${length}    Get Length    ${TC_E2E_003['dropdownOptions']}
    Run Keyword And Continue On Failure    Verify Properties datas for the given dropdown options    ${length}
    Run Keyword And Continue On Failure    Verify Claims Data From Loss Run File
    # Verify Policies Data From Loss Run File
    Run Keyword And Continue On Failure    Verify Analysis Data From Loss Run File    ${TC_E2E_021['CardName']}    ${TC_E2E_021['expectedAnalysisData']}    ${TC_E2E_021['expectedTableData']}
    # Verify Schema by downloading the json file
    Run Keyword And Continue On Failure    Verify WorkFlow History    ${TC_E2E_021['expectedWorkFlowHistory']}
    Save Submission And verify popup
    Run Keyword And Continue On Failure    Verify Submission updated in the Current Stage    ${TC_E2E_021['stageNo']}
    Lost Submission    ${TC_E2E_021['lost']}
    Run Keyword And Continue On Failure    Verify lost Tagname

TC_E2E_022  
    [Tags]    E2E-NotTaken
    [Documentation]    End to End Testing for New Submission - (Quoted stage)  with Not Taken"
    ${submission_id}    Run Pre-requiste for Step 1 2 & 3
    Advance Stage    ${TC_E2E_022['stageNo']}
    Run Keyword And Continue On Failure    Verify Stage is updated in the submission    ${TC_E2E_022['stage']}
    Run Keyword And Continue On Failure    Verify Summary Menu is displayed
    Switch To Summary Tab    ${TC_E2E_022['SummaryHeader']}
    Run Keyword And Continue On Failure    Verify Policy Information In Summary Tab    ${TC_E2E_022['PolicyInfo']}   
    Run Keyword And Continue On Failure    Verify Summary Table Data    ${TC_E2E_022['SummaryTableHeader']}    ${TC_E2E_022['SummaryTableData']}
    Click Answers Tab
    Click Edit Submission
    Run Keyword And Continue On Failure    Verify Answers Lists    ${TC_E2E_022['expectedQuestion']}
    Run Keyword And Continue On Failure    Verify Risk360 Card Pages Navigation    ${TC_E2E_022['Risk360_Card_Names']}    ${TC_E2E_022['Risk360_Card_Pages_Names']}
    Create New Task    ${TC_E2E_022['taskdata']}
    Run Keyword And Continue On Failure    Verify the created task details    ${TC_E2E_022['taskDetails']}
    Create New Mail    ${TC_E2E_022['emailData']}
    Run Keyword And Continue On Failure    Verify Email Sent Successfully
    Run Keyword And Continue On Failure    Verify Sent Email    ${TC_E2E_022['emailVerify']}
    Upload SOV and Loss Run Documents    @{TC_E2E_022['FileName']}
    Wait for Upload to Complete for SOV and Loss Run    ${TC_E2E_022['stageNo']}
    Open uploaded SOV File   
    Run Keyword And Continue On Failure    Verify datas are matching for the uploaded SOV file    ${TC_E2E_022['SOVFile']}
    ${length}    Get Length    ${TC_E2E_003['dropdownOptions']}
    Run Keyword And Continue On Failure    Verify Properties datas for the given dropdown options    ${length}
    Run Keyword And Continue On Failure    Verify Claims Data From Loss Run File
    # Verify Policies Data From Loss Run File
    Run Keyword And Continue On Failure    Verify Analysis Data From Loss Run File    ${TC_E2E_022['CardName']}    ${TC_E2E_022['expectedAnalysisData']}    ${TC_E2E_022['expectedTableData']}
    # Verify Schema by downloading the json file
    Run Keyword And Continue On Failure    Verify WorkFlow History    ${TC_E2E_022['expectedWorkFlowHistory']}
    Save Submission And verify popup
    Run Keyword And Continue On Failure    Verify Submission updated in the Current Stage    ${TC_E2E_022['stageNo']}
    Run Keyword And Continue On Failure    Not Taken and Verify the Tag name    ${TC_E2E_022['NotTakenReasons']}    ${TC_E2E_022['NotTakenDetails']}    ${TC_E2E_022['Action']}


TC_E2E_004
    [Tags]    E2E-SanctionScreening
    [Documentation]    End to End Testing for New Submission - In Draft Stage: Sanction Screening Flagged with "False Positive"
    Create User If the User is not present    ${NewUser}
    Select Impersonate option from the actions    ${NewUser['email']}    ${NewUser['search_user']}
    Run Keyword And Continue On Failure    Verify My Assignments Tab is displayed as a default tab
    ${submission_id}    Create New Submission    ${TC_E2E_004['FileName']}    @{TC_E2E_004['SubmissionColumnNames']}   
    Select Submission using submission id     ${submission_id}    @{TC_E2E_004['SubmissionColumnNames']}
    Run Keyword And Continue On Failure    Verify Submission page is displayed
    Click Edit Submission
    Click and verify Clearance tab
    Click Insured Tab
    Run Keyword And Continue On Failure    Verify PDF Data in Insured Tab    @{TC_E2E_004['expectedPDFText']}
    Fill the data for issue fields    ${TC_E2E_004['SicCode']}    ${TC_E2E_004['SicDescription']}    ${TC_E2E_004['NAICSCode']}
    Run Keyword And Continue On Failure    Verify User Mod is message for updated fields
    Click Processing Tab
    Fill the data for issue fields in processing    ${TC_E2E_004['UnderwriterName']}    ${TC_E2E_004['UnderwriterEmail']}    ${TC_E2E_004['OperationsName']}      
    ...    ${TC_E2E_004['OperationsEmail']}    ${TC_E2E_004['UnderwrittingOffice']}    ${TC_E2E_004['Channel']}
    Click Producer Tab
    Run Keyword And Continue On Failure    Verify PDF Data in Producer Tab    @{TC_E2E_004['expectedTextInProducer']}
    Fill the data for issues field in Producer    ${TC_E2E_004['ProducerName']}      ${TC_E2E_004['ProducerEmail']}    ${TC_E2E_004['ProducerCode']}
    Click Coverage Tab
    Run Keyword And Continue On Failure    Verify the Coverage data    ${TC_E2E_004['EffectiveDate']}     ${TC_E2E_004['ExpirationDate']}     ${TC_E2E_004['Product']}
    Fill the data for issues field in Coverage    ${TC_E2E_004['Covered']}
    Click Issues Tab
   @{expectedIssues}    Create List    ${TC_E2E_004['SicCode']}    ${TC_E2E_004['SicDescription']} 
     ...    ${TC_E2E_004['NAICSCode']}    ${TC_E2E_004['UnderwriterName']}    ${TC_E2E_004['UnderwriterEmail']} 
     ...    ${TC_E2E_004['UnderwrittingOffice']}     ${TC_E2E_004['OperationsName']}    ${TC_E2E_004['OperationsEmail']}   
     ...    ${TC_E2E_004['Channel']}    ${TC_E2E_004['ProducerName']}
    Run Keyword And Continue On Failure    Verify updated datas in Issues Tab    @{expectedIssues}
    Click Finish Tab
    Run Keyword And Continue On Failure    Verify and click the save and close button
    Switch to Documents
   @{expectedModification}    Create List    "${TC_E2E_004['SicCode']}"    "${TC_E2E_004['SicDescription']}"  
     ...    "${TC_E2E_004['NAICSCode']}"    "${TC_E2E_004['UnderwriterName']}"    "${TC_E2E_004['UnderwriterEmail']}"   
     ...    "${TC_E2E_004['UnderwrittingOffice']}"     "${TC_E2E_004['OperationsName']}"    "${TC_E2E_004['OperationsEmail']}"    "${TC_E2E_004['Channel']}"   
     ...    "${TC_E2E_004['ProducerName']}"    "${TC_E2E_004['ProducerCode']}"    "${TC_E2E_004['ProducerEmail']}"    "${TC_E2E_004['Covered']['Product']}"    "${TC_E2E_004['Covered']['ProductSegment']}" 
    Run Keyword And Continue On Failure    Verify datas in UserModification file    @{expectedModification}
    Run Keyword And Continue On Failure    Verify WorkFlow History is Empty For Draft stage
    Save Submission And verify popup
    Run Keyword And Continue On Failure    Verify Submission updated
    Navigate To All Submissions page from submissions
    Select Submission using submission id    ${submission_id}    @{TC_E2E_004['SubmissionColumnNames']}
    Run Keyword And Continue On Failure    Verify Submission page is displayed
    Run Keyword And Continue On Failure    Verify Sanction Screening Flagged is visible in the submission
    Run Keyword And Continue On Failure    Verify Task Number in the submission    ${TC_E2E_004['taskNumber']}
    Run Keyword And Continue On Failure    Verify and click the Task In Submission
    Run Keyword And Continue On Failure    Verify the auto generated task details    ${TC_E2E_004['taskDetails']}
    Complete Task with the given reason    ${TC_E2E_004['reason']}
    Run Keyword And Continue On Failure    Verify the task is completed and sanction label is appears as per the reason    ${TC_E2E_004['reason']}
    Run Keyword And Continue On Failure    Verify Sanction Screening Flagged is not visible

TC_E2E_005
    [Tags]    E2E-SanctionScreening
    [Documentation]    End to End Testing for New Submission - In Draft Stage: Sanction Screening Flagged with "Confirmed – TRUE HIT"
    Create User If the User is not present    ${NewUser}
    Select Impersonate option from the actions    ${NewUser['email']}    ${NewUser['search_user']}
    Run Keyword And Continue On Failure    Verify My Assignments Tab is displayed as a default tab
    ${submission_id}    Create New Submission    ${TC_E2E_005['FileName']}    @{TC_E2E_005['SubmissionColumnNames']}
    Select Submission using submission id     ${submission_id}    @{TC_E2E_005['SubmissionColumnNames']}
    Run Keyword And Continue On Failure    Verify Submission page is displayed
    Click Edit Submission
    Click and verify Clearance tab
    Click Insured Tab
    Run Keyword And Continue On Failure    Verify PDF Data in Insured Tab    @{TC_E2E_005['expectedPDFText']}
    Fill the data for issue fields    ${TC_E2E_005['SicCode']}    ${TC_E2E_005['SicDescription']}    ${TC_E2E_005['NAICSCode']}
    Run Keyword And Continue On Failure    Verify User Mod is message for updated fields
    Click Processing Tab
     Fill the data for issue fields in processing    ${TC_E2E_005['UnderwriterName']}    ${TC_E2E_005['UnderwriterEmail']} 
     ...    ${TC_E2E_005['OperationsName']}    ${TC_E2E_005['OperationsEmail']}    ${TC_E2E_005['UnderwrittingOffice']}    ${TC_E2E_005['Channel']}
    Click Producer Tab
    Run Keyword And Continue On Failure    Verify PDF Data in Producer Tab    @{TC_E2E_005['expectedTextInProducer']}
    Fill the data for issues field in Producer    ${TC_E2E_005['ProducerName']}      ${TC_E2E_005['ProducerEmail']}    ${TC_E2E_005['ProducerCode']}
    Click Coverage Tab
    Run Keyword And Continue On Failure    Verify the Coverage data    ${TC_E2E_005['EffectiveDate']}     ${TC_E2E_005['ExpirationDate']}     ${TC_E2E_005['Product']}
    Fill the data for issues field in Coverage    ${TC_E2E_005['Covered']}
    Click Issues Tab
     @{expectedIssues}    Create List    ${TC_E2E_005['SicCode']}    ${TC_E2E_005['SicDescription']} 
     ...    ${TC_E2E_005['NAICSCode']}    ${TC_E2E_005['UnderwriterName']}    ${TC_E2E_005['UnderwriterEmail']} 
     ...    ${TC_E2E_005['UnderwrittingOffice']}     ${TC_E2E_005['OperationsName']}    ${TC_E2E_005['OperationsEmail']}   
     ...    ${TC_E2E_005['Channel']}    ${TC_E2E_005['ProducerName']}
    Run Keyword And Continue On Failure    Verify updated datas in Issues Tab    @{expectedIssues}
    Run Keyword And Continue On Failure    Verify updated datas in Issues Tab    @{expectedIssues}
    Click Finish Tab
    Run Keyword And Continue On Failure    Verify and click the save and close button
    Switch to Documents
     @{expectedModification}    Create List    "${TC_E2E_005['SicCode']}"    "${TC_E2E_005['SicDescription']}"  
     ...    "${TC_E2E_005['NAICSCode']}"    "${TC_E2E_005['UnderwriterName']}"    "${TC_E2E_005['UnderwriterEmail']}"   
     ...    "${TC_E2E_005['UnderwrittingOffice']}"     "${TC_E2E_005['OperationsName']}"    "${TC_E2E_005['OperationsEmail']}"    "${TC_E2E_005['Channel']}"   
     ...    "${TC_E2E_005['ProducerName']}"    "${TC_E2E_005['ProducerCode']}"     "${TC_E2E_005['ProducerEmail']}"    "${TC_E2E_005['Covered']['Product']}"    "${TC_E2E_005['Covered']['ProductSegment']}" 
    Run Keyword And Continue On Failure    Verify datas in UserModification file    @{expectedModification}
    Run Keyword And Continue On Failure    Verify WorkFlow History is Empty For Draft stage
    Save Submission And verify popup
    Run Keyword And Continue On Failure    Verify Submission updated
    Navigate To All Submissions page from submissions
    Select Submission using submission id    ${submission_id}     @{TC_E2E_005['SubmissionColumnNames']}    
    Run Keyword And Continue On Failure    Verify Submission page is displayed
    Run Keyword And Continue On Failure    Verify Sanction Screening Flagged is visible in the submission
    Run Keyword And Continue On Failure    Verify Task Number in the submission    ${TC_E2E_005['taskNumber']}
    Run Keyword And Continue On Failure    Verify and click the Task In Submission
    Run Keyword And Continue On Failure    Verify the auto generated task details    ${TC_E2E_005['taskDetails']}
    Complete Task with the given reason    ${TC_E2E_005['reason']}
    Run Keyword And Continue On Failure    Verify the task is completed and sanction label is appears as per the reason    ${TC_E2E_005['reason']}

TC_E2E_006
    [Tags]    E2E-SanctionScreening
    [Documentation]    End to End Testing for New Submission - In Draft Stage: Sanction Screening Flagged with "Confirmed – NO HIT"
    Create User If the User is not present    ${NewUser}
    Select Impersonate option from the actions    ${NewUser['email']}    ${NewUser['search_user']}
    Run Keyword And Continue On Failure    Verify My Assignments Tab is displayed as a default tab
    ${submission_id}    Create New Submission    ${TC_E2E_006['FileName']}    @{TC_E2E_006['SubmissionColumnNames']}
    Select Submission using submission id     ${submission_id}    @{TC_E2E_006['SubmissionColumnNames']}
    Run Keyword And Continue On Failure    Verify Submission page is displayed
    Click Edit Submission
    Click and verify Clearance tab
    Click Insured Tab
    Run Keyword And Continue On Failure    Verify PDF Data in Insured Tab    @{TC_E2E_006['expectedPDFText']}
    Fill the data for issue fields    ${TC_E2E_006['SicCode']}    ${TC_E2E_006['SicDescription']}    ${TC_E2E_006['NAICSCode']}
    Run Keyword And Continue On Failure    Verify User Mod is message for updated fields
    Click Processing Tab
    Fill the data for issue fields in processing    ${TC_E2E_006['UnderwriterName']}    ${TC_E2E_006['UnderwriterEmail']} 
     ...    ${TC_E2E_006['OperationsName']}    ${TC_E2E_006['OperationsEmail']}    ${TC_E2E_006['UnderwrittingOffice']}    ${TC_E2E_006['Channel']}
    Click Producer Tab
    Run Keyword And Continue On Failure    Verify PDF Data in Producer Tab    @{TC_E2E_006['expectedTextInProducer']}
    Fill the data for issues field in Producer    ${TC_E2E_006['ProducerName']}      ${TC_E2E_006['ProducerEmail']}    ${TC_E2E_006['ProducerCode']}
    Click Coverage Tab
    Run Keyword And Continue On Failure    Verify the Coverage data    ${TC_E2E_006['EffectiveDate']}     ${TC_E2E_006['ExpirationDate']}     ${TC_E2E_006['Product']}
   Fill the data for issues field in Coverage    ${TC_E2E_006['Covered']}
    Click Issues Tab
     @{expectedIssues}    Create List    ${TC_E2E_006['SicCode']}    ${TC_E2E_006['SicDescription']} 
     ...    ${TC_E2E_006['NAICSCode']}    ${TC_E2E_006['UnderwriterName']}    ${TC_E2E_006['UnderwriterEmail']} 
     ...    ${TC_E2E_006['UnderwrittingOffice']}     ${TC_E2E_006['OperationsName']}    ${TC_E2E_006['OperationsEmail']}   
     ...    ${TC_E2E_006['Channel']}    ${TC_E2E_006['ProducerName']}
    Run Keyword And Continue On Failure    Verify updated datas in Issues Tab    @{expectedIssues}
    Click Finish Tab
    Run Keyword And Continue On Failure    Verify and click the save and close button
    Switch to Documents
    @{expectedModification}    Create List    "${TC_E2E_006['SicCode']}"    "${TC_E2E_006['SicDescription']}"  
     ...    "${TC_E2E_006['NAICSCode']}"    "${TC_E2E_006['UnderwriterName']}"    "${TC_E2E_006['UnderwriterEmail']}"   
     ...    "${TC_E2E_006['UnderwrittingOffice']}"     "${TC_E2E_006['OperationsName']}"    "${TC_E2E_006['OperationsEmail']}"    "${TC_E2E_006['Channel']}"   
     ...    "${TC_E2E_006['ProducerName']}"    "${TC_E2E_006['ProducerCode']}"     "${TC_E2E_006['ProducerEmail']}"    "${TC_E2E_006['Covered']['Product']}"    "${TC_E2E_006['Covered']['ProductSegment']}" 
    Run Keyword And Continue On Failure    Verify datas in UserModification file    @{expectedModification}
    Run Keyword And Continue On Failure    Verify WorkFlow History is Empty For Draft stage
    Save Submission And verify popup
    Run Keyword And Continue On Failure    Verify Submission updated
    Navigate To All Submissions page from submissions
    Select Submission using submission id    ${submission_id}    @{TC_E2E_006['SubmissionColumnNames']}
    Run Keyword And Continue On Failure    Verify Submission page is displayed
    Run Keyword And Continue On Failure    Verify Sanction Screening Flagged is visible in the submission
    Run Keyword And Continue On Failure    Verify Task Number in the submission    ${TC_E2E_006['taskNumber']}
    Run Keyword And Continue On Failure    Verify and click the Task In Submission
    Run Keyword And Continue On Failure    Verify the auto generated task details    ${TC_E2E_006['taskDetails']}
    Complete Task with the given reason    ${TC_E2E_006['reason']}
    Run Keyword And Continue On Failure    Verify the task is completed and sanction label is appears as per the reason    ${TC_E2E_006['reason']}
    Run Keyword And Continue On Failure    Verify Sanction Screening Flagged is not visible

TC_E2E_050
    Run Keyword And Continue On Failure    Verify My Assignments Tab is displayed as a default tab
    
    Run Keyword And Continue On Failure    Verify System displays task reassignment pop-up for completed tasks    ${TC_E2E_050['Column_Name']}    ${TC_E2E_050['Cant_Reassign_msg']}    ${TC_E2E_050['Assign_To']}
    Run Keyword And Continue On Failure    verify the Effective date in Convr Task Tab    ${TC_E2E_050['Column_Name']}    ${TC_E2E_050['Date']}    ${TC_E2E_050['date1']}
   ${submission_id}    Create new submission in processing    ${TC_E2E_050['FileName']}    @{TC_E2E_050['SubmissionColumnNames']}
    Select Submission using submission id     ${submission_id}    @{TC_E2E_050['SubmissionColumnNames']}
    Run Keyword And Continue On Failure    verify that the Reprocess button is not Available in Document Tab    ${TC_E2E_050['New_Asset_Option']}
    

TC_E2E_051

    [Tags]    Email_files

    Run Keyword And Continue On Failure    Verify My Assignments Tab is displayed as a default tab
    ${submission_id}    Create New Submission    ${TC_E2E_051['FileName']}    @{TC_E2E_006['SubmissionColumnNames']}
    Select Submission using submission id     ${submission_id}    @{TC_E2E_006['SubmissionColumnNames']}
    Verify All Side menu options are Displayed    ${TC_E2E_051['excepted_Field']}
    Run Keyword And Continue On Failure    verify the Email Body Document    ${TC_E2E_051['Expected_email_Msg']}
    Switch to Summary    
    Run Keyword And Continue On Failure    Verify datas in Underwriter Reference file    ${TC_E2E_051['Expected_UnderWriter_Value']}   
    Click and verify Clearance tab 
     Click Processing Tab
    ${elements}    Get Elements    ${underwriter_reference_lookup}
    ${Actual_length}    Get Length    ${elements}
    ${Expected_Length}    Convert To Integer    ${TC_E2E_051['Expected_length']}
    Run Keyword And Continue On Failure    Should Be Equal    ${Expected_Length}    ${Actual_length}
    Run Keyword And Continue On Failure    Verify the Eml data in processing tab    ${TC_E2E_051['Expected_Processing_Value']}
    Click Producer Tab
    Run Keyword And Continue On Failure    Verify Eml Data in Producer Tab    ${TC_E2E_051['Expected_Producer_Value']} 
     Click Coverage Tab
    ${Product_Name}    Get Text    ${CoverageProductButton}  
    Run Keyword And Continue On Failure    Should Be Equal    ${TC_E2E_051['property_Value']}    ${Product_Name} 
    ${Product_Segment_Name}    Get Text    ${Clearance_Product_Segment}  
    Run Keyword And Continue On Failure    Should Be Equal    ${TC_E2E_051['Property_Segment_value']}    ${Product_Segment_Name}

    
TC_E2E_052
    [Tags]    Email_files

    Run Keyword And Continue On Failure    Verify My Assignments Tab is displayed as a default tab
      ${submission_id}    Create New Submission    ${TC_E2E_052['FileName']}    @{TC_E2E_006['SubmissionColumnNames']}
    Select Submission using submission id     ${submission_id}    @{TC_E2E_006['SubmissionColumnNames']}
    Verify All Side menu options are Displayed    ${TC_E2E_052['excepted_Field']}
    Run Keyword And Continue On Failure    verify the Email Body Document    ${TC_E2E_052['Expected_email_Msg']}
    Switch to Summary    
    Run Keyword And Continue On Failure    Verify datas in Underwriter Reference file    ${TC_E2E_052['Expected_UnderWriter_Value']}   
    Click and verify Clearance tab 
    Click Insured Tab
    ${Actual_InsuredName}    Get Text    ${InsuredName}
    Run Keyword And Continue On Failure    Should Be Equal    ${TC_E2E_052['Expected_InsuredName']}    ${Actual_InsuredName}
    Click Processing Tab
    ${elements}    Get Elements    ${underwriter_reference_lookup}
    ${Actual_length}    Get Length    ${elements}
    ${Expected_Length}    Convert To Integer    ${TC_E2E_052['Expected_length']}
    Run Keyword And Continue On Failure    Should Be Equal    ${Expected_Length}    ${Actual_length}
    Run Keyword And Continue On Failure    Verify the Eml data in processing tab    ${TC_E2E_052['Expected_Processing_Value']}
    Click Producer Tab
    Run Keyword And Continue On Failure    Verify Eml Data in Producer Tab    ${TC_E2E_052['Expected_Producer_Value']}
    Click Coverage Tab
    ${elements}    Get Elements    ${underwriter_reference_lookup}
    ${Actual_length}    Get Length    ${elements}
    ${Expected_Length}    Convert To Integer    ${TC_E2E_053['Expected_length']}
    ${Product_Name}    Get Text    ${EmptyProductType}  
    Run Keyword And Continue On Failure    Should Be Equal    ${TC_E2E_052['property_Value']}    ${Product_Name} 
    ${Product_Segment_Name}    Get Text    ${ProductSegment}  
    Run Keyword And Continue On Failure    Should Be Equal    ${TC_E2E_052['Property_Segment_value']}    ${Product_Segment_Name}


TC_E2E_053
    [Tags]    Email_files

    Run Keyword And Continue On Failure    Verify My Assignments Tab is displayed as a default tab
      ${submission_id}    Create New Submission    ${TC_E2E_053['FileName']}    @{TC_E2E_006['SubmissionColumnNames']}
    Select Submission using submission id     ${submission_id}    @{TC_E2E_006['SubmissionColumnNames']}
    Run Keyword And Continue On Failure    verify the Email Body Document    ${TC_E2E_053['Expected_email_Msg']}
    Click Answers Tab
    Switch to Documents
    Run Keyword And Continue On Failure    Get Element States    ${Acord_125_loc}    validate    value & visible
    Run Keyword And Continue On Failure    Get Element States    ${Acord_140_loc}    validate    value & visible
    Run Keyword And Continue On Failure    Get Element States    ${SOV}    validate    value & visible
    Run Keyword And Continue On Failure    Get Element States    ${Broker_form_loc}    validate    value & visible
    Run Keyword And Continue On Failure    Get Element States    ${Loss_run_EASTERNALLIANCE}    validate    value & visible
    Run Keyword And Continue On Failure    Get Element States    ${LossRunFile}    validate    value & visible
    Click Answers Tab    
    Verify All Side menu options are Displayed    ${TC_E2E_053['excepted_Field']}    
    Run Keyword And Continue On Failure    Verify datas in Underwriter Reference file    ${TC_E2E_053['Expected_UnderWriter_Value']}   
    Click and verify Clearance tab
    Run Keyword And Continue On Failure    Verify PDF Data in Insured Tab    ${TC_E2E_053['excepted_Insured_Value']}
    # Scroll To    ${InsuredNAICSCode}    top
    # Get Element States    ${InsuredNAICSCode}    validate    value & visible    'InsuredNAICSCode should be visible.'
    # Click With Options    ${InsuredNAICSCode}    clickCount=2
    # Sleep    2s
    # Type Text    ${InsuredNAICSInput}    ${TC_E2E_053['excepted_Insured_Value']}
    Click Processing Tab
     Run Keyword And Continue On Failure    Fill the data for issue fields in processing    ${TC_E2E_053['UnderwriterName']}    ${TC_E2E_053['UnderwriterEmail']}    ${TC_E2E_053['OperationsName']}        ${TC_E2E_053['OperationsEmail']}    ${TC_E2E_053['UnderwrittingOffice']}    ${TC_E2E_053['Channel']}
    Click Producer Tab
    Run Keyword And Continue On Failure    Verify EML PDF Data in Producer Tab    ${TC_E2E_053['expected_Producer_Value']}
    Click Coverage Tab
    Run Keyword And Continue On Failure    Verify EML Data the Coverage Tab     ${TC_E2E_053['Coverage_eff_date']}     ${TC_E2E_053['Coverage_exp_date']}     ${TC_E2E_053['property_Value']}     ${TC_E2E_053['Property_Segment_value']}     ${TC_E2E_053['Facultative_Reinsurance_value']}
     Click Finish Tab
    Run Keyword And Continue On Failure    Verify and click the save and close button
     Save Submission And verify popup
    # Run Keyword And Continue On Failure    Verify Submission updated

*** Keywords ***
Run Pre-requiste Steps for Stage 1
    Create User If the User is not present    ${NewUser}
    Create User If the User is not present    ${ReferralUser}
    Select Impersonate option from the actions    ${NewUser['email']}    ${NewUser['search_user']}
    Run Keyword And Continue On Failure    Verify My Assignments Tab is displayed as a default tab
    ${submission_id}    Create New Submission    ${TC_E2E_001['FileName']}    @{TC_E2E_001['SubmissionColumnNames']}
    Select Submission using submission id    ${submission_id}    @{TC_E2E_001['SubmissionColumnNames']}
    Run Keyword And Continue On Failure    Verify Submission page is displayed
    Click Edit Submission
    Click and verify Clearance tab
    Click Insured Tab
    Fill the data for issue fields    ${TC_E2E_001['SicCode']}    ${TC_E2E_001['SicDescription']}    ${TC_E2E_001['NAICSCode']}
    Click Processing Tab
    Fill the data for issue fields in processing    ${TC_E2E_001['UnderwriterName']}    ${TC_E2E_001['UnderwriterEmail']}    ${TC_E2E_001['OperationsName']}        ${TC_E2E_001['OperationsEmail']}    ${TC_E2E_001['UnderwrittingOffice']}    ${TC_E2E_001['Channel']}
    Click Producer Tab
    Fill the data for issues field in Producer    ${TC_E2E_001['ProducerName']}      ${TC_E2E_001['ProducerEmail']}
    Click Coverage Tab
    Fill the data for issues field in Coverage    ${TC_E2E_001['Covered']} 
    Click Finish Tab
    Run Keyword And Continue On Failure    Verify and click the save and close button
    Save Submission And verify popup
    Run Keyword And Continue On Failure    Verify Submission updated
    RETURN    ${submission_id}
Run Pre-requiste Steps for Stage 1 & 2
    Create User If the User is not present    ${NewUser}
    Create User If the User is not present    ${ReferralUser}
    Select Impersonate option from the actions    ${NewUser['email']}    ${NewUser['search_user']}
    Run Keyword And Continue On Failure    Verify My Assignments Tab is displayed as a default tab
    ${submission_id}    Create New Submission    ${TC_E2E_001['FileName']}    @{TC_E2E_001['SubmissionColumnNames']}
    Select Submission using submission id    ${submission_id}    @{TC_E2E_001['SubmissionColumnNames']}
    Run Keyword And Continue On Failure    Verify Submission page is displayed
    Click Edit Submission
    Click and verify Clearance tab
    Click Insured Tab
    Fill the data for issue fields    ${TC_E2E_001['SicCode']}    ${TC_E2E_001['SicDescription']}    ${TC_E2E_001['NAICSCode']}
    Click Processing Tab
    Fill the data for issue fields in processing    ${TC_E2E_001['UnderwriterName']}    ${TC_E2E_001['UnderwriterEmail']}    ${TC_E2E_001['OperationsName']}        ${TC_E2E_001['OperationsEmail']}    ${TC_E2E_001['UnderwrittingOffice']}    ${TC_E2E_001['Channel']}
    Click Producer Tab
    Fill the data for issues field in Producer    ${TC_E2E_001['ProducerName']}      ${TC_E2E_001['ProducerEmail']}
    Click Coverage Tab
    Fill the data for issues field in Coverage    ${TC_E2E_001['Covered']} 
    Click Finish Tab
    Run Keyword And Continue On Failure    Verify and click the save and close button
    Save Submission And verify popup
    Run Keyword And Continue On Failure    Verify Submission updated
    Advance Stage 2
    Run Keyword And Continue On Failure    Verify Stage is updated in the submission    ${TC_E2E_007['stage']}
    Click Edit Submission
    Save Submission And verify popup
    Run Keyword And Continue On Failure    Verify Submission updated in Stage 2
    RETURN    ${submission_id}

Run Pre-requiste for Step 1 2 & 3
    ${submission_id}    Run Pre-requiste Steps for Stage 1 & 2
    Click Answers Tab
    Advance Stage    ${TC_E2E_011['stageNo']}    
    Click Answers Tab
    Run Keyword And Continue On Failure    Verify Stage is updated in the submission    ${TC_E2E_011['stage']}
    Click Edit Submission
    Click and verify Clearance tab
    Create Child Submission    ${TC_E2E_011['productName']}
    Wait For Processing Stage    ${TC_E2E_011['stageNo']} 
    Navigate To All Submissions page from submissions 
    Select Submission using submission id    ${submission_id}    @{TC_E2E_011['SubmissionColumnNames']}
    Wait For Processing Stage    ${TC_E2E_011['stageNo']}
    Click Answers Tab
    Click Edit Submission
    Save Submission And verify popup
    Run Keyword And Continue On Failure    Verify Submission updated in the Current Stage    ${TC_E2E_011['stageNo']}
    ${newSubmissionID}    Get New Submission ID After Child Submission
    RETURN    ${newSubmissionID}


    
