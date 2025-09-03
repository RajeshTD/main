"""
This file contains the locators for the 'Documents' page of the application.
Locators are used by the Robot Framework tests to interact with elements on the web page.
"""
BrowseFileInDocuments= "xpath=//input[@type='file']"
UploadButton= "xpath=//button[normalize-space()='Upload']"
Claims = "xpath=//a[normalize-space()='Claims']"
DownloadDropdown = "xpath=//button[normalize-space()='Download']"
DownloadData = "xpath=//a[normalize-space()='Download Data']"
Policies = "xpath=//a[normalize-space()='Policies']"
Analysis = "xpath=//a[normalize-space()='Analysis']"
CardDatas1 = "xpath=//dt[text()='"
CardDatas2 = "']//following-sibling::dd"
AnalysisTableData = "xpath=//td//span"
DownloadSchema = "xpath=//ng-transclude[normalize-space()='Download Schema']"
ArchiveButton1 = "xpath=//div[text()='"
ArchiveButton2 = "']/..//button"


# new
Email_Body_Doc="xpath=//a[@data-cy='asset-card-file-EMAIL BODY' or @data-cy='asset-card-file-Great Western Lumber - effective.eml']"
Email_Body_msg="xpath=//div[@ng-bind-html='$ctrl.body']"
underwriter_reference_Doc="xpath=//a[@data-cy='asset-card-file-Underwriter Reference Lookup']"
Acord_125_loc="xpath=//a[@data-cy='asset-card-file-ACORD 125 (2013/01)']"
Acord_140_loc="xpath=//a[@data-cy='asset-card-file-ACORD 140 (2007/09)']"
Broker_form_loc="xpath=//a[@data-cy='asset-card-file-Broker Form']"
Loss_run_EASTERNALLIANCE="xpath=//a[@data-cy='asset-card-file-Loss Run (EASTERNALLIANCE)']"