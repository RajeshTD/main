"""
This file contains the locators for the 'Answers' page of the application.
Locators are used by the Robot Framework tests to interact with elements on the web page.
"""
Answers_Tab = "xpath=(//*[@title='Answers' or text() = 'Answers'])[1]"
Answers = "id=answers"
Answers_List = "xpath=//div[@id='answers']//li//a"
Answer_Rationable = "xpath=//p[text()='Answers rationale coming soon.']"
AI_Answer = "xpath=//p[text()='Convr AI answered this question. Review data lineage, if available, to identify data source(s).']"
Questions = "xpath=(//div[normalize-space()="
Answer_Popup = "xpath=//div[text()='Answer Rationale']"
Website_Link = "xpath=//a[normalize-space()='Website']"