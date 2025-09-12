*** Settings ***
Library    Collections
Library    String
Library    BuiltIn
Variables    ../../testdata/data.py
Library    ../../libraries/helper.py
Resource    ../../utils/common_keywords.robot
Variables    ../locators/tasks_locators.py
Variables    ../locators/submissions.py

*** Keywords ***

Click Tasks
    [Documentation]    Navigates to the 'Tasks' page from the main menu.
    Wait For Elements State    ${Tasks}    visible
    Click    ${Tasks}
    Wait For Elements State    ${SearchTask}    visible

Get values from Tasks table header
    [Documentation]    Retrieves the text from the header columns of the tasks table.
    ...
    ...    *Returns:*
    ...    - A list of the header texts.
    @{headers}    Get Elements    ${TableHeader}
    @{actualHeaderValues}=   Create List
    FOR    ${header}    IN    @{headers}
        ${value} =    Get Text    ${header}
        Log    ${value}
        ${trimValue} =    Strip String    ${value}
        Log    ${trimValue}
        IF    '${trimValue}'
            Append To List    ${actualHeaderValues}    ${trimValue}
        END
    END
    RETURN    ${actualHeaderValues}

Switch to Tasks if not in Tasks page
    [Documentation]    Checks if the user is currently on the Tasks page. If not, it navigates there.
    ...    This is useful for ensuring the script is in the correct state before performing task-related actions.
    ${visible}    Run Keyword And Return Status    Wait For Elements State    ${SearchTask}    visible    timeout=5s
    IF    ${visible}
        Log Step    "Tasks Page is visible no need to switch"
    ELSE
        Log Step    "Switching to Tasks Page"
        Click    ${Tasks}
    END

Search Task name ID in Tasks
    [Documentation]    Searches for a task by its name in the search bar on the Tasks page.
    ...
    ...    *Arguments:*
    ...    - `${data_task_name}`: The name of the task to search for.
    [Arguments]    ${data_task_name}
    Wait For Elements State    ${SearchTask}    visible
    Fill Text    ${SearchTask}    ${data_task_name}
    Press Keys    ${SearchTask}    Enter

Verify Task is present for the given Task name
    [Documentation]    Verifies if a specific task is present in the tasks list.
    ...
    ...    *Arguments:*
    ...    - `${task_name}`: The name of the task to verify.
    ...    - `${data_task_id}`: The ID of the task to help uniquely identify it.
    ...
    ...    *Returns:*
    ...    - `True` if the task is visible, `False` otherwise.
    [Arguments]    ${task_name}    ${data_task_id}
    Search Task name ID in Tasks    ${task_name}
    ${taskData}    Catenate    SEPARATOR=    ${TaskData1}${task_name}${TaskData2}${data_task_id}']]
    ${task_visible}    Run Keyword And Return Status    Wait For Elements State    ${taskData}    visible    timeout=10s
    RETURN    ${task_visible}

Create New Task if not
    [Documentation]    Creates a new task if a task with the same name doesn't already exist.
    ...    If the task exists, it skips creation. Otherwise, it navigates to the submissions page,
    ...    selects a submission, and fills out the new task form.
    ...
    ...    *Arguments:*
    ...    - `${data}`: A dictionary containing task details like 'NewTaskName', 'TaskNameDropdown', 'assignee', etc.
    ...    - `${data_submission_id}`: The ID of the submission to associate the task with.
    ...
    ...    *Returns:*
    ...    - `True` if a new task was created, `False` otherwise.
    [Arguments]    ${data}    ${data_submission_id}
    ${is_task_present}    Verify Task is present for the given Task name    ${data['NewTaskName']}    ${data['data_task_id']}
    IF    ${is_task_present}
        Log Step    "${data['NewTaskName']} already exists, skipping task creation."
        Set Suite Variable    ${test_new_task_name}    ${data['NewTaskName']}
        RETURN    False
    ELSE
        Wait For Elements State    ${locator_submissions}    visible    timeout=10s
        Click    ${locator_submissions}
        Click    ${AllSubmissions}
        Sleep    8s
        ${submission}    Verify Submission Id is available    ${data_submission_id}
        IF    not ${submission}
            Select Submission using submission id    ${data_submission_id}
            Wait For Elements State    ${SchemaButton}    visible    timeout=10s
            Click    ${TasksMenu}
            ${noTasks_visible}    Run Keyword And Return Status    Wait For Elements State    ${NoTasks}    visible    timeout=10s
            IF    ${noTasks_visible}
                Click    ${CreateNewTaskButton}
            ELSE
                Wait For Elements State    ${NewTaskButton}    visible
                Click    ${NewTaskButton}
            END
            Wait For Elements State    ${CreateTaskTab}    visible
            ${customName}    Run Keyword And Return Status    Should Be Equal    '${data["TaskNameDropdown"]}'    'Custom'
            IF    ${customName}
                Select Options By    ${TaskNameDropdown}    label    Custom
                ${randomNumber}=    Generate Random Number
                ${test_string}    Catenate    SEPARATOR=    ${data['customName']}    ${randomNumber}
                Log Step    'Converted string -> ${test_string}'
                Update Task Name    ${test_string}
                Set Suite Variable    ${test_new_task_name}    ${test_string}
                Fill Text    ${CustomTaskName}    ${data['customName']}${randomNumber}
            ELSE
                Select Options By    ${TaskNameDropdown}    label    ${data['TaskNameDropdown']}
            END
            Click    ${AssignTo}
            ${assignee}    Catenate    SEPARATOR=    ${SelectAssignee}    ${data['assignee']}    ']
            Click    ${assignee}
            ${data_due_date}    Get Tomorrows Date
            Click    ${DueDate}
            Press Keys    ${DueDate}    ${data_due_date}
            Sleep    1s
            Press Keys    ${DueDate}    ArrowRight
            Press Keys    ${DueDate}    ${data['dueTime']}
            Update Data    ${TC_UI_281}    dueDate    ${data_due_date}
            Select Options By    ${PriorityDropdown}    label    ${data['priority']}
            Press Keys    None    PageDown
            Fill Text    ${TaskDetails}    ${data['taskDetails']}
            Fill Text    ${TaskReason}    ${data['taskReason']}
            Check Checkbox    ${TaskRequiredCheckBox}
            Wait For Elements State    ${CreateButton}    enabled
            Click    ${CreateButton}
            Verify Task created popup
            ${test_task_name}    Get Text    ${TaskDetailHeader}
        END
        RETURN    True
    END

Verify Task created popup
    [Documentation]    Verifies that the 'Task Created' confirmation popup is visible.
    Wait For Elements State    ${TaskCreatedPopup}    visible

Navigate To Tasks listing page
    [Documentation]    Navigates to the main tasks listing page from anywhere in the application.
    ...    It clicks the 'Home' button first to ensure a consistent starting point.
    ${visible}    Run Keyword And Return Status    Wait For Elements State    ${Home}    visible    timeout=10s
    IF    ${visible}
        Click    ${Home}
        Sleep    10s
        Wait For Elements State    ${Tasks}    visible
        Click    ${Tasks}
        Wait For Elements State    ${SearchTask}    visible    timeout=10s
    END

Verify newly created task in tasks listing page
    [Documentation]    Searches for a newly created task on the tasks listing page to verify it appears in the table.
    ...
    ...    *Arguments:*
    ...    - `${task_name}`: The name of the task to verify.
    [Arguments]    ${task_name}
    Fill Text    ${SearchTask}    ${task_name}
    Press Keys    ${SearchTask}    Enter
    ${task}    Catenate    SEPARATOR=    ${TaskNameInTable}    ${task_name}']
    Wait For Elements State    ${task}    visible

Get Task ID for the newly created task name
    [Documentation]    Retrieves the Task ID for a given task name from the tasks table.
    ...    It then stores the ID in suite variables for later use.
    ...
    ...    *Arguments:*
    ...    - `${task_name}`: The name of the task whose ID is to be retrieved.
    ...
    ...    *Returns:*
    ...    - The ID of the task.
    [Arguments]    ${task_name}
    ${taskIdLocator}    Catenate    SEPARATOR=    ${TaskIDFromTable1}    ${task_name}    ${TaskIDFromTable2}
    Wait For Elements State    ${taskIdLocator}    visible    timeout=10s
    ${task_id}    Get Text    ${taskIdLocator}
    ${trimValue}    Strip String    ${task_id}
    Log Step    'Task ID -> ${task_id}'
    Set Suite Variable    ${suite_task_id}    ${trimValue}
    Update Data    TC_UI_281    data_task_id    ${trimValue}
    Update Data    NewUser    data_task_id    ${trimValue}
    RETURN    ${suite_task_id}

Get task name
    [Documentation]    Retrieves the name of the newly created task, which is stored in a suite variable.
    ...
    ...    *Returns:*
    ...    - The task name.
    ${trim_value}    Strip String    ${test_new_task_name}
    RETURN    ${trim_value}

Verify Table data in Tasks
    [Documentation]    Verifies that the data in a task's row in the tasks table matches the expected values.
    ...
    ...    *Arguments:*
    ...    - `@{expectedList}`: A list of expected string values to find in the task's row.
    [Arguments]    @{expectedList}
    Search Task Name ID In Tasks    ${test_new_task_name}
    FOR    ${table_data}    IN    @{expectedList}
        ${locator_table_data}    Catenate    SEPARATOR=    ${FinalTableData}    ${table_data}'])[1]
        Wait For Elements State    ${locator_table_data}    visible
    END
    ${locator_task_name}    Catenate    SEPARATOR=    ${FinalTableData}    ${test_new_task_name}'])[1]
    Wait For Elements State    ${locator_task_name}    visible

Create New Task 
    [Documentation]    Creates a new task from within a submission.
    ...    This keyword fills out the 'Create Task' form with the provided data.
    ...
    ...    *Arguments:*
    ...    - `${data}`: A dictionary containing the details for the new task, such as name, assignee, priority, etc.
    [Arguments]    ${data}
            Wait For Elements State    ${TasksMenu}    visible    timeout=10s
            Handle Future Dialogs    action=accept    
            Click    ${TasksMenu}
            ${noTasks_visible}    Run Keyword And Return Status    Wait For Elements State    ${NoTasks}    visible    timeout=10s
            IF    ${noTasks_visible}
                Click    ${CreateNewTaskButton}
            ELSE
                Wait For Elements State    ${NewTaskButton}    visible
                Click    ${NewTaskButton}
            END
            Wait For Elements State    ${CreateTaskTab}    visible
            ${customName}    Run Keyword And Return Status    Should Be Equal    '${data["TaskNameDropdown"]}'    'Custom'
            IF    ${customName}
                Select Options By    ${TaskNameDropdown}    label    Custom
                ${randomNumber}=    Generate Random Number
                ${test_string}    Catenate    SEPARATOR=    ${data['customName']}
                Log Step    'Converted string -> ${test_string}'
                Update Task Name    ${test_string}
                Set Suite Variable    ${test_new_task_name}    ${test_string}
                Fill Text    ${CustomTaskName}    ${data['customName']}
            ELSE
                Select Options By    ${TaskNameDropdown}    label    ${data['TaskNameDropdown']}
            END
            Click    ${AssignTo}
            ${assignee}    Catenate    SEPARATOR=    ${SelectAssignee}    ${data['assignee']}    ']
            Click    ${assignee}
            ${data_due_date}    Get Tomorrows Date YMD
            Wait For Elements State    ${DueDate}    visible    timeout=10s
            ${full_datetime}    Catenate    SEPARATOR=    ${data_due_date}    T    ${data['dueTime']}
            Evaluate JavaScript    ${DueDate}    (el) => { el.value = "${full_datetime}"; el.dispatchEvent(new Event('input', { bubbles: true })); el.dispatchEvent(new Event('change', { bubbles: true })); }
           Select Options By    ${PriorityDropdown}    label    ${data['priority']}
            Click    ${TaskDetails}
            Fill Text    ${TaskDetails}    ${data['taskDetails']}
            # Fill Text    ${TaskReason}    ${data['taskReason']}
            # Check Checkbox    ${TaskRequiredCheckBox}
            Wait For Elements State    ${CreateButton}    enabled
            Click    ${CreateButton}
            Verify Task created popup

Verify the created task details
    [Documentation]    Verifies that all the details of a newly created task are displayed correctly on the task details page.
    ...    It compares the displayed values against a list of expected values.
    ...
    ...    *Arguments:*
    ...    - `${expected_taskDetails}`: A list of expected string values for the task details fields.
    [Arguments]    ${expected_taskDetails}
    ${dueDate}    Get Formatted Tomorrow Date
    Run Keyword Unless    '${dueDate}' in ${expected_taskDetails}    Insert Into List    ${expected_taskDetails}    1    ${dueDate}
    ${CreatedDate}    Get Formatted Current Date
    Run Keyword Unless    '${createdDate}' in ${expected_taskDetails}    Append To List    ${expected_taskDetails}    ${CreatedDate}
    ${actual_taskDetails}    Create List
    FOR    ${taskDetail}    IN    @{SanctionScreeningTaskDetails}
        ${text}    Get Text    ${SanctionScreeningTaskDetails['${taskDetail}']}
         ${hasNewLine}=    Run Keyword And Return Status    Should Contain    ${text}    \n
        IF    ${hasNewLine}
            @{splitValue}=    Split String    ${text}    \n
            ${split}=    Strip String    ${splitValue}[1]
            Append To List    ${actual_taskDetails}    ${split}
        ELSE
            ${trimData}=    Strip String    ${text}
            Append To List    ${actual_taskDetails}    ${trimData}
        END
    END
    Log Step    'Actual task details -> ${actual_taskDetails}'
    Log Step    'Expected task details -> ${expected_taskDetails}'
    ${length}    Get Length    ${expected_taskDetails}
    FOR    ${index}    IN RANGE    0    ${length}
        ${expectedTextValue}=     Set Variable    ${expected_taskDetails[${index}]}
        ${actualTextValue}=    Set Variable    ${actual_taskDetails[${index}]}
        ${condition}=    Evaluate    ${index} == ${length-1} or ${index} == 1
        Run Keyword If    ${condition}    Should Contain    ${actualTextValue}    ${expectedTextValue}    
        ...    ELSE    Should Be Equal    ${expectedTextValue}    ${actualTextValue}
    END
Select Task Card
    [Documentation]    Clicks on a specific task card on a dashboard or overview page.
    ...
    ...    *Arguments:*
    ...    - `${cardName}`: The name of the task card to click.
    [Arguments]    ${cardName}
    ${card}    Catenate    SEPARATOR=    (${TaskCard1}    ${cardName}    ${TaskCard2})[1]  
    Click    ${card}  
    Sleep    2s
    ${taskTitle}    Get Text    ${TaskHeader}
    ${trimText}    Strip String    ${taskTitle}
    Should Be Equal    ${trimText}    ${cardName}

verify Edit Delete and Complete task Buttons are present on the right side of task list
    [Documentation]    verifying Edit,delete and complete task buttons are visible on the right side of task list
    Get Element States    ${Task_edit}    validate    value & visible
    Get Element States    ${Task_delete}    validate    value & visible
    Get Element States    ${Complete_Task}    validate    value & visible
   
Verify Task updated popup
    [Documentation]    Verifies that the 'Task Updated' confirmation popup is visible.
    Wait For Elements State    ${Task_updated_popup}    visible
 
Verify Task deleted popup
    [Documentation]    Verifies that the 'Task Deleted' confirmation popup is visible.
    Wait For Elements State    ${Task_del_popup}    visible
 
click Task delete icon
    [Documentation]    Verifies that the 'Task Created' confirmation popup is visible.
     Wait For Elements State    ${Task_delete}
    Click    ${Task_delete}
    Get Element States    ${Get_delpopup}    validate    value & visible

Verify Edit Icon is Clickable and Functional
    [Documentation]    Verify Edit Icon is Clickable and Functional
    ...    *Arguments:*
    ...    - `${data}`: Priority value to be selected from the priority dropdown (e.g., Low, Medium, High).
    [Arguments]    ${data}
    Wait For Elements State    ${Task_edit}
    Click    ${Task_edit}
    Select Options By    ${PriorityDropdown}    label    ${data}
    Wait For Elements State    ${Save_edited_task}
    Click    ${Save_edited_task}
    Verify Task updated popup
 
Verify Delete Icon is Clickable and Functional
    [Documentation]    verifying Edit,delete and complete task buttons are visible on the right side of task list
    [Arguments]    ${expected_taskdetails}
    Wait For Elements State    ${TasksMenu}    visible    timeout=10s
    Handle Future Dialogs    action=accept    
    Click    ${TasksMenu}
    click Task delete icon
    Wait For Elements State    ${Cancel_del}
    Click    ${Cancel_del}
    verify Edit Delete and Complete task Buttons are present on the right side of task list
    click Task delete icon
    Wait For Elements State    ${Del_Task_button}
    Click    ${Del_Task_button}
    Verify Task deleted popup

Select the Created Task
    [Documentation]    This method is used to selected the Selected TestCases  
    [Arguments]    ${TaskName}
            Wait For Elements State    ${TasksMenu}    visible    timeout=10s
            Handle Future Dialogs    action=accept    
            Click    ${TasksMenu}
            ${created_Task}    Catenate    SEPARATOR=    ${Task_Find_Locator}    ${TaskName['customName']}    ']
             Wait For Elements State    ${created_Task}    visible    5s
            click    ${created_Task}
             ${created_Task_Name}    Catenate    SEPARATOR=    ${Task_Name_Loc}    ${TaskName['customName']}    ']
         
            Wait For Elements State    ${created_Task_Name}    visible    5s

Complete Task with the given reason for Booking stage
    [Documentation]    Completes the open task with a specified reason.
    ...
    ...    *Arguments:*
    ...    - `${data}`: The reason for completing the task (e.g., 'False Positive'). This must match one of the checkbox labels in the completion dialog.
    [Arguments]    ${data}
    Wait For Elements State    ${CompleteTaskButton}    visible
    Click    ${CompleteTaskButton}
    Wait For Elements State    ${TaskCompleteDialog}    visible
    Fill Text    ${Task_reason}    ${data}        
    Click    ${CompleteTaskButtonInDialog}
    Wait For Elements State    ${TaskCompleteDialog}    detached

Verify the task is completed and sanction label is appears as per the reason for booking
    [Documentation]    Verifies that the task shows as completed and that the correct sanction label ('False Positive', 'Sanction Screening Flagged', or 'Sanction Screening Clear') is displayed based on the completion reason.
    ...
    ...    *Arguments:*
    ...    - `${reason}`: The reason the task was completed with, used to determine which label should be visible.
    [Arguments]    ${reason}
    Scroll To Element    ${TaskCompletedMessage}
    Wait For Elements State    ${TaskCompletedMessage}    visible
   
    ${actual_reason}    Get Text    ${Task_completed}
    Should Be Equal    ${actual_reason}    ${reason}