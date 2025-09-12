*** Settings ***
Library    Browser        timeout=60s
Library    String
Library    OperatingSystem

*** Variables ***
${ENV_URL}    %{ENV_URL=https://staging.convr.io/}
${url}    ${ENV_URL}
${BROWSER}    chromium
${HEADLESS}    False
${Video_Dir}    ../results/videos

*** Keywords ***
Open Browser and Launch URL
    [Documentation]    Opens a new browser instance and navigates to the specified URL.
    ...    Arguments:
    ...        - url (optional): The URL to open. Defaults to ${url}.
    ...        - browser (optional): The browser to use. Defaults to ${BROWSER}.
    ...        - headless (optional): Whether to run in headless mode. Defaults to ${HEADLESS}.
    ...    Example:
    ...        Open Browser and Launch URL    url=https://example.com    browser=firefox    headless=False
    [Arguments]    ${url}=${url}    ${browser}=${BROWSER}    ${headless}=${HEADLESS}
    New Browser    ${browser}    headless=${headless}
    New Context    # Optionally, set viewport or other context options here
    Set Browser Timeout    120s
    New Page    ${url}    wait_until=load    
    



    
