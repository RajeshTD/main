*** Settings ***
Resource    ../../utils/common_keywords.robot
Library    ../../libraries/ScreenshotListener.py    True
Suite Setup    Run Pre-requiste for Step 1 2 & 3
#Suite Setup    Launch URL and Login in to the application    
Suite Teardown    Run Keywords    Close Context    Close Browser
 
*** Test Cases ***
TC_Forms_001  
    [Documentation]    End to End Testing for Policy Instruction Form"
     #${submission_id}    Run Pre-requiste for Step 1 2 & 3
    # Launch URL and Login in to the application 
    # Create User If the User is not present    ${NewUser}
    # Select Impersonate option from the actions    ${NewUser['email']}    ${NewUser['search_user']}
    # Verify My Assignments Tab is displayed as a default tab
    # Select Submission using submission id    ${submission_id}   @{TC_E2E_002['SubmissionColumnNames']}
    # Verify Submission page is displayed
    Navigate to Form
    Switch to Policy Instruction Form
    Verify Form Summary Headers    ${TC_Forms_001['PrimaryProperty']}
    #Verify Form Summary Details    ${TC_Forms_001['PrimaryProperty']}
    Verify Form Policy Instruction Form General Details    ${TC_Forms_001['PrimaryProperty']}
    Verify Form Policy Instruction Form Indured Tab Details    ${TC_Forms_001['PrimaryProperty']}    
    Verify Form Policy Instruction Form Producer Details    ${TC_Forms_001['PrimaryProperty']}
    Verify Form Policy Instruction Form Processing Details    ${TC_Forms_001['PrimaryProperty']}
    Verify Form Policy Instruction Form Underwritting Details    ${TC_Forms_001['PrimaryProperty']}
    Verify Form Policy Instruction Form Hazard Grade Details    ${TC_Forms_001['PrimaryProperty']}
    Verify Form Policy Instruction Form Reinsurance Details    ${TC_Forms_001['PrimaryProperty']}
    Verify Form Policy Instruction Form Instruction Details    ${TC_Forms_001['PrimaryProperty']}
    Save Changes in Form    ${TC_Forms_001}
    #Complete Form
TC_Forms_002
    [Documentation]   Forms Testing for NY Free Trade Zone Form"
    # ${submission_id}    Run Pre-requiste for Step 1 2 & 3
    # Launch URL and Login in to the application 
    # Create User If the User is not present    ${NewUser}
    # Select Impersonate option from the actions    ${NewUser['email']}    ${NewUser['search_user']}
    # Verify My Assignments Tab is displayed as a default tab
    # Select Submission using submission id    ${submission_id}   @{TC_E2E_002['SubmissionColumnNames']}
    # Verify Submission page is displayed
    Navigate to Form
    Switch To NY FreeTrade Zone
    Verify Form NY Free Trade Zone Instructions    ${TC_Forms_002['ExpectedInstructionsValues']}
    Verify Form NY Free Trade Zone Documentation    ${TC_Forms_002['DocumentationData']}
    Form NY Free Trade Zone Eligibility    ${TC_Forms_002['EligibilityData']}
    Form NY Free Trade Zone Exposures    ${TC_Forms_002['ExposuresData']}
    Form NY Free Trade Zone Underwriting Evaluation    ${TC_Forms_002['UnderwritingEvaluationData']}
    Save Changes in Form    ${TC_Forms_002}
 
TC_Forms_003
    [Documentation]    Rate Form
    # Launch URL and Login in to the application 
    # Create User If the User is not present    ${NewUser}
    # Select Impersonate option from the actions    ${NewUser['email']}    ${NewUser['search_user']}
    # Verify My Assignments Tab is displayed as a default tab
    # Select Submission using submission id    ${submission_id}   @{TC_E2E_002['SubmissionColumnNames']}
    # Verify Submission page is displayed
    Navigate to Form
    Switch to Rate Form
    Select Reason For Documentation    ${TC_Forms_003['ReasonForDocumentation']}    ${TC_Forms_003['ReasonCardText']}
    General Section In Rate Form    ${TC_Forms_003['GeneralSectionText']}    ${TC_Forms_003['GeneralSectionData']}
    Deviated Rate Locations    ${TC_Forms_003['DeviatedRateLocations']}    ${TC_Forms_003['DeviatedRateLocationsData']}
    Deviated Rate Coverage    ${TC_Forms_003['DeviatedRateCoverage']}    ${TC_Forms_003['DeviatedRateCoverageData']}
    Rating Detail    ${TC_Forms_003['RatingDetailText']}    ${TC_Forms_003['RatingDetailData']}
    # Upload Relevant Documents for Rate    ${TC_Forms_003['RatingDetailData']}
    Save Changes in Form    ${TC_Forms_003['RatingDetailData']}
TC_Forms_004  
    [Documentation]    End to End Testing for Manuscript Tab"
    # ${submission_id}    Run Pre-requiste for Step 1 2 & 3
    # Launch URL and Login in to the application 
    # Create User If the User is not present    ${NewUser}
    # Select Impersonate option from the actions    ${NewUser['email']}    ${NewUser['search_user']}
    # Verify My Assignments Tab is displayed as a default tab
    # Select Submission using submission id    ${submission_id}   @{TC_E2E_002['SubmissionColumnNames']}
    # Verify Submission page is displayed
    Navigate to Form  
    Switch To Manuscript Tab
    Verify Manuscript Tab Header    ${TC_Forms_004['manuscriptHeader']}
    Reason for Documentation    ${TC_Forms_004['Reason_Tab_Header']}    ${TC_Forms_004['DeregulationHeader']}
    General Tab    ${TC_Forms_004['General_tab_Header']}    ${TC_Forms_004['GenaralDetails']}
    Refer to Lines of Business    ${TC_Forms_004['ReferToLinesHeader']}    @{TC_Forms_004['checkBoxHeader']}
    Insured Information    ${TC_Forms_004['Insured_State']}
    ManuScript Details    ${TC_Forms_004['ManuscriptForm_Desc']}    ${TC_Forms_004['Desc_Explore']}
    Upload Relevant Documents for Manuscript    ${TC_Forms_004}
    Save Changes in Form    ${TC_Forms_004}
 
TC_Forms_005  
    [Documentation]    End to End Testing for Manuscript Tab"
    # ${submission_id}    Run Pre-requiste for Step 1 2 & 3
    # Launch URL and Login in to the application 
    # Create User If the User is not present    ${NewUser}
    # Select Impersonate option from the actions    ${NewUser['email']}    ${NewUser['search_user']}
    # Verify My Assignments Tab is displayed as a default tab
    # Select Submission using submission id    ${submission_id}   @{TC_E2E_002['SubmissionColumnNames']}
    # Verify Submission page is displayed
    Navigate to Form  
    Switch to Company Underwriting Eligibility Form
    Verify Form Company Underwriting Eligibility General    ${TC_Forms_005['GeneralData']}
    Verify Form Company Underwriting Eligibility Total Points    ${TC_Forms_005['TotalPoints']}
    Verify Form Company Underwriting Eligibility Management Attitude    ${TC_Forms_005['ManagementAttitudevalues']}
    Verify Form Company Underwriting Eligibility Company Inspection Details    ${TC_Forms_005['CompanyInspectionValues']}
    Save Changes in Form    ${TC_Forms_005}
 
TC_Forms_006  
    [Documentation]    End to End Testing for Manuscript Tab"
    # ${submission_id}    Run Pre-requiste for Step 1 2 & 3
    # Launch URL and Login in to the application 
    # Create User If the User is not present    ${NewUser}
    # Select Impersonate option from the actions    ${NewUser['email']}    ${NewUser['search_user']}
    # Verify My Assignments Tab is displayed as a default tab
    # Select Submission using submission id    ${submission_id}   @{TC_E2E_002['SubmissionColumnNames']}
    # Verify Submission page is displayed
    Navigate to Form  
    switch to Reinsurance Form
    Verify Reinsurance Form    ${TC_Forms_006}
    Select Check Box Reinsurance Form    ${TC_Forms_006}
    Save Changes in Form    ${TC_Forms_006}
 
TC_Forms_007
    [Documentation]    End to End Testing for Manuscript Tab"
    # ${submission_id}    Run Pre-requiste for Step 1 2 & 3
    # Launch URL and Login in to the application 
    # Create User If the User is not present    ${NewUser}
    # Select Impersonate option from the actions    ${NewUser['email']}    ${NewUser['search_user']}
    # Verify My Assignments Tab is displayed as a default tab
    # Select Submission using submission id    ${submission_id}    @{TC_E2E_002['SubmissionColumnNames']}
    # Verify Submission page is displayed
    Navigate to Form  
    switch to NY Underwriting Eligibility Guidelines Form
    Verify Form Company Underwriting Eligibility General    ${TC_Forms_007['GeneralData']}
    Verify Form NY Underwriting Eligibility Guidelines Total Points Range    ${TC_Forms_007['TotalPoints']}
    Verify Form Company Underwriting Eligibility Management Attitude    ${TC_Forms_007['ManagementAttitudevalues']}
    Verify Form NY Underwriting Eligibility Guidelines Company Inspection Details    ${TC_Forms_007['CompanyInspectionValues']}
    Save Changes in Form    ${TC_Forms_007}
 


TC_Forms_01
    [Documentation]    End to End Testing for Policy Information Form Tab"
    # Run Pre-requiste for Step 1 2 & 3
    # Launch URL and Login in to the application
    # Create User If the User is not present    ${NewUser}
    # Select Impersonate option from the actions    ${NewUser['email']}    ${NewUser['search_user']}
    # Verify My Assignments Tab is displayed as a default tab
    # ${submission_id}    Create New Submission    ${TC_E2E_001['FileName']}    @{TC_E2E_001['SubmissionColumnNames']}
    # Select Submission using submission id    ${submission_id}    @{TC_E2E_001['SubmissionColumnNames']}
    # Verify Submission page is displayed
    
    # Click Edit Submission
    Complete Forms Tab Details Filling    ${TC_Forms_01}
    
    Complete Forms Tab Details Verification    ${TC_Forms_01}
    
    
    # # #Stage---4
    Click Edit Submission
    Save Submission And verify popup
    Verify Submission updated in the Current Stage    ${TC_E2E_017['stageNo']}
    Complete Forms Tab Details Filling    ${TC_Forms_02}
    Complete Forms Tab Details Verification    ${TC_Forms_02}
    # #STAGE----05[BIND]
    # Advance Stage    ${TC_E2E_026['stageNo1']}
    # Verify Stage is updated in the submission    ${TC_E2E_026['stage1']}




    # Click Edit Submission
    # Verify Policy PDF is Generated and Available in Documents Tab    ${TC_E2E_017['PolicyInfo']}
    # click Summary Tab
    #  verify Header Displayed    ${TC_E2E_023['Stage_Type']}    ${TC_E2E_023['Tab_Name']}
    # Verify Summary Table Data    ${TC_E2E_011['SummaryTableHeader']}    ${TC_E2E_023['SummaryTableData']}
    # Verify Policy Information Details from Summary Tab    ${TC_E2E_017['PolicyInfo']} 
    # Enter the Policy Information    ${TC_E2E_023['PolicyInfo']}

    # # # # Verify Child Submission Should be Displayed in Summary Tab    ${TC_E2E_011['productName']}
    # # # verify Account History are editable    ec34fb0b-7e95-4f8f-8e9a-e91576851c8b    Booked

    # Complete Forms Tab Details Filling    ${TC_Forms_01}
    
    #  Save Submission And verify popup_Bound
    #  Verify Submission updated in the Current Stage    ${TC_E2E_017['stageNo']}

    # #STAGE----06[BOUND]
    # Advance Stage    ${TC_E2E_026['stageNo2']}
    # Verify Stage is updated in the submission    ${TC_E2E_026['stage2']}

    # Click Edit Submission
    
    # click Summary Tab
    # verify Header Displayed    ${TC_E2E_026['stage2']}    ${TC_E2E_023['Tab_Name']}
    # Verify Summary Table Data    ${TC_E2E_011['SummaryTableHeader']}    ${TC_E2E_026['SummaryTableData']}
    # Verify Policy Information Details from Summary Tab    ${TC_E2E_023['PolicyInfo']}
    # Enter the Policy Information    ${TC_E2E_023['PolicyInfo1']}

    # Complete Forms Tab Details Verification    ${TC_Forms_01}
    # Complete Forms Tab Details Filling    ${TC_Forms_02}
    # Complete Forms Tab Details Verification    ${TC_Forms_02}
    
    # Verify WorkFlow History    ${TC_E2E_019['expectedWorkFlowHistory']}
    # Save Submission And verify popup
    # Verify Submission updated in the Current Stage    ${TC_E2E_019['stageNo']}
    

    #Clearance Tab--Verification
    # verify Clearance Tab    ${TC_E2E_023['ProductName']}


*** Keywords ***
 
Run Pre-requiste Steps for Stage 1
    Launch URL and Login in to the application
    Create User If the User is not present    ${NewUser}
    Select Impersonate option from the actions    ${NewUser['email']}    ${NewUser['search_user']}
    Verify My Assignments Tab is displayed as a default tab
    ${submission_id}    Create New Submission    ${TC_E2E_001['FileName']}    @{TC_E2E_001['SubmissionColumnNames']}
    Select Submission using submission id    ${submission_id}    @{TC_E2E_001['SubmissionColumnNames']}
    Verify Submission page is displayed
    Click Edit Submission
    Click and verify Clearance tab
    Click Insured Tab
    Fill the data for issue fields    ${TC_E2E_001['SicCode']}    ${TC_E2E_001['SicDescription']}    ${TC_E2E_001['NAICSCode']}
    Click Processing Tab
    Fill the data for issue fields in processing    ${TC_E2E_001['UnderwriterName']}    ${TC_E2E_001['UnderwriterEmail']}    ${TC_E2E_001['OperationsName']}        ${TC_E2E_001['OperationsEmail']}    ${TC_E2E_001['UnderwrittingOffice']}    ${TC_E2E_001['Channel']}
    Click Producer Tab
    Fill the data for issues field in Producer    ${TC_E2E_001['ProducerName']}      ${TC_E2E_001['ProducerEmail']}    ${TC_E2E_001['ProducerEmail']}  
    Click Coverage Tab
    Fill the data for issues field in Coverage    ${TC_E2E_001['Covered']}
    Click Finish Tab
    Verify and click the save and close button
    Set Suite Variable    ${ActualSubmissioID}    ${submission_id}
 
Run Pre-requiste Steps for Stage 1 & 2
    Launch URL and Login in to the application
    Create User If the User is not present    ${ReferralUser}
    Create User If the User is not present    ${NewUser}
    Select Impersonate option from the actions    ${NewUser['email']}    ${NewUser['search_user']}
    Verify My Assignments Tab is displayed as a default tab
    # ${submission_id}    Create New Submission    ${TC_E2E_001['FileName']}    @{TC_E2E_001['SubmissionColumnNames']}
    Select Submission using submission id    ddb9001d-17da-4a9f-88b7-0cf64046ecd6    @{TC_E2E_001['SubmissionColumnNames']}
    # Verify Submission page is displayed
    # Click Edit Submission
    # Click and verify Clearance tab
    # Click Insured Tab
    # Fill the data for issue fields    ${TC_E2E_001['SicCode']}    ${TC_E2E_001['SicDescription']}    ${TC_E2E_001['NAICSCode']}
    # Click Processing Tab
    # Fill the data for issue fields in processing    ${TC_E2E_001['UnderwriterName']}    ${TC_E2E_001['UnderwriterEmail']}    ${TC_E2E_001['OperationsName']}        ${TC_E2E_001['OperationsEmail']}    ${TC_E2E_001['UnderwrittingOffice']}    ${TC_E2E_001['Channel']}
    # Click Producer Tab
    # Fill the data for issues field in Producer    ${TC_E2E_001['ProducerName']}      ${TC_E2E_001['ProducerEmail']}  
    # Click Coverage Tab
    # Fill the data for issues field in Coverage    ${TC_E2E_001['Covered']}
    # Click Finish Tab
    # Verify and click the save and close button
    # Save Submission And verify popup
    # Verify Submission updated
    # Advance Stage 2
    # Verify Stage is updated in the submission    ${TC_E2E_007['stage']}
    # Click Edit Submission
    # Save Submission And verify popup
    # Verify Submission updated in Stage 2
    # RETURN    ${submission_id}
    RETURN    ddb9001d-17da-4a9f-88b7-0cf64046ecd6
Run Pre-requiste for Step 1 2 & 3
    ${submission_id}    Run Pre-requiste Steps for Stage 1 & 2
    # Advance Stage    ${TC_E2E_011['stageNo']}    
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
    Verify Submission updated in the Current Stage    ${TC_E2E_011['stageNo']}
    Set Suite Variable    ${submission_id}
    RETURN    ${submission_id}