*** Settings ***
Resource   ../../utils/common_keywords.robot
Variables  ../locators/submissions.py
Variables  ../locators/all_submissions.py
Variables    ../locators/summary_locators.py
Library    ../../libraries/ScreenshotListener.py

*** Keywords ***
Verify All Side menu options are Displayed 
   [Documentation]    verify that All tabs Are Displayed 
   [Arguments]    ${expected_Value}
   ${Allfields}    Get Elements    ${Loc_AllField}
   ${lenth}    Get Length   ${Allfields}
   Log To Console    the lenth is : ${lenth}
   ${summary_list}    Create List  
   FOR    ${counter}    IN    @{Allfields} 
       ${fieldname}=    Get Text    ${counter}
       Append To List    ${summary_list}     ${fieldname}
       Log To Console    The Field is : ${summary_list} 
   END
   Run Keyword And Continue On Failure    Lists Should Be Equal    ${summary_list}    ${expected_Value}
verify Header Displayed
     [Documentation]    verify that All Header Are Displayed
    ...
    ...    *Arguments:*
    ...       The Excepted page ${expected_Home}
    ...       The Expected companyname    ${Expected_Company_name}
    ...       The Expected Stage ${expected_Stage}
    ...       The Expected Tab  ${Expected_Tab}
    [Arguments]   ${expected_Home}    ${Expected_Company_name}    ${expected_Stage}    ${Expected_Tab}
    ${acutual_Header_List}    Create List
    ${expected_Header_List}    Create List
   ${headers}    Get Elements    ${Headers_Loc}
   ${lenth}    Get Length   ${Headers_Loc}
   Log To Console    the lenth is : ${lenth}
   FOR    ${counter}    IN    @{headers}
       ${headerName}=    Get Text    ${counter}
       Append To List    ${acutual_Header_List}     ${headerName}
       Log    The field is : ${acutual_Header_List}
       Log To Console    The Field is : ${acutual_Header_List}
       
   END
       ${Header_Text}    Get Text    ${Loc_Header_Status}
        ${Header_Text1}    Get Text    ${page_header_Loc}
    Append To List    ${acutual_Header_List}    ${Header_Text}  
    Append To List    ${acutual_Header_List}    ${Header_Text1}    
    Append To List    ${expected_Header_List}   ${expected_Home}
    Append To List    ${expected_Header_List}   ${Expected_Company_name}  
    Append To List    ${expected_Header_List}   ${expected_Stage}  
    Append To List    ${expected_Header_List}    ${Expected_Tab}    
    Lists Should Be Equal    ${expected_Header_List}    ${acutual_Header_List}         

Switch to Summary
    [Documentation]  Switch to Summary        
    Wait For Elements State    ${SummaryTab_loc}    visible    5s
    Click    ${SummaryTab_loc}

verify Summary Sub Header Displayed
     [Documentation]  check the Sub Header Displayed
     ...    *argument*
     ...    ${Expected_Header}  the Expected Sub Header "WIN-CON ENTERPRISES, INC"
     [Arguments]     ${Expected_Header}   
     ${Actual_Sum_Header}    Get Text    ${Sum_Header_loc}
    Should Be Equal    ${TC_Summary_001['expected_Sum_Header']}    ${Actual_Sum_Header}   

verify Address is Displayed 
    [Documentation]    verify the Address is Displayed 
    ...    *Argument*
    ...    ${expected_Header}    give the Expected Address
    [Arguments]    ${expected_Header}
     ${sum_Adress_element}    Get Elements    ${Sum_Address_loc}
    FOR    ${element}    IN    @{sum_Adress_element}
        ${lines}    Get Text    ${element}
        Append To List    ${TC_Summary_001['Actual_Adress']}    ${lines}
    END
    ${final_Adress}    Catenate    SEPARATOR=,    @{TC_Summary_001['Actual_Adress']}
    Log    ${final_Adress}
    Should Be Equal    ${final_Adress}     ${expected_Header}

Enter the Policy Information
    [Documentation]    This is used to enter the Policy Information 
    ...    ${policy_Info}     here We need to pass the policy Information which we need to Enter
    [Arguments]    ${policy_Info}  
 
    Click    ${permium_Btn_Loc}
    Wait For Elements State    ${premium_field_loc}    visible    5s
    Fill Text    ${premium_field_loc}    ${policy_Info['premium']}
    Wait For Elements State    ${premium_field_loc}    visible    5s
    Click    ${Attachement_point_btn_loc}
    Wait For Elements State    ${Attachement_point_field_loc}    visible    5s
    Fill Text    ${Attachement_point_field_loc}    ${policy_Info['AttachmentPoint']}
    Click    ${policy_Btn_Loc}
    Wait For Elements State    ${policy_field_Loc}    visible    5s
    Fill Text    ${policy_field_Loc}    ${policy_Info['PolicyNumber']}
    click    ${loc_ClassOf_Business}
    ${element}    Catenate    SEPARATOR=    ${loc1_Select_Type}    ${policy_Info['ClassOfBusiness']}    ']    
    click    ${element} 
    click    ${Loc_Placement_Button}
    ${place_element}    Catenate    SEPARATOR=    ${loc1_Select_Type}    ${policy_Info['PlacementType']}    ']    
    click    ${place_element}

# Verify Policy Information Details from Summary Tab
#     [Documentation]    the Given Policy Informaton Should be listed
#     ...    ${expected_Policy_Field}    here We need to Pass the Expected policy Information Along with We need to pass the Key field in Summary tab     

#     [Arguments]    ${expected_Policy_Field}    ${Expected_Forms_PolicyInormation}        
 
#     ${Actual_Policy_Text}    Get Text    ${policy_btn_Loc}
#     Should Be Equal    ${Actual_Policy_Text}    ${Expected_Forms_PolicyInormation['TC_Forms_002']['DocumentationData']['PolicyNumber']}
#    ${Actual_Premium_Text}    Get Text    ${permium_Btn_Loc}
#      Should Be Equal    ${Actual_Premium_Text}    ${Expected_Forms_PolicyInormation['TC_Forms_002']['DocumentationData']['PolicyPremium']}
#    ${Actual_Attachment_Text}    Get Text    ${Attachement_point_btn_loc}
#     Should Be Equal    ${Actual_Attachment_Text}    ${expected_Policy_Field['AttachmentPoint']}
#     ${Actual_ClassOf_Business}    Get Text    ${loc_ClassOf_Business}
#       Should Be Equal    ${Actual_ClassOf_Business}    ${expected_Policy_Field['ClassOfBusiness']}
#    ${Actual_Placement_Text}    Get Text    ${Loc_Placement_Button}
#     Should Be Equal    ${Actual_Placement_Text}    ${expected_Policy_Field['PlacementType']}
#      ${Actual_Policy_Field}    Create List
#     ${Actual_Policy_Field_Text}    Get Text    ${policy_Field}
#    ${Actual_Premium_Field}    Get Text    ${permium_Field}
#    ${Actual_Business_Field}    Get Text    ${loc_ClassOf_Business_Field}
#   ${Actual_Attachement_Field}    Get Text    ${Attachement_point_Field}
#     ${Actual_Mailed_Field}    Get Text    ${loc_Mailed_Date_Field}
#    ${Actual_Placement_Field}    Get Text    ${Loc_Placement_Field}
#   Append To List    ${Actual_Policy_Field}    ${Actual_Premium_Field}
#   Append To List    ${Actual_Policy_Field}    ${Actual_Attachement_Field}
#   Append To List    ${Actual_Policy_Field}    ${Actual_Policy_Field_Text}
#   Append To List    ${Actual_Policy_Field}    ${Actual_Business_Field}
#   Append To List    ${Actual_Policy_Field}    ${Actual_Placement_Field}
#   Append To List    ${Actual_Policy_Field}    ${Actual_Mailed_Field}

#   Lists Should Be Equal    ${Actual_Policy_Field}    ${expected_Policy_Field['PolicyFields']}


Verify Policy Information Details from Summary Tab
    [Documentation]    The Given Policy Information Should be listed
    ...    ${expected_Policy_Field}    here We need to Pass the Expected policy Information Along with We need to pass the Key field in Summary tab     

    [Arguments]    ${expected_Policy_Field}    ${Expected_Forms_PolicyInormation}        

    ${Actual_Policy_Text}    Get Text    ${policy_btn_Loc}
    Run Keyword And Continue On Failure    Should Be Equal    ${Actual_Policy_Text}    ${Expected_Forms_PolicyInormation['TC_Forms_002']['DocumentationData']['PolicyNumber']}

    ${Actual_Premium_Text}    Get Text    ${permium_Btn_Loc}
    ${Actual_Premium_Text}    Replace String    ${Actual_Premium_Text}    $    ${EMPTY}     
    ${Actual_Premium_Text}    Replace String    ${Actual_Premium_Text}    ,    ${EMPTY} 
    ${Actualval}    Strip String    ${Actual_Premium_Text}    
    ${Expected_Premium_Text}    Set Variable    ${Expected_Forms_PolicyInormation['TC_Forms_002']['DocumentationData']['PolicyPremium']}  
    Run Keyword And Continue On Failure    Should Be Equal    ${Actualval}    ${Expected_Premium_Text}

    ${Actual_Attachment_Text}    Get Text    ${Attachement_point_btn_loc}
    ${Actual_Attachment_Text}    Replace String    ${Actual_Attachment_Text}    $    ${EMPTY}
    ${Actual_Attachment_Text}    Replace String    ${Actual_Attachment_Text}    ,    ${EMPTY}
    ${ActualAttachmentval}    Strip String    ${Actual_Attachment_Text}
    ${Expected_Attachment_Text}    Set Variable    ${expected_Policy_Field['AttachmentPoint']}
    Run Keyword And Continue On Failure    Should Be Equal    ${ActualAttachmentval}    ${Expected_Attachment_Text}

    ${Actual_ClassOf_Business}    Get Text    ${loc_ClassOf_Business}
    Run Keyword And Continue On Failure    Should Be Equal    ${Actual_ClassOf_Business}    ${expected_Policy_Field['ClassOfBusiness']}

    ${Actual_Placement_Text}    Get Text    ${Loc_Placement_Button}
    Run Keyword And Continue On Failure    Should Be Equal    ${Actual_Placement_Text}    ${expected_Policy_Field['PlacementType']}

    ${Actual_Policy_Field}    Create List
    ${Actual_Policy_Field_Text}    Get Text    ${policy_Field}
    ${Actual_Premium_Field}    Get Text    ${permium_Field}
    ${Actual_Premium_Field}    Replace String    ${Actual_Premium_Field}    $    ${EMPTY}
    ${Actual_Premium_Field}    Replace String    ${Actual_Premium_Field}    ,    ${EMPTY}
    ${Actualvalue}    Strip String    ${Actual_Premium_Field}
    ${Actual_Business_Field}    Get Text    ${loc_ClassOf_Business_Field}
    ${Actual_Attachement_Field}    Get Text    ${Attachement_point_Field}
    ${Actual_Attachement_Field}    Replace String    ${Actual_Attachement_Field}    $    ${EMPTY}
    ${Actual_Attachement_Field}    Replace String    ${Actual_Attachement_Field}    ,    ${EMPTY}
    ${ActualPointValue}    Strip String    ${Actual_Attachement_Field}
    ${Actual_Mailed_Field}    Get Text    ${loc_Mailed_Date_Field}
    ${Actual_Placement_Field}    Get Text    ${Loc_Placement_Field}

    Append To List    ${Actual_Policy_Field}    ${Actualvalue}
    Append To List    ${Actual_Policy_Field}    ${ActualPointValue}
    Append To List    ${Actual_Policy_Field}    ${Actual_Policy_Field_Text}
    Append To List    ${Actual_Policy_Field}    ${Actual_Business_Field}
    Append To List    ${Actual_Policy_Field}    ${Actual_Placement_Field}
    Append To List    ${Actual_Policy_Field}    ${Actual_Mailed_Field}

    Run Keyword And Continue On Failure    Lists Should Be Equal    ${Actual_Policy_Field}    ${expected_Policy_Field['PolicyFields']}




Verify Policy PDF is Generated and Available in Documents Tab
    [Documentation]    Verifies that the Policy PDF is generated and listed in the Documents tab.
    ...    ${expectedText1}     we need to pass the policy Information use in Summary Tab in Previous Stage  
    [Arguments]     ${expectedText1}
    ${Expected_Policy_text}    Create List
    Append To List    ${Expected_Policy_text}    ${expectedText1['premiumAmount']}
    Append To List    ${Expected_Policy_text}    ${expectedText1['AttachmentPoint']}  
    Append To List    ${Expected_Policy_text}    ${expectedText1['PolicyNumber']}  
    Append To List    ${Expected_Policy_text}    ${expectedText1['ClassOfBusiness']}  
    Append To List    ${Expected_Policy_text}    ${expectedText1['PlacementType']}  
    @{actual_Policy_text}    Create List
    Switch To Documents
    ${elements}=    Get Elements    ${PolicyDataModification}
    ${last_Element}=    Set Variable    ${elements}[-1]
    Scroll To Element    ${last_Element}
    Wait For Elements State    ${last_Element}    visible    timeout=30s
    Click    ${last_Element}
    # ${Length}    Get Length    ${TC_Summary_001['Doc_Loc']}
    FOR    ${element}    IN    @{TC_Summary_001['Doc_Loc']}
     ${ele_Loc}    Catenate    SEPARATOR=    ${policy_locators_doc1}    ${element}    ${policy_locators_doc2}
     Sleep    1s
     Click     ${poloicy_Data_modification_page}
    Press Keys    xpath=//*[@class='ace_content']        Control+f
    Type Text    ${Search_Bar_CtrlF}    ${element}
        ${result}    Get Text    ${ele_Loc}
         IF    '"' in '''${result}'''  
         ${cleaned}=    Evaluate    ${result}.replace('"', '')    modules=builtins
            Append To List    ${actual_Policy_text}    ${cleaned}
        ELSE
             Append To List    ${actual_Policy_text}    ${result}
        END    
    END
    Log    ${actual_Policy_text}
    Lists Should Be Equal    ${actual_Policy_text}    ${Expected_Policy_text}


Verify Child Submission Should be Displayed in Summary Tab
    [Documentation]    this method is used to verify the Child Submission detials in Summary tab
    ...    ${Expected_Product_type}     This We need to Pass the Child Submission Product Type 
    [Arguments]    ${Expected_Product_type}    
   ${Product_type}    Get Text    ${Expected_Product_Type_Loc}
    Should Be Equal    ${Product_type}    ${Expected_Product_type}
   ${Status_type}    Get Text    ${Expected_Status_Type_Loc}
    Should Be Equal    ${Status_type}   ${TC_Summary_001['Child_Sub_Stage']}
   ${EffectiveDate_type}    Get Text    ${Expected_Eff_date_loc}
    Should Be Equal    ${EffectiveDate_type}    ${TC_E2E_001['EffectiveDate']}
   ${exp_type}    Get Text    ${Expected_Exp_date_loc}  
   Should Be Equal    ${exp_type}    ${TC_E2E_001['ExpirationDate']}
 
verify Account History are editable
    [Documentation]    this Method is used to The Account History  Editable or not
    ...  ${Submission_Id}     We need to pass the Parent Submission Id 
    ...  ${Stage_Type}     we need to pass the Which Stage we Are Currently
    ...   ${policy_Detials}     we need to pass the Policy data       
    [Arguments]    ${policy_Detials}
   
    Switch To Email Tab
   ${elements}    Get Elements    //aside//a
   ${parent_length}    Get Length    ${elements}
   Click Answers Tab
   Switch to Summary
    Click    ${Expected_Product_Type_Loc}
    
    ${element}    Catenate    SEPARATOR=    ${Expected_Product_Type_Loc}    //span    
    ${Product_type1}    Get Text    ${element}
    Run Keyword And Continue On Failure    Should Contain    ${Product_type1}    Current
#    Run Keyword And Continue On Failure    verify the entered Policy Information    ${policy_Detials}
   Switch To Email Tab
   ${elements}    Get Elements    //aside//a
   ${child_length}    Get Length    ${elements}
   Run Keyword And Continue On Failure    Should Be Equal    ${parent_length}    ${child_length}
   Click Answers Tab
    Switch to Summary
    click    ${Excepted_parent_product_type}
    ${element}    Catenate    SEPARATOR=    ${Excepted_parent_product_type}    //span    
    ${Product_type1}    Get Text    ${element}
    Run Keyword And Continue On Failure    Should Contain    ${Product_type1}    Current
    # Select Submission using submission id    ${Submission_Id}    @{TC_E2E_001['SubmissionColumnNames']}
 

Verify the workflow panel
    [Documentation]    This method is used verify the Workflow_Lists
    [Arguments]     ${Expected_Workflow_Lists} 
    ${Actual_Workflow_Lists}    Create List   
    Click Answers Tab
    ${WorkFlow_Side_Panel}    Get Elements     ${Workflow_Lists}
    FOR    ${element}    IN    @{WorkFlow_Side_Panel}
    ${WorkFlow_text}    Get Text    ${element}
    Append To List    ${Actual_Workflow_Lists}    ${WorkFlow_text}    
    END  
    Lists Should Be Equal    ${Actual_Workflow_Lists}    ${Expected_Workflow_Lists}

verify the WorkFlow in Summary Tab 
    [Documentation]    This method is used verify the Workflow_Lists is present in Summary Tab
    [Arguments]    ${Expected_Workflow_Lists}
    ${Actual_Workflow_Lists}    Create List
    Switch to Summary
    Click    ${Loc_Header_Status}
    ${WorkFlow_SummaryTab}    Get Elements     ${Summary_Workflow_Lists}
    FOR    ${element1}    IN    @{WorkFlow_SummaryTab}
        ${WorkFlow_text1}    Get Text    ${element1}
        Append To List    ${Actual_Workflow_Lists}    ${WorkFlow_text1}
    END
    Lists Should Be Equal    ${Actual_Workflow_Lists}    ${Expected_Workflow_Lists}

Verify the Workflow Reflected in Summary tab
    [Documentation]    This method is used verify the Workflow_Lists
    ...    ${Stage_Type} Here we need to Pass the Advance Stage (eg:if Draft Stage means we need to pass cleared Stage )   

    [Arguments]    ${Stage_Type} 
     ${Actual_Workflow_Lists}    Create List   
    ${Expected_Workflow_Lists}    Create List
    ${text}    Catenate    Advance to    ${Stage_Type}    
     Append To List    ${Actual_Workflow_Lists}    ${text}    
    Click Answers Tab
    ${WorkFlow_Side_Panel}    Get Elements     ${Workflow_Lists}
    FOR    ${element}    IN    @{WorkFlow_Side_Panel}
    ${WorkFlow_text_Panel}    Get Text    ${element}
    ${WorkFlow_text_Panel1}    Strip String    ${WorkFlow_text_Panel}
    Append To List    ${Actual_Workflow_Lists}    ${WorkFlow_text_Panel1}           
    END  
    Switch to Summary
    Click    ${Loc_Header_Status}
    ${WorkFlow_SummaryTab}    Get Elements     ${Summary_Workflow_Lists}
    FOR    ${element1}    IN    @{WorkFlow_SummaryTab}
        ${WorkFlow_text2}    Get Text    ${element1}
        ${WorkFlow_text1}    Strip String    ${WorkFlow_text2}
        Append To List    ${Expected_Workflow_Lists}    ${WorkFlow_text1}
        
    END
    FOR    ${value}    IN    @{Expected_Workflow_Lists}
        Run Keyword And Continue On Failure     Should Contain    ${Actual_Workflow_Lists}    ${value}
    END
    Press Keys    ${Loc_Header_Status}    Escape

verify the entered Policy Information
    [Documentation]    verify that given Text Are enter Correctly on premium And Attachment point And policy  field
    ...    *argument*
    ...    ${expected_Policy_Field}
    [Arguments]    ${expected_Policy_Field}      
     ${Actual_Policy_Text}    Get Text    ${policy_btn_Loc}
    Should Be Equal    ${Actual_Policy_Text}    ${expected_Policy_Field['PolicyNumber']}
   ${Actual_Premium_Text}    Get Text    ${permium_Btn_Loc}
     Should Be Equal    ${Actual_Premium_Text}    ${expected_Policy_Field['premium']}
   ${Actual_Attachment_Text}    Get Text    ${Attachement_point_btn_loc}
    Should Be Equal    ${Actual_Attachment_Text}    ${expected_Policy_Field['AttachmentPoint']}
    ${Actual_ClassOf_Business}    Get Text    ${loc_ClassOf_Business}
      Should Be Equal    ${Actual_ClassOf_Business}    ${expected_Policy_Field['ClassOfBusiness']}
   ${Actual_Placement_Text}    Get Text    ${Loc_Placement_Button}
    Should Be Equal    ${Actual_Placement_Text}    ${expected_Policy_Field['PlacementType']}


Verify AttachmentPoint Must Accept Numeric Values
    [Documentation]    This test verifies that the Attachment Point field accepts only numeric values
    Switch to Summary
    Click    ${Attachement_point_btn_loc}
    Wait For Elements State    ${Attachement_point_field_loc}    visible    5s

    # Attempt to input non-numeric value
    Fill Text    ${Attachement_point_field_loc}    Test
    Wait For Elements State    ${permium_Btn_Loc}
    ${ActualValue}    Get Text    ${Attachement_point_btn_loc}
    Should Be Empty    ${ActualValue}

    # Optionally: Try a numeric input to confirm it works
    Clear Text    ${Attachement_point_field_loc}
    Fill Text    ${Attachement_point_field_loc}    12345
    ${NumericValue}    Get Text    ${Attachement_point_field_loc}
    Should Be Equal    ${NumericValue}    12345

Verify Schema for policy information and Available in Documents Tab
    [Documentation]    Verifies that the Policy PDF is generated and listed in the Documents tab.
    ...    ${expectedText1}     we need to pass the policy Information use in Summary Tab in Previous Stage  
    [Arguments]     ${expected_headers}    ${expectedText1}
    ${Expected_Policy_text}    Create List
    Append To List    ${Expected_Policy_text}    ${expectedText1['premium']}
    Append To List    ${Expected_Policy_text}    ${expectedText1['AttachmentPoint']}  
    Append To List    ${Expected_Policy_text}    ${expectedText1['PolicyNumber']}  
    Append To List    ${Expected_Policy_text}    ${expectedText1['ClassOfBusiness']}  
    Append To List    ${Expected_Policy_text}    ${expectedText1['PlacementType']}  
    @{actual_Policy_text}    Create List
    Switch To Documents
    Click    ${SchemaSection}
    FOR    ${element}    IN    @{expected_headers}
     ${ele_Loc}    Catenate    SEPARATOR=    ${policy_locators1}    ${element}    ${policy_locators2}
     ${ele_Loc}    Catenate    SEPARATOR=    ${ele_Loc}    ${policy_locators3}
     ${ele_Loc}    Catenate    SEPARATOR=    ${ele_Loc}    ${element}    ${policy_locators4}
     Sleep    1s
     Click     ${poloicy_Data_modification_page}
    Press Keys    xpath=//*[@class='ace_content']        Control+f
    Type Text    ${Search_Bar_CtrlF}    ${element}
        ${result}    Get Text    ${ele_Loc}
         IF    '"' in '''${result}'''  
         ${cleaned}=    Evaluate    ${result}.replace('"', '')    modules=builtins
            Append To List    ${actual_Policy_text}    ${cleaned}
        ELSE
             Append To List    ${actual_Policy_text}    ${result}
        END    
    END
    Log    ${actual_Policy_text}
    Lists Should Be Equal    ${actual_Policy_text}    ${Expected_Policy_text}    

Reject Submission via summary tab 
    [Documentation]    Rejects a submission,via inside the summary tab  option.
    ...
    ...    *Arguments:*
    ...    - `${FailureReasons}`: A list of reasons for the rejection.
    ...    - `${data_details}`: A text description of the rejection details.
    ...    - `${action}`: Either 'Cancel' to cancel the rejection or any other value to proceed.
    [Arguments]    ${FailureReasons}    ${data_details}    ${action}
    Switch to Summary
    Click    ${Loc_Header_Status}
    Click    ${Summary_Reject_option}
    FOR     ${failureReason}    IN    @{FailureReasons}
    ${reason}    Catenate    SEPARATOR=    ${Summary_ReasonForReject1}    ${failureReason}    ']
    Check Checkbox    ${reason}
    END
    ${other_option}=    Run Keyword And Return Status    List Should Contain Value    ${FailureReasons}    Other
    IF    '${other_option}' == 'True'
        ${state}=    Get Element States    ${Summary_Sumbit}
        Run Keyword And Continue On Failure    Should Contain    ${state}    disabled
        Type Text    ${Summary_detials}    ${data_details}

     END     
    IF    '${action}' == 'Cancel'
        Get Element States    ${SelectReason}    validate    value & enabled    'SelectReason should be enabled.'
        Click    ${CancelButtonInReject}
        Verify WorkFlow Options Advance Stage and Reject
        Get Element States    ${InDraftTag}    validate    value & visible    'InDraftTag should be visible.'
    ELSE     
         Get Element States    ${Summary_Sumbit}    validate    value & enabled    'AcceptButton should be enabled.'
         Click    ${Summary_Sumbit}
         Sleep    2s    
         ${text}    Get Text    ${Loc_Header_Status}
         Run Keyword And Continue On Failure    Should Be Equal    ${text}    Rejected
    END        

Reactive the Submission via summary tab 
    [Documentation]    Reactive the submission,via inside the summary tab  option.
    ...
    ...    *Arguments:*
    ...    - `${data_details}`: A text description of the rejection details.
    ...    - `${action}`: Either 'Cancel' to cancel the rejection or any other value to proceed.
    [Arguments]    ${data_details}    ${action}
    # Switch to Summary
    Click    ${Loc_Header_Status}
    Click    ${Summary_reactive}
    IF    '${action}' == 'Cancel'
        Get Element States    ${summary_cancel}    validate    value & enabled    'SelectReason should be enabled.'
        Click    ${summary_cancel}
     ELSE
        Get Element States    ${Summary_accept}    validate    value & enabled    'AcceptButton should be enabled.'
        Click    ${Summary_accept}
        Get Element States    ${Summary_reactive_error_msg}    validate    value & visible    'Summary_reactive_error_msg should be enabled.'
        Click    ${summary_cancel}
        Click Answers Tab
        # Type Text    ${Summary_detials}    ${data_details}
        # Get Element States    ${Summary_accept}    validate    value & enabled    'AcceptButton should be enabled.'
        # Click    ${Summary_accept}
        # Sleep    2s
        # ${text}    Get Text    ${Loc_Header_Status}
        # Run Keyword And Continue On Failure     Should Be Equal    ${text}    In Draft 
     END    


Verify Element State
    [Arguments]    ${locator}    ${expected_state}
    ${state}=    Get Element States    ${locator}
    Run Keyword If    '${expected_state}' == 'enabled'    Should Contain    ${state}    enabled
    ...    ELSE IF    '${expected_state}' == 'disabled'    Should Contain    ${state}    disabled
    ...    ELSE    Fail    Invalid expected_state value: ${expected_state}     
     
        