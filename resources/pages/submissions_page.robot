*** Settings ***
Resource   ../../utils/common_keywords.robot
Variables  ../locators/submissions.py
Variables  ../locators/all_submissions.py

*** Keywords ***

Verify Submissions and Tasks are displayed
    [Documentation]    Verifies that the main 'Submissions' and 'Tasks' menu items are visible on the side navigation panel.
    ...
    ...    *Arguments:*
    ...    - `@{data_menu}`: A list of menu item names to verify.
    [Arguments]    @{data_menu}
    Wait For Elements State    ${Search_Submission_Button}    visible
    FOR    ${menuName}    IN    @{data_menu}
        ${menu}    Catenate    SEPARATOR=        ${SideMenu}    '    ${menuName}    ']
        Wait For Elements State    ${menu}    visible
    END
Select Date Filter option
    [Documentation]    Selects a specific option from the date filter dropdown on the submissions page.
    ...    It first checks if the desired option is already selected.
    ...
    ...    *Arguments:*
    ...    - `${Date_Options_Value}`: The text of the date filter option to select (e.g., 'Today', 'Last 7 days').
    [Arguments]    ${Date_Options_Value}
    Wait For Elements State    ${Date_Filter_Options_Button}    visible
    ${Date_Option_text}    Get Text    ${Date_Filter_Options_Button}
    IF    '${Date_Option_text}' == '${Date_Options_Value}'
        Log    Submission Alredy in ${Date_Option_text} option
    ELSE
        Wait For Elements State    ${Date_Filter_Options_Button}    visible    5s
        Click    ${Date_Filter_Options_Button}
        ${date_options_locator}    Catenate    SEPARATOR=        ${Date_Options}    ${Date_Options_Value}    ']
        Wait For Elements State    ${date_options_locator}    visible
        Click    ${date_options_locator}
    END
Click All submissions option
    [Documentation]    Ensures that the 'All submissions' filter is selected on the submissions page.
    ...    If it's not already selected, it will open the dropdown and click it.
    Wait For Elements State    ${Submission_Filter_Options_Button}    visible
    ${submission_text}    Get Text    ${Submission_Filter_Options_Button}
    ${Submission_Options_Value}    Set Variable    Created by me
    IF    '${submission_text}' == '${Submission_Options_Value}'
        Log    Submission Alredy in All submissions option
    ELSE
        Sleep    3s
        Click    ${Submission_Filter_Options_Button}
        ${submission_options_text}    Catenate    SEPARATOR=        ${Submission_Options}    ${Submission_Options_Value}    ']
        Wait For Elements State    ${submission_options_text}    visible
        Click    ${submission_options_text}
    END

Click submissions option
    [Documentation]    Selects a specific option from the submission filter dropdown (e.g., 'All submissions', 'Assigned to me').
    ...    It first checks if the desired option is already selected.
    ...
    ...    *Arguments:*
    ...    - `${Submission_Options_Value}`: The text of the submission filter option to select.
    [Arguments]    ${Submission_Options_Value}
    Wait For Elements State    ${Submission_Filter_Options_Button}    visible
    ${submission_text}    Get Text    ${Submission_Filter_Options_Button}
    IF    '${submission_text}' == '${Submission_Options_Value}'
        Log    Submission Alredy in ${Submission_Options_Value} option
    ELSE
        Click    ${Submission_Filter_Options_Button}
        ${submission_options_text}    Catenate    SEPARATOR=        ${Submission_Options}    ${Submission_Options_Value}    ']
        Wait For Elements State    ${submission_options_text}    visible
        Click    ${submission_options_text}
      
    END

Rearrange Submission Page Columns
    [Documentation]    Configures the visible columns on the main submissions table.
    ...    It first de-selects all columns and then selects only the ones specified.
    ...
    ...    *Arguments:*
    ...    - `@{ColumnNames}`: A list of column header names to be displayed.
    [Arguments]    @{ColumnNames}
    Wait For Elements State    ${Submissions_Page_Columns_Button}
    Click    ${Submissions_Page_Columns_Button}
    Wait For Elements State    ${Submission_Columns_Select_All_Checkbox}
    Check Checkbox    ${Submission_Columns_Select_All_Checkbox}
    Uncheck Checkbox    ${Submission_Columns_Select_All_Checkbox}
    FOR    ${column_name}    IN    @{ColumnNames}
        ${Column_Locator}    Catenate    SEPARATOR=        ${Submission_Columns_Status_CheckBox}    ${column_name}    ${Submission_Columns_Status_CheckBox_1}
        Scroll To Element    ${Column_Locator}
        Wait For Elements State    ${Column_Locator}    visible
        Check Checkbox    ${Column_Locator}
    END
    Wait For Elements State    ${Submissions_Page_Columns_Button}
    Click    ${Submissions_Page_Columns_Button}

Click My submissions option
    [Documentation]    Selects the 'Assigned to me' filter from the submission filter dropdown.
    ${Submission_Options_Value}    Set Variable    Assigned to me
    Wait For Elements State    ${Submission_Filter_Options_Button}    visible
    Click    ${Submission_Filter_Options_Button}
    ${submission_options_text}    Catenate    SEPARATOR=        ${Submission_Options}    ${Submission_Options_Value}    ']
    Wait For Elements State    ${submission_options_text}    visible
    Click    ${submission_options_text}


Click All tasks option
    [Documentation]    Ensures that the 'All submissions' filter is selected on the submissions page.
    ...    If it's not already selected, it will open the dropdown and click it.
    Wait For Elements State    ${Submission_Filter_Options_Button}    visible    5s
    ${submission_text}    Get Text    ${Submission_Filter_Options_Button}
    ${Submission_Options_Value}    Set Variable    All tasks    
    IF    '${submission_text}' == '${Submission_Options_Value}'
        Log    All tasks
    ELSE
        Sleep    3s
        Wait For Elements State    ${Submission_Filter_Options_Button}    visible    5s
        Click    ${Submission_Filter_Options_Button}
        ${submission_options_text}    Catenate    SEPARATOR=        ${Submission_Options}    ${Submission_Options_Value}    ']
         Wait For Elements State    ${submission_options_text}    visible    5s
         Click    ${submission_options_text}
    END       