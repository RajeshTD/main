*** Settings ***
Resource     ../../utils/common_keywords.robot
Variables     ../locators/answers_locators.py

*** Keywords ***

Click Answers Tab
    [Documentation]    Navigates to the 'Answers' tab within a submission.
    Wait For Elements State    ${Answers_Tab}    visible    timeout=30s
    # Handle Future Dialogs    action=accept    
    # ${promise} =         Promise To    Wait For Alert    action=accept
    Click    ${Answers_Tab}
    # Run Keyword And Ignore Error    Wait For      ${promise}
    Wait For Elements State    ${Answers}    visible    

Verify Answers Lists
    [Documentation]    Iterates through different categories of questions (e.g., Auto, Crime, General) on the Answers page.
    ...    For each category, it expands the section and then clicks on each question to verify that an answer rationale or an AI-generated answer is displayed.
    ...
    ...    *Arguments:*
    ...    - `${data_questions}`: A dictionary where keys are the answer categories and values are lists of question texts to verify within that category.
    [Arguments]    ${data_questions}
    ${lists}    Get Elements    ${Answers_List}
    FOR    ${list}    IN    @{lists}
        ${listValues}    Get Text    ${list}
        ${text}    Strip String    ${listValues}
        Click    ${list}
        IF    "${text}" == "Auto"
            Log    ${text}
            FOR    ${question}    IN    @{data_questions['Auto']}
                ${locator}    Catenate    SEPARATOR=    ${Questions}"    ${question}"])[1]
                Scroll To Element    ${locator}
                Wait For Elements State    ${locator}    visible    timeout=30s
                Click    ${locator}
                ${rationable}    Run Keyword And Return Status    Get Element States    ${Answer_Rationable}    validate    value & visible    'Answer_Rationable should be visible.'
                ${ai_answer_status}    Run Keyword And Return Status    Get Element States    ${AI_Answer}    validate    value & visible    'AI_Answer should be visible.'
                Should Be True    ${rationable} or ${ai_answer_status}
                Click    ${Answer_Popup}
            END
        ELSE IF    "${text}" == "Crime"
            Log    ${text}
            FOR    ${question}    IN    @{data_questions['Crime']}
                ${locator}    Catenate    SEPARATOR=    ${Questions}"    ${question}"])[1]
                Scroll To Element    ${locator}
                Wait For Elements State    ${locator}    visible    timeout=30s
                Click    ${locator}
                ${rationable}    Run Keyword And Return Status    Get Element States    ${Answer_Rationable}    validate    value & visible    'Answer_Rationable should be visible.'
                ${ai_answer_status}    Run Keyword And Return Status    Get Element States    ${AI_Answer}    validate    value & visible    'AI_Answer should be visible.'
                Should Be True    ${rationable} or ${ai_answer_status}
                Click    ${Answer_Popup}
            END
        ELSE IF    "${text}" == "General"
            Log    ${text}
            FOR    ${question}    IN    @{data_questions['General']}
                ${locator}    Catenate    SEPARATOR=    ${Questions}"    ${question}"])[1]
                Scroll To Element    ${locator}
                Wait For Elements State    ${locator}    visible    timeout=30s
                Click    ${locator}
                ${rationable}    Run Keyword And Return Status    Get Element States    ${Answer_Rationable}    validate    value & visible    'Answer_Rationable should be visible.'
                ${ai_answer_status}    Run Keyword And Return Status    Get Element States    ${AI_Answer}    validate    value & visible    'AI_Answer should be visible.'
                Should Be True    ${rationable} or ${ai_answer_status}
                Click    ${Answer_Popup}
            END
        ELSE IF    "${text}" == "General Liability"
            Log    ${text}
            FOR    ${question}    IN    @{data_questions['General Liability']}
                ${locator}    Catenate    SEPARATOR=    ${Questions}"    ${question}"])[1]
                Scroll To Element    ${locator}
                Wait For Elements State    ${locator}    visible    timeout=30s
                Click    ${locator}
                ${rationable}    Run Keyword And Return Status    Get Element States    ${Answer_Rationable}    validate    value & visible    'Answer_Rationable should be visible.'
                ${ai_answer_status}    Run Keyword And Return Status    Get Element States    ${AI_Answer}    validate    value & visible    'AI_Answer should be visible.'
                Should Be True    ${rationable} or ${ai_answer_status}
                Click    ${Answer_Popup}
            END
        ELSE IF    "${text}" == "Manufacturing"
            Log    ${text}
            FOR    ${question}    IN    @{data_questions['Manufacturing']}
                ${locator}    Catenate    SEPARATOR=    ${Questions}"    ${question}"])[1]
                Scroll To Element    ${locator}
                Wait For Elements State    ${locator}    visible    timeout=30s
                Click    ${locator}
                ${rationable}    Run Keyword And Return Status    Get Element States    ${Answer_Rationable}    validate    value & visible    'Answer_Rationable should be visible.'
                ${ai_answer_status}    Run Keyword And Return Status    Get Element States    ${AI_Answer}    validate    value & visible    'AI_Answer should be visible.'
                Should Be True    ${rationable} or ${ai_answer_status}
                Click    ${Answer_Popup}
            END
        ELSE IF    "${text}" == "Property Risk"
            Log    ${text}
            FOR    ${question}    IN    @{data_questions['Property Risk']}
                ${locator}    Catenate    SEPARATOR=    ${Questions}"    ${question}"])[1]
                Scroll To Element    ${locator}
                Wait For Elements State    ${locator}    visible    timeout=30s
                Click    ${locator}
                ${rationable}    Run Keyword And Return Status    Get Element States    ${Answer_Rationable}    validate    value & visible    'Answer_Rationable should be visible.'
                ${ai_answer_status}    Run Keyword And Return Status    Get Element States    ${AI_Answer}    validate    value & visible    'AI_Answer should be visible.'
                Should Be True    ${rationable} or ${ai_answer_status}
                Click    ${Answer_Popup}
            END
        ELSE IF    "${text}" == "Umbrella"
            Log    ${text}
            FOR    ${question}    IN    @{data_questions['Umbrella']}
                ${locator}    Catenate    SEPARATOR=    ${Questions}"    ${question}"])[1]
                Scroll To Element    ${locator}
                Wait For Elements State    ${locator}    visible    timeout=30s
                Click    ${locator}
                ${rationable}    Run Keyword And Return Status    Get Element States    ${Answer_Rationable}    validate    value & visible    'Answer_Rationable should be visible.'
                ${ai_answer_status}    Run Keyword And Return Status    Get Element States    ${AI_Answer}    validate    value & visible    'AI_Answer should be visible.'
                Should Be True    ${rationable} or ${ai_answer_status}
                Click    ${Answer_Popup}
            END
        ELSE IF    "${text}" == "Workers' Comp"
            Log    ${text}
            FOR    ${question}    IN    @{data_questions['Workers Comp']}
                ${locator}    Catenate    SEPARATOR=    ${Questions}"    ${question}"])[1]
                Scroll To Element    ${locator}
                Wait For Elements State    ${locator}    visible    timeout=30s
                Click    ${locator}
                ${rationable}    Run Keyword And Return Status    Get Element States    ${Answer_Rationable}    validate    value & visible    'Answer_Rationable should be visible.'
                ${ai_answer_status}    Run Keyword And Return Status    Get Element States    ${AI_Answer}    validate    value & visible    'AI_Answer should be visible.'
                Should Be True    ${rationable} or ${ai_answer_status}
                Click    ${Answer_Popup}
            END
        END
    END

Verify Company Website Link
    [Documentation]    Verifies that the company website link in the Answers section opens a new page with the correct title.
    ...
    ...    *Arguments:*
    ...    - `${expected_Title}`: The expected title of the page that opens after clicking the link.
    [Arguments]    ${expected_Title}
    ${status}    Run Keyword And Return Status    Get Element States    ${Website_Link}    validate    value & visible    'Website_Link should be visible.'
    IF    ${status} == True
        Click    ${Website_Link}
        Switch Page    NEW
        Wait For Load State    load
        ${page_title}    Get Title
        Should Be Equal    ${page_title}    ${expected_Title}
        Close Page
        Switch Page    CURRENT
        Wait For Elements State    ${Answers}    visible    timeout=30s
    END
    # Scroll To Element    ${Website_Link}
    # Wait For Elements State    ${Website_Link}    visible    
    # Click    ${Website_Link}
    # Switch Page    NEW
    # Wait For Load State    load
    # ${page_title}    Get Title
    # Should Be Equal    ${page_title}    ${expected_Title}
    # Close Page
    # Switch Page    CURRENT
    # Wait For Elements State    ${Answers}    visible    