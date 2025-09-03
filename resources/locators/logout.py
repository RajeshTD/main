"""
This file contains the locators for the 'Logout' functionality of the application.
Locators are used by the Robot Framework tests to interact with elements on the web page.
"""
UserIcon = "xpath=//button[@data-cy='user-menu-username']"
UserMenu = "xpath=//div[@ng-show='vm.userMenuOpen']"
Logout = "xpath=//span[text()='Log Out']"