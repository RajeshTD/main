"""
This file contains the locators for the 'Risk360' page of the application.
Locators are used by the Robot Framework tests to interact with elements on the web page.
"""
Side_Bar_Risk360_Button = "xpath=//a[@test-id='risk360nav']"
Risk360_Cards = "xpath=//div[@test-id='ui-card-"
Risk360_Empty_Cards = "xpath=//button//ng-transclude[text()='Empty Cards']"
Risk360_Cards_Pages_Header = "xpath=//*[@test-id='ui-card-template-back-title' and contains(normalize-space(.),'"
Risk360_Cards_Pages_Close_Button = "xpath=//button//ng-transclude[text()='Close']"