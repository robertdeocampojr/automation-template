*** Settings ***
Library     JSpringBotGlobal
Library     String
Library     Collections
Library     OperatingSystem


######################################################################
#             Jira Related Keywords (HTTP Post and Request)          #
######################################################################
*** Keywords ***
Post Setup Jira Report     [Arguments]   ${testCaseName}
    [Documentation]
    Log     ${testName}
    Run Keyword If Test Passed    Check Post Setup Jira Report   ${testCaseName}      1
    Run Keyword If Test Failed    Check Post Setup Jira Report   ${testCaseName}      2

Get Jira Project Id
    [Documentation]     get the project id of the given automation project for execution
    ${jiraUrl} 	    EL Evaluate     $[config:jira.server.url]
    ${pathUrl} 	    EL Evaluate     $[config:zapi.path.get.project.list]

    Create HTTP Get Request         ${jiraUrl}${pathUrl}
    Set HTTP Basic Authentication   $[config:jira.server.username]            $[config:jira.server.password]
    Add HTTP Request Header         $[config:zapi.request.header.name]      $[config:zapi.request.header.value.json]
    Invoke HTTP Request
    HTTP Response Status Code Should Be Equal To	$[config:zapi.response.status.code.success]
    HTTP Response Should Be JSON

    El add variable   PROJECT_NAME  $[config:jira.server.project.name]
    ${projectId} 	Get JSON Value  $[config:json.xpath.jira.project.id]
    [return]        ${projectId}

Get Jira Version Id     [Arguments]   ${projectId}
    [Documentation]     get the project's version id based on the passed version name
    El add variable   PROJECT_ID    ${projectId}
    ${jiraUrl} 	        EL Evaluate     $[config:jira.server.url]
    ${pathUrl} 	        EL Evaluate     $[config:zapi.path.get.version.list]
    ${versionname} 	    EL Evaluate     $[config:jira.server.version.name]
    ${versionname} 	    Remove String   ${versionname}  '

    Create HTTP Get Request         ${jiraUrl}${pathUrl}
    Set HTTP Basic Authentication   $[config:jira.server.username]            $[config:jira.server.password]
    Add HTTP Request Header         $[config:zapi.request.header.name]      $[config:zapi.request.header.value.json]
    Invoke HTTP Request
    HTTP Response Status Code Should Be Equal To	$[config:zapi.response.status.code.success]
    HTTP Response Should Be JSON

    El add variable   VERSION_NAME  ${versionname}
    ${versionId} 	Get JSON Value  $[config:json.xpath.jira.version.id]
    [return]        ${versionId}

Get Jira Cycle Id     [Arguments]   ${projectId}      ${versionId}
    [Documentation]     get the cycle id based on the retrieved project and version id
    El add variable   PROJECT_ID    ${projectId}
    El add variable   VERSION_ID    ${versionId}
    ${jiraUrl} 	    EL Evaluate     $[config:jira.server.url]
    ${pathUrl} 	    EL Evaluate     $[config:zapi.path.get.cycle.list]

    Create HTTP Get Request         ${jiraUrl}${pathUrl}
    Set HTTP Basic Authentication   $[config:jira.server.username]            $[config:jira.server.password]
    Add HTTP Request Header         $[config:zapi.request.header.name]      $[config:zapi.request.header.value.json]
    Invoke HTTP Request
    HTTP Response Status Code Should Be Equal To	$[config:zapi.response.status.code.success]
    HTTP Response Should Be JSON

    El add variable   CYCLE_NAME            $[config:jira.server.cycle.name]
    ${cycleName}    Evaluate Data           $[config:jira.server.cycle.name]
    ${result}	    Get JSON Values	        $
    ${result}       Convert To String       ${result}
    ${matches}      Get Regexp Matches      ${result}       (?<=executionSummary).*?(?=executionSummaries={executionSummary)
    :FOR  ${match}  IN  @{matches}
    \   ${isTrue}   Is String Contains      ${match}        ${cycleName}
    \   Exit For Loop If    ${isTrue}
    ${matches}      Get Regexp Matches      ${match}        (?<=}}, ).*?(?=={totalExecutions)
    ${cycleId}      Get From List           ${matches}      0
    [return]        ${cycleId}

Get Jira Test Case Id     [Arguments]   ${cycleId}      ${testCaseName}
    [Documentation]     get the test case id of the test to be updated
    El add variable   CYCLE_ID      ${cycleId}
    ${jiraUrl} 	    EL Evaluate     $[config:jira.server.url]
    ${pathUrl} 	    EL Evaluate     $[config:zapi.path.get.test.id]

    Create HTTP Get Request         ${jiraUrl}${pathUrl}
    Set HTTP Basic Authentication   $[config:jira.server.username]            $[config:jira.server.password]
    Add HTTP Request Header         $[config:zapi.request.header.name]      $[config:zapi.request.header.value.json]
    Invoke HTTP Request
    HTTP Response Status Code Should Be Equal To	$[config:zapi.response.status.code.success]
    HTTP Response Should Be JSON

    El add variable   TEST_NAME     ${testCaseName}
    ${testId} 	    Get JSON Value  $[config:json.xpath.jira.test.id]
    [return]        ${testId}

Post Test Case Result     [Arguments]   ${testId}      ${result}
    [Documentation]     post the result if passed/failed on jira test case
    El add variable     TEST_ID         ${testId}
    ${jiraUrl} 	        EL Evaluate     $[config:jira.server.url]
    ${pathUrl} 	        EL Evaluate     $[config:zapi.path.post.status]

    ${comment}          Run Keyword If      ${result} == 1  Set Variable    Test Case Passed. [by automated script]     ELSE    Set Variable    ${TEST MESSAGE}
    Start JSON Object
    Add JSON Object String Item	    status	    ${result}
    Add JSON Object String Item	    comment	    ${comment}
    End JSON Object
    ${requestBody}	    Create JSON String

    Create HTTP Put Request         ${jiraUrl}${pathUrl}
    Set HTTP Basic Authentication   $[config:jira.server.username]            $[config:jira.server.password]
    Add HTTP Request Header         $[config:zapi.request.header.name]      $[config:zapi.request.header.value.json]
    Set HTTP Request Body           ${requestBody}
    Invoke HTTP Request
    HTTP Response Status Code Should Be Equal To	$[config:zapi.response.status.code.success]

Check For Project Cycle Id
    [Documentation]     get for project's cycle id - by passed cycle name
    ${projectId}        Get Jira Project Id
    ${versionId}        Get Jira Version Id     ${projectId}
    ${cycleId}          Get Jira Cycle Id       ${projectId}    ${versionId}
    [return]            ${cycleId}

Pre Setup Jira Report
    [Documentation]     check for cycle id is passed or not
    Select Config Domain    http
    ${cycleName}        Evaluate Data       $[config:jira.server.version.name]
    ${cycleName} 	    Remove String       ${cycleName}        '
    ${isEmpty}          EL Evaluate         $[empty '${cycleName}']
    ${CYCLE_ID}         Run Keyword If      ${isEmpty}     SetVariable    ${EMPTY}   ELSE     Check For Project Cycle Id
    Set Global Variable      ${CYCLE_ID}        ${CYCLE_ID}

Update Test Case Status     [Arguments]   ${testCaseName}       ${result}
    [Documentation]
    ${testId}               Get Jira Test Case Id   ${CYCLE_ID}      ${testCaseName}
    Post Test Case Result   ${testId}               ${result}
    Run Keyword If          ${result} == 2          Attach Screenshot to Test Case    ${testId}

Check Post Setup Jira Report     [Arguments]   ${testCaseName}       ${result}
    [Documentation]     update test case status if necessary
    Select Config Domain    http

    Pre Setup Jira Report
    ${isEmpty}          EL Evaluate         $[empty '${CYCLE_ID}']
    Run Keyword If      ${isEmpty}          Log         Cycle Not Defined. Skipped Jira Reporting!      ELSE     Update Test Case Status    ${testCaseName}     ${result}

Attach Screenshot to Test Case     [Arguments]   ${testId}
    El add variable   ENTITY_ID      ${testId}

    ${username} =   EL Evaluate     $[config:jira.server.username]
    ${password} =   EL Evaluate     $[config:jira.server.password]
    ${jiraUrl} =	EL Evaluate     $[config:jira.server.url]
    ${apiUrl} =	    EL Evaluate     $[config:zapi.path.attach.file]

    ${SCREENSHOT_LOCATION}      Capture Screenshot
    Set Global Variable         ${SCREENSHOT_LOCATION}        ${SCREENSHOT_LOCATION}

    El add variable   USERNAME  ${username}
    El add variable   PASSWORD  ${password}
    El add variable   SCREENSHOT_LOCATION  ${SCREENSHOT_LOCATION}
    El add variable   JIRASERVER    ${jiraUrl}
    El add variable   JIRA_API  ${apiUrl}

    ${requestBody} =   EL Evaluate     $[config:zapi.curl.attach.file]
    Run   ${requestBody}