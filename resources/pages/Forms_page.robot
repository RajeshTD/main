*** Settings ***
Resource     ../../utils/common_keywords.robot
Variables     ../locators/Forms_locator.py
Library    DateTime
 
*** Variables ***
${AttachmentPath}             ${CURDIR}/../../uploads/
 
*** Keywords ***
Navigate to Form
    ${Status}    Run Keyword And Return Status    Get Element States    ${FormsPage}    Validate    value & visible
    IF    ${Status}
        Log    Forms page already opened
    ELSE
        Wait For Elements State    ${FormsMenu}    visible
        Click    ${FormsMenu}
    END
    ${Status}    Run Keyword And Return Status    Get Element States    ${RegenerateButton}    Validate    value & visible
    Run Keyword And Continue On Failure    Should Be Equal    '${Status}'    'False'
    IF    ${Status}==True
        Click    ${RegenerateButton}
    END


Verify Form Summary Headers
    [Arguments]    ${expectedFormHeader}
    ${formHeaderValues}    Get Text    ${FormSummaryHeader}
    ${Text}    Strip String    ${formHeaderValues}
    FOR    ${FormHeader}    IN    @{expectedFormHeader['expectedFormHeaderValues']}
        Should Contain    ${Text}    ${FormHeader}
    END
   
Verify Form Summary Details
    [Arguments]    ${expectedFormDetails}
    ${elements}=    Get Elements    ${FormSummaryDetails}
    ${ActualList}    Create List
    FOR    ${elements}    IN    @{elements}
    ${elementText}    Get Text    ${elements}
    ${actualelementText}    Strip String    ${elementText}
    Append To List    ${ActualList}        ${actualelementText}
    END
    Lists Should Be Equal    ${expectedFormDetails['expectedFormDetailsValues']}   ${ActualList}
Switch to Policy Instruction Form
    Wait For Elements State    ${FormsPIFOption}    visible
    Click    ${FormsPIFOption}
    
Verify Form Policy Instruction Form General Details
    [Arguments]    ${expectedPIFGeneralDetails}
    # Wait For Elements State    ${FormsPIFOption}    visible
    # Click    ${FormsPIFOption}
     ${elements}=    Get Elements    ${PIFGeneralData}
    ${ActualList}    Create List
    FOR    ${elements}    IN    @{elements}
    ${elementText}    Get Text    ${elements}
    ${actualelementText}    Strip String    ${elementText}
    Append To List    ${ActualList}        ${actualelementText}
    END
    Run Keyword And Continue On Failure     Lists Should Be Equal    ${expectedPIFGeneralDetails['expectedPIFGeneralDetailsValues']}    ${ActualList}
    Fill Text    ${PIFPolicyInputField}    ${expectedPIFGeneralDetails['PIFPolicyInput']}
    Wait For Elements State    ${PIFNeededByDateField}    visible
    Click    ${PIFNeededByDateField}
    ${day}    Get Current Day Number
    ${actualCurrentDate}    Convert To Integer    ${day}
    ${CurrentDateInput}    Convert To Integer    ${expectedPIFGeneralDetails['PIFPolicyDateNumberInput']}
    ${sum}=    Evaluate    ${actualCurrentDate} + ${CurrentDateInput}
    ${currentdate}=    Catenate    SEPARATOR=    ${PIFGeneralDateSelect}    ${sum}    ']
    Wait For Elements State    ${currentdate}    visible
    Click    ${currentdate}
    Wait For Elements State    ${PIFNeededByDateField}    visible
    Click    ${PIFNeededByDateField}
 
 
Verify Form Policy Instruction Form Indured Tab Details
    [Arguments]    ${expectedPIFInsuredDetails}
    ${YearValues}    Get Attribute    ${PIFInsuredYearEstablished}    value
    Run Keyword And Continue On Failure    Should Be Equal    ${expectedPIFInsuredDetails['PIFInsuredYearEstablishedValue']}    ${YearValues}
    ${RevenueValue}    Get Text    ${PIFInsuredRevenueEstimate}
    Run Keyword And Continue On Failure    Should Be Equal    ${expectedPIFInsuredDetails['PIFInsuredRevenueEstimateValue']}    ${RevenueValue}

    Fill Text    ${PIFInsuredYearsInBusiness}    ${expectedPIFInsuredDetails['PIFInsuredYearsInBusinessValue']}
    Fill Text    ${PIFInsuredOperationDesc}    ${expectedPIFInsuredDetails['PIFInsuredOperationDescValue']}
    Fill Text    ${PIFInsuredDomiciledState}    ${expectedPIFInsuredDetails['PIFInsuredYearsInBusinessValue']}
    Fill Text    ${PIFInsuredOutSideTheUS}    ${expectedPIFInsuredDetails['PIFInsuredOutsideYheUSValue']}
   
Verify Form Policy Instruction Form Producer Details
    [Arguments]    ${expectedPIFGProducerDetailsInput}
    ${elements}=    Get Elements    ${PIFProducerData}
    ${ActualList}    Create List
    FOR    ${element}    IN    @{elements}
    ${elementText}    Get Attribute    ${element}    value
    ${actualelementText}    Strip String    ${elementText}
    Append To List    ${ActualList}        ${actualelementText}
    END
    Run Keyword And Continue On Failure    Lists Should Be Equal    ${expectedPIFGProducerDetailsInput['expectedPIFProducerDetails']}    ${ActualList}
 
Verify Form Policy Instruction Form Processing Details
    [Arguments]    ${expectedPIFProcessingrDetails}
    ${elements}=    Get Elements    ${PIFProcessingExpected}
    ${ActualList}    Create List
    FOR    ${element}    IN    @{elements}
    ${elementText}    Get Text    ${element}
    ${hasNewLine}=    Run Keyword And Return Status    Should Contain    ${elementText}    \n
        IF    ${hasNewLine}
            @{splitValue}=    Split String    ${elementText}    \n
            ${split}=    Strip String    ${splitValue}[1]
            Append To List    ${ActualList}    ${split}
        ELSE
            ${trimData}=    Strip String    ${elementText}
            Append To List    ${ActualList}    ${trimData}
        END
    END
    Run Keyword And Continue On Failure    Lists Should Be Equal    ${expectedPIFProcessingrDetails['ProcessingDetails']['VerificationValues']}    ${ActualList}
    Click    ${PIFProcessingUWOffice}
    ${ProcessingUWOffice}=    Catenate    SEPARATOR=    ${PIFProcessingUWOfficeOption}    ${expectedPIFProcessingrDetails['ProcessingDetails']['PIFProcessingUWOfficeValue']}    ']
    Wait For Elements State    ${ProcessingUWOffice}    visible
    Click    ${ProcessingUWOffice}
    Click    ${PIFProcessingRepOffice}
    ${ProcessingRepOffice}=    Catenate    SEPARATOR=    ${PIFProcessingUWOfficeOption}    ${expectedPIFProcessingrDetails['ProcessingDetails']['PIFProcessingRepOfficeValue']}     ']
    Wait For Elements State    ${ProcessingRepOffice}    visible
    Click    ${ProcessingRepOffice}
 
    # Click    ${PIFProcessingChannel}
    # ${ProcessingChannel}=    Catenate    SEPARATOR=    ${PIFProcessingUWOfficeOption}    ${expectedPIFProcessingrDetails['ProcessingDetails']['PIFProcessingChannelValue']}     ']
    # Wait For Elements State    ${ProcessingChannel}    visible
    # Click    ${ProcessingChannel}
 
    #New Modified----Channel steps
    ${ChannelHeader}    Get Text    ${PIFProcessingChannel}
 
    IF    '${ChannelHeader.strip()}' == ''
    Click    ${PIFProcessingChannel}
    ${ProcessingChannel}=    Catenate    SEPARATOR=    ${PIFProcessingUWOfficeOption}    ${expectedPIFProcessingrDetails['ProcessingDetails']['PIFProcessingChannelValue']}     ']
    Wait For Elements State    ${ProcessingChannel}    visible
    Click    ${ProcessingChannel}
    ELSE
    Log    Continue the steps
    END
 
 
 
    # Click    ${PIFProcessingSubChannel}
    # ${ProcessingSubChannel}=    Catenate    SEPARATOR=    ${PIFProcessingUWOfficeOption}    ${expectedPIFProcessingrDetails['ProcessingDetails']['PIFProcessingSubChannelValue']}     ']
    # Wait For Elements State    ${ProcessingSubChannel}    visible
    # Click    ${ProcessingSubChannel}
 
    #New Modified----Sub Channel
    ${SubChannelHeader}    Get Text    ${PIFProcessingSubChannel}
    IF    '${SubChannelHeader}' == 'Select a sub channel'
    Click    ${PIFProcessingSubChannel}
    ${ProcessingSubChannel}=    Catenate    SEPARATOR=    ${PIFProcessingUWOfficeOption}    ${expectedPIFProcessingrDetails['ProcessingDetails']['PIFProcessingSubChannelValue']}     ']
    Wait For Elements State    ${ProcessingSubChannel}    visible
    Click    ${ProcessingSubChannel}    
    END
    IF    '${SubChannelHeader}' != 'Select a sub channel'
     Log    Continue the steps
     END
 
Verify Form Policy Instruction Form Underwritting Details
   [Arguments]    ${expectedPIFUnderwrittingDetails}
    Wait For Elements State    ${PIFUWWrittingCompany}    visible
    Click    ${PIFUWWrittingCompany}
    ${UWWrittingCompany}=    Catenate    SEPARATOR=    ${PIFProcessingUWOfficeOption}    ${expectedPIFUnderwrittingDetails['UnderWrittingDetails']['WrittingCompanyName']}     ']
    Wait For Elements State    ${UWWrittingCompany}    visible
    Click    ${UWWrittingCompany}
    ${AuditableRadioButton}=    Catenate    SEPARATOR=    ${PIFUWRadioButton1}    ${expectedPIFUnderwrittingDetails['UnderWrittingDetails']['AuditabilityValue']}     ${PIFUWRadioButton2}
    Wait For Elements State    ${AuditableRadioButton}    visible
    Click    ${AuditableRadioButton}
    ${BillibgTypeRadioButton}=    Catenate    SEPARATOR=    ${PIFUWRadioButton1}    ${expectedPIFUnderwrittingDetails['UnderWrittingDetails']['BillingTypeValue']}     ${PIFUWRadioButton2}
    Wait For Elements State    ${BillibgTypeRadioButton}    visible
    Click    ${BillibgTypeRadioButton}
 
Verify Form Policy Instruction Form Hazard Grade Details
   [Arguments]    ${HazardGradeDetails}

    Fill Text    ${PIFHGSICCode}    ${HazardGradeDetails['HazardGradeDetails']['PIFHGSICCode']}
    Fill Text    ${PIFHGNAICSCode}    ${HazardGradeDetails['HazardGradeDetails']['PIFHGNAICSCode']}
    Fill Text    ${PIFHGProperty}    ${HazardGradeDetails['HazardGradeDetails']['Property']}
    Fill Text    ${PIFHGPropertyNetCompanyLimit}    ${HazardGradeDetails['HazardGradeDetails']['PropertyNetCompanyLimit']}
    FOR    ${Endorsement}    IN    @{HazardGradeDetails['HazardGradeDetails']['EnhancementEndorsement']}
         ${EndorsementCheckbox}=    Catenate    SEPARATOR=    ${PIFUWRadioButton1}    ${Endorsement}     ${PIFUWRadioButton2}
        Wait For Elements State    ${EndorsementCheckbox}    visible
        Uncheck Checkbox    ${EndorsementCheckbox}
        Check Checkbox    ${EndorsementCheckbox}
        #Click    ${EndorsementCheckbox}      
    END
    FOR    ${Machinery}    IN    @{HazardGradeDetails['HazardGradeDetails']['BoilerMachinery']}
         ${MachineryCheckBox}=    Catenate    SEPARATOR=    ${PIFUWRadioButton1}    ${Machinery}     ${PIFUWRadioButton2}
        Wait For Elements State    ${MachineryCheckBox}    visible
        #Click    ${MachineryCheckBox}
        Uncheck Checkbox    ${MachineryCheckBox}
        Check Checkbox    ${MachineryCheckBox}      
    END
 
Verify Form Policy Instruction Form Reinsurance Details
   [Arguments]    ${ReinsuranceDetailsData}
#    Scroll To Element    ${PIFReinsuranceCdedPrescentage}
#    Wait For Elements State    ${PIFReinsuranceCdedPrescentage}
   Fill Text    ${PIFReinsuranceCdedPrescentage}    ${ReinsuranceDetailsData['ReinsuranceDetails']['cedePrecentage']}
Verify Form Policy Instruction Form Instruction Details
   [Arguments]    ${ReinsuranceDetailsData}
    Wait For Elements State    ${PIFInstructionDate}    visible
    Click    ${PIFInstructionDate}
    ${day}    Get Current Day Number
    ${actualCurrentDate}    Convert To Integer    ${day}
    ${CurrentDateInput}    Convert To Integer    ${ReinsuranceDetailsData['PIFPolicyDateNumberInput']}
    ${sum}=    Evaluate    ${actualCurrentDate} + ${CurrentDateInput}
    ${currentdate}=    Catenate    SEPARATOR=    ${PIFGeneralDateSelect}    ${sum}    ']
    Wait For Elements State    ${currentdate}    visible
    Click    ${currentdate}
    Fill Text    ${PIFInstructionsAdditionalInformation}    ${ReinsuranceDetailsData['InstructionDetails']['AdditionalInformation']}

Switch To NY FreeTrade Zone
    Wait For Elements State    ${FormsNYFTZOption}    visible
    Click    ${FormsNYFTZOption}

Verify Form NY Free Trade Zone Instructions
    [Arguments]    ${ExpectedInstructions}
    # Wait For Elements State    ${FormsNYFTZOption}    visible
    # Click    ${FormsNYFTZOption}
    ${elements}=    Get Elements    ${NYFExpectedInstructions}
    ${ActualList}    Create List
    FOR    ${elements}    IN    @{elements}
    ${elementText}    Get Text    ${elements}
    ${actualelementText}    Strip String    ${elementText}
    Append To List    ${ActualList}        ${actualelementText}
    END
    Run Keyword And Continue On Failure    Lists Should Be Equal    ${ExpectedInstructions}    ${ActualList}
 
Verify Form NY Free Trade Zone Documentation
    [Arguments]    ${DocumentationData}
    ${elementText}    Get Text    ${NYFDocumentationUnderwriter}
    ${actualelementText}    Strip String    ${elementText}
    Should Contain    ${actualelementText}    ${DocumentationData['Underwriter']}
    ${elementText}    Get Attribute    ${NYFDocumentationPolicyNumber}    value
    ${actualText}    Strip String    ${elementText}
    Should Contain    ${actualText}    ${DocumentationData['PolicyNumber']}
    fill text    ${NYFDocumentationPolicyPremiumField}    ${DocumentationData['PolicyPremium']}
    fill text    ${NYFDocumentationNYPremiumField}    ${DocumentationData['NYPremium']}
 
Form NY Free Trade Zone Eligibility
    [Arguments]    ${EligibilityData}
    fill text    ${NYFEligibilityClass1Field}    ${EligibilityData['Class1']}
    fill text    ${NYFEligibilityClass2Field}    ${EligibilityData['Class2']}
    fill text    ${NYFEligibilityClass3Field}    ${EligibilityData['Class3']}
 
Form NY Free Trade Zone Exposures
    [Arguments]    ${ExposuresData}
    fill text    ${NYFExposuresClassificationField}    ${ExposuresData['Classification']}
    fill text    ${NYFExposuresDescriptionField}    ${ExposuresData['Description']}
    fill text    ${NYFExposuresLimitsProvidedField}    ${ExposuresData['LimitsProvided']}
 
Form NY Free Trade Zone Underwriting Evaluation
    [Arguments]    ${UnderwritingEvaluationData}
    fill text    ${NYFUnderwritingEvaluationField}    ${UnderwritingEvaluationData['Evaluation']}
 
Switch to Rate Form
    Wait For Elements State    ${RateForm}    visible
    Click    ${RateForm}
    Wait For Elements State    ${RateFormHeader}    visible
 
Select Reason For Documentation
    [Arguments]    ${reason}    ${expectedText}
    ${elements}    Get Elements    ${ReasonForDocumentationText}
    ${ActualList}    Create List
    FOR    ${element}    IN    @{elements}
        ${elementText}    Get Text    ${element}
        ${actualelementText}    Strip String    ${elementText}
        Append To List    ${ActualList}    ${actualelementText}        
    END
    Run Keyword And Continue On Failure    Lists Should Be Equal    ${expectedText}    ${ActualList}
    Wait For Elements State    ${ReasonForDocumentation}    visible
    # Click    ${ReasonForDocumentation}
    ${reasonForDoc}    Catenate    SEPARATOR=    ${ReasonForDocumentationOption}    ${reason}    ']
    Wait For Elements State    ${reasonForDoc}   visible
    Check Checkbox    ${reasonForDoc}
 
General Section In Rate Form
    [Arguments]    ${expectedGeneralSectionText}    ${data}
    Wait For Elements State    ${GeneralSection}    visible
    ${elements}    Get Elements    ${GeneralSectionText}
    ${ActualList}    Create List
    FOR    ${element}    IN    @{elements}
        ${elementText}    Get Text    ${element}
        ${actualelementText}    Strip String    ${elementText}
        Append To List    ${ActualList}        ${actualelementText}
    END
    Lists Should Be Equal    ${expectedGeneralSectionText}    ${ActualList}
    Fill Text    ${PolicyNumber}    ${data['PolicyNumber']}
    ${effDate}    Get Text    ${PolicyEffectiveDate}
    ${effDate}    Strip String    ${effDate}
    ${expectedDate}    Strip String    ${data['PolicyEffectiveDate']}
    Should Be Equal As Strings    ${effDate}    ${expectedDate}
    Select Options By    ${WritingCompanyDropdown}    value    ${data['WritingCompany']}
    ${WritingCompany}    Get Selected Options    ${WritingCompanyDropdown}
    Run Keyword And Continue On Failure    List Should Contain Value    ${WritingCompany}    ${data['WritingCompany']}
 
Deviated Rate Locations
    [Arguments]    ${expectedDeviatedRateLocationsText}    ${data}
    ${elements}    Get Elements    ${DeviatedRateLocationText}
    ${ActualList}    Create List
    FOR    ${element}    IN    @{elements}
        ${elementText}    Get Text    ${element}
        ${actual_elementText}    Strip String    ${elementText}
        Append To List    ${ActualList}        ${actual_elementText}
    END
    Run Keyword And Continue On Failure    Lists Should Be Equal    ${expectedDeviatedRateLocationsText}    ${ActualList}
    Click    ${AddButtonInDeviatedRateLocations}
    Wait For Elements State    ${AddDeviatedLocationDialogBox}    visible
    FOR    ${locations}    IN    @{data}
        ${location}    Catenate        SEPARATOR=    ${SelectLocation}    ${locations}    ']]
        Wait For Elements State    ${location}    visible
        Check Checkbox    ${location}
    END
    Click    ${CloseDialogBox}
    Wait For Elements State    ${AddDeviatedLocationDialogBox}    hidden
 
Deviated Rate Coverage
    [Arguments]    ${expectedDeviatedRateCoverageText}    ${data}
    ${elements}    Get Elements    ${DeviatedRateCoverage}
    ${ActualList}    Create List
    FOR    ${element}    IN    @{elements}
        ${elementText}    Get Text    ${element}
        ${actual_elementText}    Strip String    ${elementText}
        Append To List    ${ActualList}        ${actual_elementText}
    END
    Run Keyword And Continue On Failure    Lists Should Be Equal    ${expectedDeviatedRateCoverageText}    ${ActualList}
    FOR    ${coverage}    IN    @{data['ApplicableCoverages']}
        ${coverages}    Catenate            SEPARATOR=    ${SelectAllApplicableCoverages}    ${coverage}    ']]
        Wait For Elements State    ${coverages}    visible
        Check Checkbox    ${coverages}
    END
    Fill Text    ${Limits}    ${data['Limits']}
    Fill Text    ${Classification}    ${data['Classification']}    
    Fill Text    ${Code}    ${data['Code']}
    Fill Text    ${ExposureBasis}    ${data['ExposureBasis']}
 
Rating Detail
    [Arguments]    ${expectedRatingDetailText}    ${data}
    ${elements}    Get Elements    ${RatingDetailText}
    ${ActualList}    Create List
    FOR    ${element}    IN    @{elements}
        ${elementText}    Get Text    ${element}
        ${actual_elementText}    Strip String    ${elementText}
        Append To List    ${ActualList}        ${actual_elementText}
    END
    Run Keyword And Continue On Failure    Lists Should Be Equal    ${expectedRatingDetailText}    ${ActualList}
    ${ManualFactors}    Create List    Rate:    Incr. Limit Factor:    Deductible/SIR Factor:
    FOR    ${factor}    IN    @{ManualFactors}
        ${factorPrefix}    Catenate    SEPARATOR=    ${ManualFactorPremisesValuePrefix}    ${factor}    ${ManualFactorPremissesSuffix}
        Wait For Elements State    ${factorPrefix}    visible
        Fill Text    ${factorPrefix}    ${data['ManualFactors']['${factor}']['premises']}
        ${factorPrefix}    Catenate    SEPARATOR=    ${ManualFactorProductsValuePrefix}    ${factor}    ${ManualFactorProductsSuffix}
        Wait For Elements State    ${factorPrefix}    visible
        Fill Text    ${factorPrefix}    ${data['ManualFactors']['${factor}']['products']}
    END
    ${SelectedFactors}    Create List    Rate:    Incr. Limits:    Deductible/SIR Factor:
    FOR    ${factor}    IN    @{SelectedFactors}
        ${factorPrefix}    Catenate    SEPARATOR=    ${SelectedFactorPremisesValuePrefix}    ${factor}    ${SelectedFactorPremisesValueSuffix}
        Wait For Elements State    ${factorPrefix}    visible
        Fill Text    ${factorPrefix}    ${data['SelectedFactors']['${factor}']['premises']}
        ${factorPrefix}    Catenate    SEPARATOR=    ${SelectedFactorProductsValuePrefix}    ${factor}    ${SelectedFactorProductsSuffix}
        Wait For Elements State    ${factorPrefix}    visible
        Fill Text    ${factorPrefix}    ${data['SelectedFactors']['${factor}']['products']}
    END
    ${RateEligibility}    Get Text    ${DeviatedRateEligibilityDescription}
    Run Keyword And Continue On Failure    Should Be Equal    ${RateEligibility}    ${data['DeviatedRateEligibilityDescription']}
    ${RateExposure}    Get Text    ${DeviatedRateExposureDescription}
    Run Keyword And Continue On Failure    Should Be Equal    ${RateExposure}    ${data['DeviatedRateExposureDescription']}
    Fill Text    ${DeviatedRateEligibility}    ${data['DeviatedRateEligibility']}
    Fill Text    ${DeviatedRateExposure}    ${data['DeviatedRateExposure']}
 
Upload Relevant Documents for Rate
    [Arguments]    ${data}
    
    # ${CancelBtn}    Catenate    SEPARATOR=    ${Loc_Upload_cancel_Btn}    ${file}    ${Loc_Upload_cancel_Btn1}
    # ${Status}    Run Keyword And Return Status    Get Element States    ${CancelBtn}    Validate    value & visible
    
    # IF    ${Status} == True
    #     Wait For Elements State    ${CancelBtn}
    #     Click    ${CancelBtn}
    # END


    FOR    ${file}    IN    @{data['UploadFile']}

        ${CancelBtn}    Catenate    SEPARATOR=    ${Loc_Upload_cancel_Btn}    ${file}    ${Loc_Upload_cancel_Btn1}
        ${Status}    Run Keyword And Return Status    Get Element States    ${CancelBtn}    Validate    value & visible
    
        IF    ${Status} == True
        Wait For Elements State    ${CancelBtn}
        Click    ${CancelBtn}
        END

            ${AbsolutePath}=    Normalize Path    ${AttachmentPath}${file}
            Upload File By Selector    ${UploadFile}    ${AbsolutePath}
            ${AttachedDocument}=    Catenate    SEPARATOR=    ${AttachedDocumentName}    ${file}']
            Wait For Elements State    ${AttachedDocument}    visible
    END
 
Save Changes in Form
    [Arguments]    ${data}
    Wait For Elements State    ${SaveChangesButton}    visible
    Click    ${SaveChangesButton}
    ${Popup_Text}    Catenate    SEPARATOR=    ${SaveChangesPopup}    ${data['SaveChangesPopup']}    '])[1]    
    ${popupText}    Get Text    ${Popup_Text}
    Run Keyword And Continue On Failure    Should Be Equal As Strings    ${popupText}    ${data['SaveChangesPopup']}
 
Switch To Manuscript Tab
    Wait For Elements State    ${Loc_Manuscript_btn}
    click    ${Loc_Manuscript_btn}
Verify Manuscript Tab Header
    [Arguments]    ${exceptedHeader}
    ${Actual_header}    Get Text    ${Loc_Manuscript_Tab_Verify}
    Log    Actual header we get is : ${Actual_header}
    Run Keyword And Continue On Failure    Should Be Equal    ${exceptedHeader}    ${Actual_header}
 
Reason for Documentation
    [Arguments]    ${Excepted_Reason_Tab}    ${exceptedCheckbox}
    ${Actual_Tab}    Get Text    ${Loc_Reason_Tab_verify}
    Log    Actual header we get is : ${Actual_Tab}
    Should Be Equal    ${Excepted_Reason_Tab}    ${Actual_Tab}
    IF    '${exceptedCheckbox}' == 'Deregulation'
    Wait For Elements State    ${Loc_Deregulation_Checkbox}
    Check Checkbox    ${Loc_Deregulation_Checkbox}
    Get Checkbox State    ${Loc_Deregulation_Checkbox}
    ELSE IF    '${exceptedCheckbox}' == 'Manuscript Forms'
    Wait For Elements State    ${Loc_Manuscript_Form_Checkbox}
    Check Checkbox    ${Loc_Manuscript_Form_Checkbox}
    Get Checkbox State    ${Loc_Manuscript_Form_Checkbox}
    ELSE
    Log    Checkbox was not clicked
    END    
 
General Tab
    [Arguments]    ${exceptedGeneralTab}    ${GenaralDetails}
    ${actual_Tab}    Get Text    ${Loc_General_Tab}
    Log    Actual header we get is : ${actual_Tab}
    Run Keyword And Continue On Failure    Should Be Equal    ${exceptedGeneralTab}    ${actual_Tab}
    ${actual_Company}    Get Text    ${Loc_WritingCom_Verify}
    Log    Actual Writing company we get is : ${actual_Company}
    Run Keyword And Continue On Failure    Should Be Equal    ${GenaralDetails['CompanyName']}    ${actual_Company}
 
    ${actual_policyNo}    Get Text    ${Loc_PolicyNo}
    Log    Actual policy number we get is : ${actual_policyNo}
    Run Keyword And Continue On Failure    Should Be Equal    ${GenaralDetails['PolicyNumber']}    ${actual_policyNo}
 
     ${actual_EffecctiveDate}    Get Text    ${Loc_EffecDate}
    Log    Actual policy number we get is : ${actual_EffecctiveDate}
    Run Keyword And Continue On Failure    Should Be Equal    ${GenaralDetails['EffectiveDate']}    ${actual_EffecctiveDate}
 
 
    ${actual_ExpiryDate}    Get Text    ${Loc_ExpiryDate}
    Log    Actual Expiry Date we get is : ${actual_ExpiryDate}
    Run Keyword And Continue On Failure    Should Be Equal    ${GenaralDetails['ExpiryDate']}    ${actual_ExpiryDate}
 
Refer to Lines of Business
    [Arguments]    ${exceptedReferlines}    @{checkBoxHeader}
    Scroll To Element    ${Loc_Refer_Lines}
    ${actual_ReferLines_header}    Get Text    ${Loc_Refer_Lines}
    Log    Actual header we get is : ${actual_ReferLines_header}
    Run Keyword And Continue On Failure    Should Be Equal    ${exceptedReferlines}    ${actual_ReferLines_header}
   
    FOR    ${Checkbox}    IN    @{checkBoxHeader}
    ${Loc_Refer_CheckBox}    Catenate    SEPARATOR=    ${Loc_ReferLines_Checkbox1}    ${Checkbox}    ${Loc_ReferLines_Checkbox2}
 
    Wait For Elements State    ${Loc_Refer_CheckBox}
    Uncheck Checkbox    ${Loc_Refer_CheckBox}
    Check Checkbox    ${Loc_Refer_CheckBox}
    Get Checkbox State    ${Loc_Refer_CheckBox}
     
    END
 Insured Information
    [Arguments]    ${SelectState}
    #Wait For Elements State    ${Loc_SelectState}
    Select Options By    ${Loc_SelectState}    value    ${SelectState}
    ${Act_State}    Get Selected Options    ${Loc_SelectState}
    Log    'The Actual State was Selected : ${Act_State}'
 
 
ManuScript Details
    [Arguments]    ${Description}    ${DescriptionExplore}
    Wait For Elements State    ${Loc_Description}
    Fill Text    ${Loc_Description}    ${Description}
    ${Actual_Description}    Get Text    ${Loc_Description}
    Log    The Actual Description We get: ${Actual_Description}
 
    Wait For Elements State    ${Loc_Desc_Explore}
    Fill Text    ${Loc_Desc_Explore}    ${DescriptionExplore}
     ${Actual_ExporeDescription}    Get Text    ${Loc_Desc_Explore}
    Log    The Actual Description of explore We get: ${Actual_ExporeDescription}
 
Upload Relevant Documents for Manuscript
    [Arguments]    ${data}
    FOR    ${file}    IN    ${data['DocumentName']}

        ${CancelBtn}    Catenate    SEPARATOR=    ${Loc_Upload_cancel_Btn}    ${file}    ${Loc_Upload_cancel_Btn1}
        ${Status}    Run Keyword And Return Status    Get Element States    ${CancelBtn}    Validate    value & visible
    
        IF    ${Status} == True
        Wait For Elements State    ${CancelBtn}
        Click    ${CancelBtn}
        END
            ${AbsolutePath}=    Normalize Path    ${AttachmentPath}${file}
            Upload File By Selector    ${UploadFile}    ${AbsolutePath}
            ${AttachedDocument}=    Catenate    SEPARATOR=    ${AttachedDocumentName}    ${file}']
            Wait For Elements State    ${AttachedDocument}    visible    timeout=180s
    END
    
Switch to Company Underwriting Eligibility Form
    Wait For Elements State    ${FormsCUEGOption}    visible
    Click    ${FormsCUEGOption}
Verify Form Company Underwriting Eligibility General
    [Arguments]    ${ExpectedInstructions}
    ${elementText}    Get Attribute    ${NYFDocumentationPolicyNumber}    value
    ${actualText}    Strip String    ${elementText}
    Run Keyword And Continue On Failure    Should Be Equal    ${actualText}    ${ExpectedInstructions['ExpectedPolicyNumber']}
    ${elementText}    Get Text    ${CUEGExpectedGeneralEffectiveDate}
    ${actualText}    Strip String    ${elementText}
    Run Keyword And Continue On Failure    Should Be Equal    ${actualText}    ${ExpectedInstructions['ExpectedEffectiveDate']}
   
Verify Form Company Underwriting Eligibility Total Points
    [Arguments]    ${ExpectedInstructions}
    fill text    ${CUEGTotalPointsField}    ${ExpectedInstructions['TotalPointsValue']}
    ${elements}=    Get Elements    ${CUEGTotalPointsTableHeaders}
    ${ActualList}    Create List
    FOR    ${elements}    IN    @{elements}
    ${elementText}    Get Text    ${elements}
    ${actualelementText}    Strip String    ${elementText}
    Append To List    ${ActualList}        ${actualelementText}
    END
    Lists Should Be Equal    ${ExpectedInstructions['ExpectedTableHeaders']}    ${ActualList}
    ${elements}=    Get Elements    ${CUEGTotalPointsTableData}
    ${ActualList}    Create List
    FOR    ${elements}    IN    @{elements}
    ${elementText}    Get Text    ${elements}
    ${actualelementText}    Strip String    ${elementText}
    Append To List    ${ActualList}        ${actualelementText}
    END
    Run Keyword And Continue On Failure    Lists Should Be Equal    ${ExpectedInstructions['ExpectedTableData']}    ${ActualList}
 
Verify Form Company Underwriting Eligibility Management Attitude
    [Arguments]    ${ManagementAttitudeData}
    ${elements}=    Get Elements    ${CUEGManagementDetails}
    ${ActualList}    Create List
    FOR    ${elements}    IN    @{elements}
    ${elementText}    Get Text    ${elements}
    ${actualelementText}    Strip String    ${elementText}
    Append To List    ${ActualList}        ${actualelementText}
    END
    Run Keyword And Continue On Failure    Lists Should Be Equal    ${ManagementAttitudeData['ExpectedTableData']}    ${ActualList}
    Fill Text    ${FormsNYUEGPremiumDocumentation}    ${ManagementAttitudeData['DocumentationInput']}
Verify Form Company Underwriting Eligibility Company Inspection Details
    [Arguments]    ${CompanyInspectionmData}
    ${elements}=    Get Elements    ${CUEGCompanyInspectionDetails}
    ${ActualList}    Create List
    FOR    ${elements}    IN    @{elements}
    ${elementText}    Get Text    ${elements}
    ${actualelementText}    Strip String    ${elementText}
    Append To List    ${ActualList}        ${actualelementText}
    END
    Run Keyword And Continue On Failure    Lists Should Be Equal    ${CompanyInspectionmData['ExpectedTableData']}    ${ActualList}
    Fill Text    ${CUEGCompanyInventoryRecords}    ${CompanyInspectionmData['InventoryRcordsInput']}
 
switch to Reinsurance Form
    Wait For Elements State    ${FormsReinsuranceOption}    visible
    Click    ${FormsReinsuranceOption}
Verify Reinsurance Form
    [Arguments]    ${ExpectedReinsurance}
    ${elements}=    Get Elements    ${ReinsuranceFacultativeObligatory}
    ${ActualList}    Create List
    FOR    ${element}    IN    @{elements}
    ${elementText}    Get Text    ${element}
    ${actualelementText}    Strip String    ${elementText}
    Append To List    ${ActualList}        ${actualelementText}
    END
    Lists Should Be Equal    ${ExpectedReinsurance['FacultativeObligatory']}    ${ActualList}
    ${FacultativeReinsuranceelementText}    Get Text    ${ReinsuranceFacultativeReinsurance}
    ${actualFacultativeReinsuranceelementText}    Strip String    ${FacultativeReinsuranceelementText}
    Run Keyword And Continue On Failure    Should Be Equal    ${ExpectedReinsurance['FacultativeReinsurance']}    ${actualFacultativeReinsuranceelementText}
    ${EquipmentBreakdownelementText}    Get Text    ${ReinsuranceEquipmentBreakdown}
    ${actualFacultativeReinsuranceelementText}    Strip String    ${EquipmentBreakdownelementText}
    Run Keyword And Continue On Failure    Should Be Equal    ${ExpectedReinsurance['EquipmentBreakdown']}    ${actualFacultativeReinsuranceelementText}
    ${AssumedReinsuranceelementText}    Get Text    ${ReinsuranceAssumedReinsurance}
    ${actualAssumedReinsuranceelementText}    Strip String    ${AssumedReinsuranceelementText}
    Run Keyword And Continue On Failure    Should Be Equal    ${ExpectedReinsurance['AssumedReinsurance']}    ${actualAssumedReinsuranceelementText}
    ${SwiftReelements}=    Get Elements    ${ReinsuranceSwiftRe}
    ${ActualSwiftReList}    Create List
    FOR    ${element}    IN    @{SwiftReelements}
    ${elementText}    Get Text    ${element}
    ${actualelementText}    Strip String    ${elementText}
    Append To List    ${ActualSwiftReList}        ${actualelementText}
    END
    Run Keyword And Continue On Failure    Lists Should Be Equal    ${ExpectedReinsurance['SwiftRe']}    ${ActualSwiftReList}
Select Check Box Reinsurance Form
    [Arguments]    ${CheckBoxOptionsData}
    ${ActualStatusButtons}    Get Elements    ${ReinsuranceCheckBoxes}
    ${ActualStatusButtonStatus}    Get Elements    ${ReinsuranceCheckBoxStatus}
    ${list_length}    Get Length    ${ActualStatusButtons}
    FOR    ${index}    IN RANGE    0    ${list_length}
    ${ActualStatusButton}    Set Variable    ${ActualStatusButtonStatus[${index}]}
    ${Status}    Get Checkbox State    ${ActualStatusButton}
    IF    '${Status}' == 'True'
        ${ActualStatus}    Set Variable    ${ActualStatusButtons[${index}]}
        Wait For Elements State    ${ActualStatus}    visible
        Click    ${ActualStatus}
    END
    END
    FOR    ${checkbox}    IN    @{CheckBoxOptionsData['CheckBoxOptions']}
        ${Reinsurance_CheckBox}    Catenate    SEPARATOR=    ${ReinsuranceCheckBoxes1}    ${checkbox}    ${ReinsuranceCheckBoxes3}
        Wait For Elements State    ${Reinsurance_CheckBox}
        ${Status}    Get Checkbox State    ${Reinsurance_CheckBox}
        IF    '${Status}' == 'False'
            ${Reinsurance_CheckBox}    Catenate    SEPARATOR=    ${ReinsuranceCheckBoxes1}    ${checkbox}    ${ReinsuranceCheckBoxes2}
            Wait For Elements State    ${Reinsurance_CheckBox}
            Click    ${Reinsurance_CheckBox}
        END
    END

Verify Check Box Reinsurance Form
    [Arguments]    ${CheckBoxOptionsData}
    FOR    ${checkbox}    IN    @{CheckBoxOptionsData['CheckBoxOptions']}
        ${Reinsurance_CheckBox}    Catenate    SEPARATOR=    ${ReinsuranceCheckBoxes1}    ${checkbox}    ${ReinsuranceCheckBoxes3}
        Wait For Elements State    ${Reinsurance_CheckBox}
        ${Status}    Get Checkbox State    ${Reinsurance_CheckBox}
        Should Be True    ${Status}    'True'
    END
    
switch to NY Underwriting Eligibility Guidelines Form
    Wait For Elements State    ${FormsNYUEGOption}    visible
    Click    ${FormsNYUEGOption}
 
Verify Form NY Underwriting Eligibility Guidelines Total Points Range
    [Arguments]    ${ExpectedInstructions}
    fill text    ${NYUEGTotalPointsField}    ${ExpectedInstructions['TotalPointsValue']}
    ${elements}=    Get Elements    ${NYUEGTotalPointsTableHeaders}
    ${ActualList}    Create List
    FOR    ${elements}    IN    @{elements}
    ${elementText}    Get Text    ${elements}
    ${actualelementText}    Strip String    ${elementText}
    Append To List    ${ActualList}        ${actualelementText}
    END
    Run Keyword And Continue On Failure    Lists Should Be Equal    ${ExpectedInstructions['ExpectedTableHeaders']}    ${ActualList}
    ${elements}=    Get Elements    ${NYUEGTotalPointsTableData}
    ${ActualList}    Create List
    FOR    ${elements}    IN    @{elements}
    ${elementText}    Get Text    ${elements}
    ${actualelementText}    Strip String    ${elementText}
    Append To List    ${ActualList}        ${actualelementText}
    END
    Run Keyword And Continue On Failure    Lists Should Be Equal    ${ExpectedInstructions['ExpectedTableData']}    ${ActualList}
Verify Form NY Underwriting Eligibility Guidelines Company Inspection Details
    [Arguments]    ${CompanyInspectionData}
    ${elements}=    Get Elements    ${CUEGCompanyInspectionDetails}
    ${ActualList}    Create List
    FOR    ${elements}    IN    @{elements}
    ${elementText}    Get Text    ${elements}
    ${actualelementText}    Strip String    ${elementText}
    Append To List    ${ActualList}        ${actualelementText}
    END
    Run Keyword And Continue On Failure    Lists Should Be Equal    ${CompanyInspectionData['ExpectedTableData']}    ${ActualList}
    Fill Text    ${FormsNYUEGPremiumDocumentation}    ${CompanyInspectionData['DocumentationInput']}
 

Policy Instruction Form Verification
    #${TC_Forms_001['PrimaryProperty']}
    [Arguments]    ${ExceptedHeader}

    Navigate to Form
    Switch to Policy Instruction Form

    Verify Form Summary Headers    ${ExceptedHeader}
    # Verify Form Summary Details    ${ExceptedHeader}


     ${elements}=    Get Elements    ${PIFGeneralData}
    ${ActualList}    Create List
    FOR    ${elements}    IN    @{elements}
    ${elementText}    Get Text    ${elements}
    ${actualelementText}    Strip String    ${elementText}
    Append To List    ${ActualList}        ${actualelementText}
    END
    Run Keyword And Continue On Failure    Lists Should Be Equal    ${ExceptedHeader['expectedPIFGeneralDetailsValues']}    ${ActualList}

    Wait For Elements State    ${PIFPolicyInputField}
    ${ActualGeneralDetails}    Get Text    ${PIFPolicyInputField}
    Run Keyword And Continue On Failure    Should Be Equal    ${ExceptedHeader['PIFPolicyInput']}    ${ActualGeneralDetails}

    
    ${actual_NeededDate}    Get Text    ${Loc_PIF_NeededDate}
    Log    Actual Needed Date we get is : ${actual_NeededDate}
    ${CurrentDateInput}    Convert To Integer    ${ExceptedHeader['PIFPolicyDateNumberInput']}
    ${date}=    Get Current Date    result_format=%b %d, %Y    increment=${CurrentDateInput}d
    Run Keyword And Continue On Failure    Should Be Equal    ${date}    ${actual_NeededDate}

    #${InsuredElements}    Get Element    ${expectedPIFInsuredDetails}
    ${ActualValues}    Create List
    FOR    ${actualelement}    IN    @{ExceptedHeader['PIFInsuredDetails']}
    ${element}    Strip String    ${actualelement}
    Log To Console    ${element}
    ${InsuredValues}    Catenate    SEPARATOR=    ${Loc_PIF_InsuredDetails1}    ${element}    ${Loc_PIF_InsuredDetails2} 
    ${ListOfValues}    Get Attribute    ${InsuredValues}    value
    Append To List    ${ActualValues}    ${ListOfValues}
    END
    Run Keyword And Continue On Failure    Lists Should Be Equal    ${ExceptedHeader['ExceptedInsuredvalues']}    ${ActualValues}

    ${DescValue}    Get Text    ${PIFInsuredOperationDesc}
     Run Keyword And Continue On Failure    Should Be Equal    ${ExceptedHeader['PIFInsuredOperationDescValue']}    ${DescValue}

    ${YearBusinessValue}    Get Text    ${PIFInsuredDomiciledState}
    Run Keyword And Continue On Failure    Should Be Equal    ${ExceptedHeader['PIFInsuredYearsInBusinessValue']}    ${YearBusinessValue}

    ${UsValue}    Get Text    ${PIFInsuredOutSideTheUS}
    Run Keyword And Continue On Failure    Should Be Equal    ${ExceptedHeader['PIFInsuredOutsideYheUSValue']}    ${UsValue}

    Run Keyword And Continue On Failure    Verify Form Policy Instruction Form Producer Details    ${ExceptedHeader}
    
     ${elements}=    Get Elements    ${PIFProcessingExpected}
    ${ActualList}    Create List
    FOR    ${element}    IN    @{elements}
    ${elementText}    Get Text    ${element}
    ${hasNewLine}=    Run Keyword And Return Status    Should Contain    ${elementText}    \n
        IF    ${hasNewLine}
            @{splitValue}=    Split String    ${elementText}    \n
            ${split}=    Strip String    ${splitValue}[1]
            Append To List    ${ActualList}    ${split}
        ELSE
            ${trimData}=    Strip String    ${elementText}
            Append To List    ${ActualList}    ${trimData}
        END
    END
    Run Keyword And Continue On Failure    Lists Should Be Equal    ${ExceptedHeader['ProcessingDetails']['VerificationValues']}    ${ActualList}

    ${ActualDatas}    Create List
    FOR    ${element}    IN    @{ExceptedHeader['PIFProcessingHeaders']}
    ${ProcessValue}    Catenate    SEPARATOR=    ${Loc_PIF_Process_Detail1}   ${element}    ${Loc_PIF_Process_Detail2}
    ${ProcessDetails}    Get Text   ${ProcessValue}
    Log    ${ProcessDetails}
    Append To List    ${ActualDatas}     ${ProcessDetails}   
    END
    Log    ${ActualDatas}
    #${Exceptedvalues}    Split String    ${ExceptedHeader['PIFProcessingValues']}
    Run Keyword And Continue On Failure    Lists Should Be Equal    ${ExceptedHeader['PIFProcessingValues']}    ${ActualDatas}


    # ${UWWrittingCompany}=    Catenate    SEPARATOR=    ${PIFProcessingUWOfficeOption}    ${ExceptedHeader['UnderWrittingDetails']['WrittingCompanyName']}     ']
    # Scroll To Element    ${UWWrittingCompany}
    Wait For Elements State    ${Loc_Writing_Company}    visible
    ${ActualCompany}    Get Text    ${Loc_Writing_Company}
    Run Keyword And Continue On Failure    Should Be Equal    ${ExceptedHeader['UnderWrittingDetails']['WrittingCompanyName']}    ${ActualCompany}
    
    ${AuditableRadioButton}=    Catenate    SEPARATOR=    ${PIFUWRadioButton1}    ${ExceptedHeader['UnderWrittingDetails']['AuditabilityValue']}     ${PIFUWRadioButton2}
    Wait For Elements State    ${AuditableRadioButton}    visible
    ${Checkbox}    Run Keyword And Return Status    Get Checkbox State    ${AuditableRadioButton}
    Run Keyword And Continue On Failure    Should Be True    ${Checkbox}

    ${BillibgTypeRadioButton}=    Catenate    SEPARATOR=    ${PIFUWRadioButton1}    ${ExceptedHeader['UnderWrittingDetails']['BillingTypeValue']}     ${PIFUWRadioButton2}
    Wait For Elements State    ${BillibgTypeRadioButton}    visible
    ${Checkbox1}    Run Keyword And Return Status    Get Checkbox State    ${BillibgTypeRadioButton}
    Run Keyword And Continue On Failure    Should Be True    ${Checkbox1}
 

     #[Arguments]    ${HazardGradeDetails}
    Wait For Elements State    ${PIFHGSICCode}
    ${Actual_SIC_Code}    Get Text    ${PIFHGSICCode}
    Run Keyword And Continue On Failure    Should Be Equal    ${ExceptedHeader['HazardGradeDetails']['PIFHGSICCode']}    ${Actual_SIC_Code}

    Wait For Elements State    ${PIFHGNAICSCode}
    ${Actual_NAIC_Code}    Get Text    ${PIFHGNAICSCode}
    Run Keyword And Continue On Failure    Should Be Equal    ${ExceptedHeader['HazardGradeDetails']['PIFHGNAICSCode']}    ${Actual_NAIC_Code}

    Wait For Elements State    ${PIFHGProperty}
    ${Actual_InsuredDomiciledState}    Get Text    ${PIFHGProperty}
    Run Keyword And Continue On Failure    Should Be Equal    ${ExceptedHeader['HazardGradeDetails']['Property']}    ${Actual_InsuredDomiciledState}


    Wait For Elements State    ${PIFHGPropertyNetCompanyLimit}
    ${Actual_InsuredOutside_US}    Get Text    ${PIFHGPropertyNetCompanyLimit}
    Run Keyword And Continue On Failure    Should Be Equal    ${ExceptedHeader['HazardGradeDetails']['PropertyNetCompanyLimit']}    ${Actual_InsuredOutside_US}

   
    FOR    ${Endorsement}    IN    @{ExceptedHeader['HazardGradeDetails']['EnhancementEndorsement']}
         ${EndorsementCheckbox}=    Catenate    SEPARATOR=    ${PIFUWRadioButton1}    ${Endorsement}     ${PIFUWRadioButton2}
        Wait For Elements State    ${EndorsementCheckbox}    visible
        ${Status}    Run Keyword And Return Status    Get Checkbox State    ${EndorsementCheckbox}
        Log    'The Checkbox Extract Status is ${Status}'      
    END
    FOR    ${Machinery}    IN    @{ExceptedHeader['HazardGradeDetails']['BoilerMachinery']}
         ${MachineryCheckBox}=    Catenate    SEPARATOR=    ${PIFUWRadioButton1}    ${Machinery}     ${PIFUWRadioButton2}
        Wait For Elements State    ${MachineryCheckBox}    visible
       ${Status}    Run Keyword And Return Status    Get Checkbox State    ${MachineryCheckBox}
        Log    'The Checkbox Extract Status is ${Status}'      
    END
     
    Wait For Elements State    ${PIFReinsuranceCdedPrescentage}
    ${ActualInsuredPerc}    Get Text    ${PIFReinsuranceCdedPrescentage}
    Run Keyword And Continue On Failure    Should Be Equal    ${ExceptedHeader['ReinsuranceDetails']['cedePrecentage']}    ${ActualInsuredPerc}
    

    Wait For Elements State    ${PIFInstructionDate}    visible
    ${Actual_CurentDate}    Get Text    ${PIFInstructionDate}
    # ${expected_day}    Get Current Day Number
    Run Keyword And Continue On Failure    Should Be Equal    ${date}   ${Actual_CurentDate}

    Wait For Elements State    ${PIFInstructionsAdditionalInformation}
    ${Actual_Additional_Informations}    Get Text    ${PIFInstructionsAdditionalInformation}
    Run Keyword And Continue On Failure    Should Be Equal    ${ExceptedHeader['InstructionDetails']['AdditionalInformation']}    ${Actual_Additional_Informations}
     

NY Free TRade Zone Verification
    #${TC_Forms_002}
    [Arguments]    ${ExceptedHeader}

    Navigate to Form
    Switch To NY FreeTrade Zone

    Verify Form NY Free Trade Zone Instructions    ${ExceptedHeader['ExpectedInstructionsValues']}

    Wait For Elements State    ${NYFDocumentationUnderwriter}
    ${elementText}    Get Text    ${NYFDocumentationUnderwriter}
    ${actualelementText}    Strip String    ${elementText}
    Run Keyword And Continue On Failure    Should Contain    ${actualelementText}    ${ExceptedHeader['DocumentationData']['Underwriter']}

    ${elementText}    Get Attribute    ${NYFDocumentationPolicyNumber}    value
    ${actualText}    Strip String    ${elementText}
    Run Keyword And Continue On Failure    Should Contain    ${actualText}    ${ExceptedHeader['DocumentationData']['PolicyNumber']}
    
    Wait For Elements State    ${NYFDocumentationPolicyPremiumField}
    ${ActualPolicyPremium}    Get Text    ${NYFDocumentationPolicyPremiumField}
    Run Keyword And Continue On Failure    Should Be Equal    ${ExceptedHeader['DocumentationData']['PolicyPremium']}    ${ActualPolicyPremium}

    Wait For Elements State    ${NYFDocumentationNYPremiumField}
    ${ActualNYPremium}    Get Text    ${NYFDocumentationNYPremiumField}
    Run Keyword And Continue On Failure    Should Be Equal    ${ExceptedHeader['DocumentationData']['NYPremium']}    ${ActualNYPremium}
    
    Wait For Elements State    ${NYFEligibilityClass1Field}
    ${ActualEligibilityClass1}    Get Text    ${NYFEligibilityClass1Field}
    Run Keyword And Continue On Failure    Should Be Equal    ${ExceptedHeader['EligibilityData']['Class1']}    ${ActualEligibilityClass1}

    Wait For Elements State    ${NYFEligibilityClass2Field}
    ${ActualEligibilityClass2}    Get Text    ${NYFEligibilityClass2Field}
    Run Keyword And Continue On Failure    Should Be Equal    ${ExceptedHeader['EligibilityData']['Class2']}    ${ActualEligibilityClass2}

    Wait For Elements State    ${NYFEligibilityClass3Field}
    ${ActualEligibilityClass3}    Get Text    ${NYFEligibilityClass3Field}
    Run Keyword And Continue On Failure    Should Be Equal    ${ExceptedHeader['EligibilityData']['Class3']}    ${ActualEligibilityClass3}
    
    
    Wait For Elements State    ${NYFExposuresClassificationField}
    ${ActualNYF_Classification}    Get Text    ${NYFExposuresClassificationField}
    Run Keyword And Continue On Failure    Should Be Equal    ${ExceptedHeader['ExposuresData']['Classification']}    ${ActualNYF_Classification}
    
    Wait For Elements State    ${NYFExposuresDescriptionField}
    ${ActualNYF_Description}    Get Text    ${NYFExposuresDescriptionField}
    Run Keyword And Continue On Failure    Should Be Equal    ${ExceptedHeader['ExposuresData']['Description']}    ${ActualNYF_Description}
    
    
    Wait For Elements State    ${NYFExposuresLimitsProvidedField}
    ${ActualNYF_LimitsProvided}    Get Text    ${NYFExposuresLimitsProvidedField}
    Run Keyword And Continue On Failure    Should Be Equal    ${ExceptedHeader['ExposuresData']['LimitsProvided']}    ${ActualNYF_LimitsProvided}
    
    Wait For Elements State    ${NYFUnderwritingEvaluationField}
    ${ActualNYF_UnderWritingEvaluation}    Get Text    ${NYFUnderwritingEvaluationField}
    Run Keyword And Continue On Failure    Should Be Equal    ${ExceptedHeader['UnderwritingEvaluationData']['Evaluation']}    ${ActualNYF_UnderWritingEvaluation}



    # fill text    ${NYFUnderwritingEvaluationField}    ${UnderwritingEvaluationData['Evaluation']}
    # fill text    ${NYFExposuresClassificationField}    ${ExposuresData['Classification']}
    # fill text    ${NYFExposuresDescriptionField}    ${ExposuresData['Description']}
    # fill text    ${NYFExposuresLimitsProvidedField}    ${ExposuresData['LimitsProvided']}
    

RATE FORM Verification
    Switch to Rate Form
    [Arguments]    ${reason}

    ${elements}    Get Elements    ${ReasonForDocumentationText}
    ${ActualList}    Create List
    FOR    ${element}    IN    @{elements}
        ${elementText}    Get Text    ${element}
        ${actualelementText}    Strip String    ${elementText}
        Append To List    ${ActualList}    ${actualelementText}        
    END
    Run Keyword And Continue On Failure    Lists Should Be Equal    ${reason['ReasonCardText']}    ${ActualList}
    # Wait For Elements State    ${ReasonForDocumentation}    visible
    # Click    ${ReasonForDocumentation}
    ${reasonForDoc}    Catenate    SEPARATOR=    ${ReasonForDocumentationOption}    ${reason['ReasonForDocumentation']}    ']
    Wait For Elements State    ${reasonForDoc}   visible
    ${ReasonDocument}    Get Attribute    ${reasonForDoc}    aria-checked
    Run Keyword And Continue On Failure    Should Be Equal    true    ${ReasonDocument}    

    Wait For Elements State    ${PolicyNumber}
    ${ActualPolicyNo}    Get Text    ${PolicyNumber}
    Run Keyword And Continue On Failure    Should Be Equal    ${reason['GeneralSectionData']['PolicyNumber']}    ${ActualPolicyNo}

    ${effDate}    Get Text    ${PolicyEffectiveDate}
    ${effDate}    Strip String    ${effDate}
    ${expectedDate}    Strip String    ${reason['GeneralSectionData']['PolicyEffectiveDate']}
    Run Keyword And Continue On Failure    Should Be Equal As Strings    ${effDate}    ${expectedDate}
    #Select Options By    ${WritingCompanyDropdown}    value    ${data['WritingCompany']}
    ${WritingCompany}    Get Selected Options    ${WritingCompanyDropdown}
    Run Keyword And Continue On Failure    List Should Contain Value    ${WritingCompany}    ${reason['GeneralSectionData']['WritingCompany']}
    ${LocationValue}    Catenate    SEPARATOR=    ${Loc_DeviatedRate}    ${reason['DeviatedRateLocationsData1']}    ']
    ${ActualValue}    Get Text    ${LocationValue}
    Run Keyword And Continue On Failure    Should Be Equal    ${reason['DeviatedRateLocationsData1']}    ${ActualValue}

    #Deviated Rate Coverage
    FOR    ${coverage}    IN    @{reason['DeviatedRateCoverageData']['ApplicableCoverages']}
        ${coverages}    Catenate            SEPARATOR=    ${PIFUWRadioButton1}    ${coverage}    ${PIFUWRadioButton2}
        Scroll To Element    ${coverages}
        Wait For Elements State    ${coverages}    visible
        ${Status}    Get Attribute    ${coverages}    aria-checked
        Run Keyword And Continue On Failure    Should Be Equal    true    ${Status}
    END

    Wait For Elements State    ${Limits}
    ${ActualLimit}    Get Text    ${Limits}
    Run Keyword And Continue On Failure    Should Be Equal    ${reason['DeviatedRateCoverageData']['Limits']}   ${ActualLimit}

    Wait For Elements State    ${Classification}
    ${ActualClassification}    Get Text    ${Classification}
    Run Keyword And Continue On Failure    Should Be Equal    ${reason['DeviatedRateCoverageData']['Classification']}   ${ActualClassification}
    
    Wait For Elements State    ${Code}
    ${ActualCode}    Get Text    ${Code}
    Run Keyword And Continue On Failure    Should Be Equal    ${reason['DeviatedRateCoverageData']['Code']}   ${ActualCode}

    Wait For Elements State    ${ExposureBasis}
    ${ActualExposureBasis}    Get Text    ${ExposureBasis}
    Run Keyword And Continue On Failure    Should Be Equal    ${reason['DeviatedRateCoverageData']['ExposureBasis']}   ${ActualExposureBasis}

    #Rating Details
    ${ManualFactors}    Create List    Rate:    Incr. Limit Factor:    Deductible/SIR Factor:
    FOR    ${factor}    IN    @{ManualFactors}
        ${factorPrefix}    Catenate    SEPARATOR=    ${ManualFactorPremisesValuePrefix}    ${factor}    ${ManualFactorPremissesSuffix}
        Wait For Elements State    ${factorPrefix}    visible
        ${ActualFactor}    Get Text    ${factorPrefix}
        ${ActualVal}    Convert To Integer    ${ActualFactor}
        Run Keyword And Continue On Failure     Should Be Equal    ${reason['RatingDetailData']['ManualFactors']['${factor}']['premises']}    ${ActualVal}
 
        ${factorPrefix}    Catenate    SEPARATOR=    ${ManualFactorProductsValuePrefix}    ${factor}    ${ManualFactorProductsSuffix}
        Wait For Elements State    ${factorPrefix}    visible
        ${ActualFactor1}    Get Text    ${factorPrefix}
        ${ActualVal1}    Convert To Integer    ${ActualFactor1}
        Run Keyword And Continue On Failure    Should Be Equal    ${reason['RatingDetailData']['ManualFactors']['${factor}']['products']}    ${ActualVal1}
    END
 
    ${SelectedFactors}    Create List    Rate:    Incr. Limits:    Deductible/SIR Factor:
    FOR    ${factor}    IN    @{SelectedFactors}
        ${factorPrefix}    Catenate    SEPARATOR=    ${SelectedFactorPremisesValuePrefix}    ${factor}    ${SelectedFactorPremisesValueSuffix}
        Wait For Elements State    ${factorPrefix}    visible
        ${ActualFactor}    Get Text    ${factorPrefix}
        ${ActualVal}    Convert To Integer    ${ActualFactor}
        Run Keyword And Continue On Failure    Should Be Equal    ${reason['RatingDetailData']['SelectedFactors']['${factor}']['premises']}    ${ActualVal}
 
        ${factorPrefix}    Catenate    SEPARATOR=    ${SelectedFactorProductsValuePrefix}    ${factor}    ${SelectedFactorProductsSuffix}
        Wait For Elements State    ${factorPrefix}    visible
        ${ActualFactor1}    Get Text    ${factorPrefix}
        ${ActualVal1}    Convert To Integer    ${ActualFactor1}
        Run Keyword And Continue On Failure    Should Be Equal    ${reason['RatingDetailData']['SelectedFactors']['${factor}']['products']}    ${ActualVal1}
    END
 
    ${RateEligibility}    Get Text    ${DeviatedRateEligibilityDescription}
    Should Be Equal    ${RateEligibility}    ${reason['RatingDetailData']['DeviatedRateEligibilityDescription']}
    ${RateExposure}    Get Text    ${DeviatedRateExposureDescription}
    Run Keyword And Continue On Failure    Should Be Equal    ${RateExposure}    ${reason['RatingDetailData']['DeviatedRateExposureDescription']}
 
    Wait For Elements State    ${DeviatedRateEligibility}
    ${ActualFactor1}    Get Text    ${DeviatedRateEligibility}
    Run Keyword And Continue On Failure    Should Be Equal    ${reason['RatingDetailData']['DeviatedRateEligibility']}    ${ActualFactor1}
 
    Wait For Elements State    ${DeviatedRateExposure}
    ${ActualFactor1}    Get Text    ${DeviatedRateExposure}
    Run Keyword And Continue On Failure    Should Be Equal    ${reason['RatingDetailData']['DeviatedRateExposure']}    ${ActualFactor1}    

Manuscript Data Verification
    # This method verifies the Details which we are added in Manuscript Tab
    #${TC_Forms_004['DeregulationHeader']}     ${TC_Forms_004['GenaralDetails']}    @{TC_Forms_004['checkBoxHeader']}    ${SelectState}
    #$${TC_Forms_004['ManuscriptForm_Desc']}    ${TC_Forms_004['Desc_Explore']}    ${TC_Forms_004}
   
    # [Arguments]    ${exceptedCheckbox}    ${GenaralDetails}    ${checkBoxHeader}    ${SelectState}    ${Description}    
    # ...    ${DescriptionExplore}    ${data}

    [Arguments]    ${exceptedCheckbox}

    Switch To Manuscript Tab   
 
    IF    '${exceptedCheckbox['DeregulationHeader']}' == 'Deregulation'
    Wait For Elements State    ${Loc_Deregulation_Checkbox}
    ${checkboxstatus}    Run Keyword And Return Status    Get Checkbox State    ${Loc_Deregulation_Checkbox}
    Run Keyword And Continue On Failure    Should Be True    ${checkboxstatus}
 
 
    ELSE IF    '${exceptedCheckbox['ManuscriptFormHeader']}' == 'Manuscript Forms'
    Wait For Elements State    ${Loc_Manuscript_Form_Checkbox}
    ${checkboxstatus}    Run Keyword And Return Status    Get Checkbox State    ${Loc_Manuscript_Form_Checkbox}
    Run Keyword And Continue On Failure    Should Be True    ${checkboxstatus}
 
    ELSE
    Log    Checkbox was not clicked
    END
 
    ${actual_Company}    Get Text    ${Loc_WritingCom_Verify}
    Log    Actual Writing company we get is : ${actual_Company}
    Run Keyword And Continue On Failure    Should Be Equal    ${exceptedCheckbox['GenaralDetails']['CompanyName']}    ${actual_Company}
 
    ${actual_policyNo}    Get Text    ${Loc_PolicyNo}
    Log    Actual policy number we get is : ${actual_policyNo}
    Run Keyword And Continue On Failure    Should Be Equal    ${exceptedCheckbox['GenaralDetails']['PolicyNumber']}    ${actual_policyNo}
 
     ${actual_EffecctiveDate}    Get Text    ${Loc_EffecDate}
    Log    Actual policy number we get is : ${actual_EffecctiveDate}
    Run Keyword And Continue On Failure    Should Be Equal    ${exceptedCheckbox['GenaralDetails']['EffectiveDate']}    ${actual_EffecctiveDate}
 
 
    ${actual_ExpiryDate}    Get Text    ${Loc_ExpiryDate}
    Log    Actual Expiry Date we get is : ${actual_ExpiryDate}
    Run Keyword And Continue On Failure    Should Be Equal    ${exceptedCheckbox['GenaralDetails']['ExpiryDate']}    ${actual_ExpiryDate}
   
    FOR    ${Checkbox}    IN    @{exceptedCheckbox['checkBoxHeader']}
    ${Loc_Refer_CheckBox}    Catenate    SEPARATOR=    ${Loc_ReferLines_Checkbox1}    ${Checkbox}    ${Loc_ReferLines_Checkbox2}
    Wait For Elements State    ${Loc_Refer_CheckBox}
    ${Status}    Run Keyword And Return Status    Get Checkbox State    ${Loc_Refer_CheckBox}
    Run Keyword And Continue On Failure    Should Be True    ${Status}
    END
 
    ${Act_State}    Get Selected options    ${Loc_SelectState}
    Log    'The Actual State was Selected : ${Act_State}'
    Run Keyword And Continue On Failure    List Should Contain Value    ${Act_State}    ${exceptedCheckbox['Insured_State']}    
 
    Wait For Elements State    ${Loc_Description}
    ${Actual_Description}    Get Text    ${Loc_Description}
    Log    The Actual Description We get: ${Actual_Description}
    Run Keyword And Continue On Failure    Should Be Equal    ${exceptedCheckbox['ManuscriptForm_Desc']}    ${Actual_Description}
 
    Wait For Elements State    ${Loc_Desc_Explore}
    ${Actual_ExporeDescription}    Get Text    ${Loc_Desc_Explore}
    Log    The Actual Description of explore We get: ${Actual_ExporeDescription}
    Run Keyword And Continue On Failure    Should Be Equal    ${exceptedCheckbox['Desc_Explore']}    ${Actual_ExporeDescription}  
   
    # FOR    ${file}    IN    ${exceptedCheckbox['DocumentName']}
    # ${AttachedDocument}=    Catenate    SEPARATOR=    ${Loc_Attachment_Select}    ${file}']
    # Wait For Elements State    ${AttachedDocument}    visible
    # ${ActualDoc}    Get Text    ${AttachedDocument}
    # Should Be Equal    ${exceptedCheckbox['DocumentName']}    ${ActualDoc}
    # END


Underwriting Eligibility Form Verification
    #${TC_Forms_005}    ${TC_Forms_005['TotalPoints']}
    [Arguments]    ${ExpectedInstructions}
    
    Switch to Company Underwriting Eligibility Form
    Run Keyword And Continue On Failure    Verify Form Company Underwriting Eligibility General    ${ExpectedInstructions['GeneralData']}

    
    Wait For Elements State    ${CUEGTotalPointsField}
    ${ActualPoints}    Get Text    ${CUEGTotalPointsField}
    Run Keyword And Continue On Failure    Should Be Equal    ${ExpectedInstructions['TotalPoints']['TotalPointsValue']}    ${ActualPoints}

    # fill text    ${CUEGTotalPointsField}    ${ExpectedInstructions['TotalPoints']['TotalPointsValue']}

    ${elements}=    Get Elements    ${CUEGTotalPointsTableHeaders}
    ${ActualList}    Create List
    FOR    ${elements}    IN    @{elements}
    ${elementText}    Get Text    ${elements}
    ${actualelementText}    Strip String    ${elementText}
    Append To List    ${ActualList}        ${actualelementText}
    END
    Run Keyword And Continue On Failure    Lists Should Be Equal    ${ExpectedInstructions['TotalPoints']['ExpectedTableHeaders']}    ${ActualList}
    ${elements}=    Get Elements    ${CUEGTotalPointsTableData}
    ${ActualList}    Create List
    FOR    ${elements}    IN    @{elements}
    ${elementText}    Get Text    ${elements}
    ${actualelementText}    Strip String    ${elementText}
    Append To List    ${ActualList}        ${actualelementText}
    END
    Run Keyword And Continue On Failure    Lists Should Be Equal    ${ExpectedInstructions['TotalPoints']['ExpectedTableData']}    ${ActualList}

    Run Keyword And Continue On Failure    Verify Form Company Underwriting Eligibility Management Attitude    ${ExpectedInstructions['ManagementAttitudevalues']}

    
    ${elements}=    Get Elements    ${CUEGCompanyInspectionDetails}
    ${ActualList}    Create List
    FOR    ${elements}    IN    @{elements}
    ${elementText}    Get Text    ${elements}
    ${actualelementText}    Strip String    ${elementText}
    Append To List    ${ActualList}        ${actualelementText}
    END
    # Lists Should Be Equal    ${ExpectedInstructions['CompanyInspectionValues']['ExpectedTableData']}    ${ActualList}
    
    Wait For Elements State    ${CUEGCompanyInventoryRecords}
    ${ActualPoints}    Get Text    ${CUEGCompanyInventoryRecords}
    Run Keyword And Continue On Failure    Should Be Equal    ${ExpectedInstructions['CompanyInspectionValues']['InventoryRcordsInput']}    ${ActualPoints}

    #Fill Text    ${CUEGCompanyInventoryRecords}    ${ExpectedInstructions['CompanyInspectionValues']['InventoryRcordsInput']}


NY Underwriting Eligibility Guidelines Form Verification  

    [Arguments]    ${ExpectedInstructions}

    ${elements}=    Get Elements    ${CUEGCompanyInspectionDetails}
    ${ActualList}    Create List
    FOR    ${elements}    IN    @{elements}
    ${elementText}    Get Text    ${elements}
    ${actualelementText}    Strip String    ${elementText}
    Append To List    ${ActualList}        ${actualelementText}
    END
    Run Keyword And Continue On Failure    Lists Should Be Equal    ${ExpectedInstructions['CompanyInspectionValues']['ExpectedTableData']}    ${ActualList}

    Wait For Elements State    ${FormsNYUEGPremiumDocumentation}
    ${ActualPoints}    Get Text    ${FormsNYUEGPremiumDocumentation}
    Run Keyword And Continue On Failure    Should Be Equal    ${ExpectedInstructions['CompanyInspectionValues']['DocumentationInput']}    ${ActualPoints}

    #Fill Text    ${CUEGCompanyInventoryRecords}    ${CompanyInspectionmData['InventoryRcordsInput']}



Complete Form
    [Arguments]    ${data}

    ${Status}    Run Keyword And Return Status    Get Element States  ${Loc_CompleteForm_btn}    validate    value & visible
    IF    ${Status}
    Wait For Elements State    ${Loc_CompleteForm_btn}
    Click    ${Loc_CompleteForm_btn}
    # ${Popup_Text}    Catenate    SEPARATOR=    ${SaveChangesPopup}    ${data['CompleteFormPopup']}    ']    
    # ${popupText}    Get Text    ${Popup_Text}
    # Should Be Equal As Strings    ${popupText}    ${data['CompleteFormPopup']}
    END
Complete Forms Tab Details Filling

    [Arguments]    ${data1}

    #Policy Instruction Form
    Navigate to Form
    Switch to Policy Instruction Form
    Run Keyword And Continue On Failure    Verify Form Summary Headers    ${data1['TC_Forms_001']['PrimaryProperty']}
    #Verify Form Summary Details    ${data1['TC_Forms_001']['PrimaryProperty']}
    Run Keyword And Continue On Failure    Verify Form Policy Instruction Form General Details    ${data1['TC_Forms_001']['PrimaryProperty']}
    Run Keyword And Continue On Failure    Verify Form Policy Instruction Form Indured Tab Details    ${data1['TC_Forms_001']['PrimaryProperty']}    
    Run Keyword And Continue On Failure    Verify Form Policy Instruction Form Producer Details    ${data1['TC_Forms_001']['PrimaryProperty']}
    Run Keyword And Continue On Failure    Verify Form Policy Instruction Form Processing Details    ${data1['TC_Forms_001']['PrimaryProperty']}
    Run Keyword And Continue On Failure    Verify Form Policy Instruction Form Underwritting Details    ${data1['TC_Forms_001']['PrimaryProperty']}
    Run Keyword And Continue On Failure    Verify Form Policy Instruction Form Hazard Grade Details    ${data1['TC_Forms_001']['PrimaryProperty']}
    Run Keyword And Continue On Failure    Verify Form Policy Instruction Form Reinsurance Details    ${data1['TC_Forms_001']['PrimaryProperty']}
    Run Keyword And Continue On Failure    Verify Form Policy Instruction Form Instruction Details    ${data1['TC_Forms_001']['PrimaryProperty']}
    Save Changes in Form    ${data1['TC_Forms_001']}
    Complete Form    ${data1['TC_Forms_001']}

   
    # # NY FreeTrade Zone

    Switch To NY FreeTrade Zone
    Run Keyword And Continue On Failure    Verify Form NY Free Trade Zone Instructions    ${data1['TC_Forms_002']['ExpectedInstructionsValues']}
    Run Keyword And Continue On Failure    Verify Form NY Free Trade Zone Documentation    ${data1['TC_Forms_002']['DocumentationData']}
    Form NY Free Trade Zone Eligibility    ${data1['TC_Forms_002']['EligibilityData']}
    Form NY Free Trade Zone Exposures    ${data1['TC_Forms_002']['ExposuresData']}
    Form NY Free Trade Zone Underwriting Evaluation    ${data1['TC_Forms_002']['UnderwritingEvaluationData']}
    Save Changes in Form    ${data1['TC_Forms_002']} 
     Complete Form    ${data1['TC_Forms_002']}

    # RateForm

    Switch to Rate Form
    Select Reason For Documentation    ${data1['TC_Forms_003']['ReasonForDocumentation']}    ${data1['TC_Forms_003']['ReasonCardText']}
    General Section In Rate Form    ${data1['TC_Forms_003']['GeneralSectionText']}    ${data1['TC_Forms_003']['GeneralSectionData']}
    Deviated Rate Locations    ${data1['TC_Forms_003']['DeviatedRateLocations']}    ${data1['TC_Forms_003']['DeviatedRateLocationsData']}
    Deviated Rate Coverage    ${data1['TC_Forms_003']['DeviatedRateCoverage']}    ${data1['TC_Forms_003']['DeviatedRateCoverageData']}
    Rating Detail    ${data1['TC_Forms_003']['RatingDetailText']}    ${data1['TC_Forms_003']['RatingDetailData']}
    # Upload Relevant Documents for Rate    ${data1['TC_Forms_003']['RatingDetailData']}
    Save Changes in Form    ${data1['TC_Forms_003']['RatingDetailData']}
    Complete Form    ${data1['TC_Forms_003']['RatingDetailData']}

    #Manuscript Form

    Switch To Manuscript Tab
    Run Keyword And Continue On Failure    Verify Manuscript Tab Header    ${data1['TC_Forms_004']['manuscriptHeader']}
    Reason for Documentation    ${data1['TC_Forms_004']['Reason_Tab_Header']}    ${data1['TC_Forms_004']['DeregulationHeader']}
    General Tab    ${data1['TC_Forms_004']['General_tab_Header']}    ${data1['TC_Forms_004']['GenaralDetails']}
    Refer to Lines of Business    ${data1['TC_Forms_004']['ReferToLinesHeader']}    @{data1['TC_Forms_004']['checkBoxHeader']}
    Insured Information    ${data1['TC_Forms_004']['Insured_State']}
    ManuScript Details    ${data1['TC_Forms_004']['ManuscriptForm_Desc']}    ${data1['TC_Forms_004']['Desc_Explore']}
    # Upload Relevant Documents for Manuscript    ${data1['TC_Forms_004']}
    Save Changes in Form    ${data1['TC_Forms_004']}
    Complete Form    ${data1['TC_Forms_004']}
    # Company Underwriting Eligibility Form

    Switch to Company Underwriting Eligibility Form
    Run Keyword And Continue On Failure    Verify Form Company Underwriting Eligibility General    ${data1['TC_Forms_005']['GeneralData']}
    Run Keyword And Continue On Failure    Verify Form Company Underwriting Eligibility Total Points    ${data1['TC_Forms_005']['TotalPoints']}
    Run Keyword And Continue On Failure    Verify Form Company Underwriting Eligibility Management Attitude    ${data1['TC_Forms_005']['ManagementAttitudevalues']}
    # Verify Form Company Underwriting Eligibility Company Inspection Details    ${data1['TC_Forms_005']['CompanyInspectionValues']}
    Save Changes in Form    ${data1['TC_Forms_005']}
    Complete Form    ${data1['TC_Forms_005']}
    # Reinsurance Form

    switch to Reinsurance Form
    Run Keyword And Continue On Failure    Verify Reinsurance Form    ${data1['TC_Forms_006']}
    Select Check Box Reinsurance Form    ${data1['TC_Forms_006']}
    Save Changes in Form    ${data1['TC_Forms_006']}
    Complete Form    ${data1['TC_Forms_006']}

    # NY Underwriting Eligibility Guidelines Form

    switch to NY Underwriting Eligibility Guidelines Form
    Run Keyword And Continue On Failure    Verify Form Company Underwriting Eligibility General    ${data1['TC_Forms_007']['GeneralData']}
    Run Keyword And Continue On Failure    Verify Form NY Underwriting Eligibility Guidelines Total Points Range    ${data1['TC_Forms_007']['TotalPoints']}
    Run Keyword And Continue On Failure    Verify Form Company Underwriting Eligibility Management Attitude    ${data1['TC_Forms_007']['ManagementAttitudevalues']}
    Run Keyword And Continue On Failure    Verify Form NY Underwriting Eligibility Guidelines Company Inspection Details    ${data1['TC_Forms_007']['CompanyInspectionValues']}
    Save Changes in Form    ${data1['TC_Forms_007']}
    Complete Form    ${data1['TC_Forms_007']}

Complete Forms Tab Details Verification

    [Arguments]    ${data1}

    Run Keyword And Continue On Failure    Policy Instruction Form Verification    ${data1['TC_Forms_001']['PrimaryProperty']}
    
    Run Keyword And Continue On Failure    NY Free TRade Zone Verification    ${data1['TC_Forms_002']}
    Run Keyword And Continue On Failure    RATE FORM Verification    ${data1['TC_Forms_003']}
    Run Keyword And Continue On Failure    Manuscript Data Verification    ${data1['TC_Forms_004']}    
    Run Keyword And Continue On Failure    Underwriting Eligibility Form Verification    ${data1['TC_Forms_005']}

    switch to Reinsurance Form
    Run Keyword And Continue On Failure    Verify Reinsurance Form    ${data1['TC_Forms_006']}
    Verify Check Box Reinsurance Form    ${data1['TC_Forms_006']}
    # Select Check Box Reinsurance Form    ${data1['TC_Forms_006']}

    switch to NY Underwriting Eligibility Guidelines Form
    Run Keyword And Continue On Failure    Verify Form Company Underwriting Eligibility General    ${data1['TC_Forms_007']['GeneralData']}
    Run Keyword And Continue On Failure    Verify Form NY Underwriting Eligibility Guidelines Total Points Range    ${data1['TC_Forms_007']['TotalPoints']}
    Run Keyword And Continue On Failure    Verify Form Company Underwriting Eligibility Management Attitude    ${data1['TC_Forms_007']['ManagementAttitudevalues']}

    Run Keyword And Continue On Failure    NY Underwriting Eligibility Guidelines Form Verification    ${data1['TC_Forms_007']} 
