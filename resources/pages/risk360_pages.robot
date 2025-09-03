*** Settings ***
Resource     ../../utils/common_keywords.robot
Variables     ../locators/risk360_locators.py

*** Keywords ***
Verify Risk360 Card Pages Navigation
    [Documentation]    Verifies that clicking on each card on the Risk360 page navigates to the correct corresponding page.
    ...
    ...    *Arguments:*
    ...    - `@{card_names_List}`: A list of card names (the text visible on the card) to be clicked.
    ...    - `@{card_pages_List}`: A list of expected page header texts, corresponding to each card.
    [Arguments]    ${card_names_List}    ${card_pages_List}
    Handle Future Dialogs    action=accept    
    Click   ${Side_Bar_Risk360_Button}
    Click   ${Risk360_Empty_Cards}
    ${card_names}=    Set Variable    @{card_names_List}
    ${card_pages}=    Set Variable    @{card_pages_List}
    ${length}=    Get Length    ${card_names}
    FOR    ${index}    IN RANGE    0    ${length}
        ${card}=    Get From List    ${card_names}    ${index}
        ${CardLocator}=    Catenate    SEPARATOR=    ${Risk360_Cards}    ${card}']
        Scroll To Element    ${CardLocator}
        Click    ${CardLocator}
        ${cardPageHeader}=    Get From List    ${card_pages}    ${index}
        ${PageHeader}=    Catenate    SEPARATOR=    ${Risk360_Cards_Pages_Header}    ${cardPageHeader}')]
        Get Element States    ${PageHeader}    validate    value & visible    'PageHeader should be visible.'
        Click    ${Risk360_Cards_Pages_Close_Button}
    END    

