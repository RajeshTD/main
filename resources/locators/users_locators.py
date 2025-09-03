"""
This file contains the locators for the 'Users' page (user management) of the application.
Locators are used by the Robot Framework tests to interact with elements on the web page.
"""
MyAccount = "xpath=//a[text()='My Account']"
ClientSearch = 'id=search-records'
TableHeader = 'xpath=//th'
ClientData = "xpath=//span[normalize-space()="
ActionsIcon="xpath=//button[@test-id='account-users-menu-btn-"
Impersonate= "xpath=//button[@test-id='account-users-impersonate-"
NewUserButton = "xpath=//button//*[text()='New User ']"
NewUserForm = "//form[@name='vm.newUserForm']"
FormEmail = 'id=email'
FirstName = 'id=firstName'
LastName = 'id=lastName'
ClientDropdown = 'id=client'
RoleDropdown = 'id=role'
AddUserButton = "xpath=//button//*[text()='Add user']"

