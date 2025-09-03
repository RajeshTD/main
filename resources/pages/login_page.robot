*** Settings ***
Resource   ../../utils/common_keywords.robot
Variables  ../locators/login_locators.py

*** Keywords ***
Login with username and password
    [Documentation]    Performs the login action using a username and password.
    ...    It handles the multi-step login process of entering the email, clicking next, and then entering the password.
    ...
    ...    *Arguments:*
    ...    - `${data_userName}`: The username (email) to log in with.
    ...    - `${data_password}`: The password for the account.
    [Arguments]    ${data_userName}    ${data_password}
    Wait For Elements State    ${Email}    visible
    Type Text    ${Email}    ${data_userName}
    Wait For Elements State    ${NextButton}    enabled
    Click    ${NextButton}
    Wait For Elements State    ${LoginUser}    visible
    Fill Text    ${LoginUser}    ${data_userName}
    Wait For Elements State    ${LoginPassword}    visible
    Fill Text    ${LoginPassword}    ${data_password}
    Wait For Elements State    ${LoginButton}    enabled
    Click    ${LoginButton}

Verify Home Page is Displayed
    [Documentation]    Verifies that the user has successfully logged in by checking for an element on the home page.
    Wait For Elements State    ${MyAccount}    visible
