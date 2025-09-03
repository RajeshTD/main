*** Settings ***
Library    Collections
Library    String
Variables    ../locators/users_locators.py
Resource    ../../utils/common_keywords.robot

*** Keywords ***

Search Client name
    [Documentation]    Searches for a user by their name in the user management page.
    ...
    ...    *Arguments:*
    ...    - `${data_clientName}`: The name of the client/user to search for.
    [Arguments]    ${data_clientName}
    Wait For Elements State    ${ClientSearch}    visible
    Fill Text    ${ClientSearch}    ${data_clientName}

Get values from table header
    [Documentation]    Retrieves the text from the header columns of the users table.
    ...
    ...    *Returns:*
    ...    - A list of the header texts.
    @{headers}    Get Elements    ${TableHeader}
    @{actualHeaderValues}=   Create List
    FOR    ${header}    IN    @{headers}
        ${value}=    Get Text    ${header}
        Log    ${value}
        ${trimValue}=    Strip String    ${value}
        Log    ${trimValue}
        Append To List    ${actualHeaderValues}    ${trimValue}
    END
    RETURN    ${actualHeaderValues}

Get user data from the table
    [Documentation]    Retrieves all data for a specific user from the users table.
    ...    It finds the row corresponding to the user's name and extracts the text from each cell.
    ...
    ...    *Arguments:*
    ...    - `${data_searchUserName}`: The name of the user whose data is to be retrieved.
    ...
    ...    *Returns:*
    ...    - A list of strings containing the user's details from the table.
    [Arguments]    ${data_searchUserName}
    ${userNameToSearch}=    Catenate    SEPARATOR=    ${ClientData}    '    ${data_searchUserName}    ']//ancestor::tr/td
    @{tableData}=    Browser.Get Elements        ${userNameToSearch}
    ${length}=    Get Length    ${tableData}
    @{actualUserDetails}=    Create List
    FOR    ${i}    IN RANGE    0    ${length}
        ${data}=    Get Text    ${tableData}[${i}]
        ${hasNewLine}=    Run Keyword And Return Status    Should Contain    ${data}    \n
        IF    ${hasNewLine}
            @{splitValue}=    Split String    ${data}    \n
            ${split}=    Strip String    ${splitValue}[1]
            Append To List    ${actualUserDetails}    ${split}
        ELSE
            ${trimData}=    Strip String    ${data}
            Append To List    ${actualUserDetails}    ${trimData}
        END
    END
    RETURN    ${actualUserDetails}

Select Impersonate option from the actions
    [Documentation]    Finds a user and selects the 'Impersonate' option from their actions menu.
    ...
    ...    *Arguments:*
    ...    - `${data_UserEmail}`: The email of the user to impersonate, used to locate the correct action icon.
    ...    - `${client_name}`: The name of the client/user to search for first.
    [Arguments]    ${data_UserEmail}    ${client_name}
    Search Client name    ${client_name}
    ${ActionIcon}=    Catenate    SEPARATOR=    ${ActionsIcon}    ${data_UserEmail}    ']
    Wait For Elements State    ${ActionIcon}    enabled
    Click    ${ActionIcon}
    ${ImpersonateOption}=    Catenate    SEPARATOR=    ${Impersonate}    ${data_UserEmail}    ']
    Wait For Elements State    ${ImpersonateOption}    visible
    Click    ${ImpersonateOption}

Verify User is already exists
    [Documentation]    Checks if a user already exists in the users list.
    ...
    ...    *Arguments:*
    ...    - `${data_userName}`: The name of the user to verify.
    ...
    ...    *Returns:*
    ...    - `True` if the user exists, `False` otherwise.
    [Arguments]    ${data_userName}
    Search Client name    ${data_userName}
    ${userNameToSearch}=    Catenate    SEPARATOR=    ${ClientData}    '    ${data_userName}    ']
    ${user}=    Run Keyword And Return Status    Wait For Elements State    ${userNameToSearch}    visible    timeout=30s
    RETURN    ${user}

Create User If the User is not present
    [Documentation]    Creates a new user if they do not already exist.
    ...    It first calls `Verify User is already exists`. If the user is not found, it proceeds to fill out and submit the 'New User' form.
    ...
    ...    *Arguments:*
    ...    - `${user_data}`: A dictionary containing the new user's details (e.g., email, firstName, lastName, clientName, clientRole).
    [Arguments]    ${user_data}
    ${userIsPresent}=    Verify User is already exists    ${user_data['search_user']}
    IF    ${userIsPresent}
        Log Step    '${user_data["search_user"]} already exists, skipping user creation.'
    ELSE
        Wait For Elements State    ${NewUserButton}    visible
        Wait For Elements State    ${NewUserButton}    enabled
        Click    ${NewUserButton}
        Wait For Elements State    ${NewUserForm}    visible
        Fill Text    ${FormEmail}    ${user_data['email']}
        Fill Text    ${FirstName}    ${user_data['firstName']}
        Fill Text    ${LastName}    ${user_data['lastName']}
        Select Options By    ${ClientDropdown}    label    ${user_data['clientName']}
        Select Options By    ${RoleDropdown}    label    ${user_data['clientRole']}
        ${selected_client}=    Get Text    select#client >> option:checked
        ${selected_role}=     Get Text    select#role >> option:checked
        Should Be Equal    ${selected_client}    ${user_data['clientName']}
        Should Be Equal    ${selected_role}    ${user_data['clientRole']}
        Sleep    2s
        Scroll To Element    ${AddUserButton}
        Wait For Elements State    ${AddUserButton}    enabled
        Click    ${AddUserButton}
    END
