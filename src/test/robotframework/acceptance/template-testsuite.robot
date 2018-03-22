*** Settings ***
Library     JSpringBotGlobal
Library     String
Library     Collections


#Resource    ../selenium-resources.robot
#Resource    ../form-resources.robot


*** Test Cases ***
Testcase4
    [Tags]       homepage    regression      keyword
    [Documentation]     create new keyword
    #get property from web.properties
    Select Config Domain    web

    # parse CSV
    Parse CSV Resource          $[config:test.data]
    Set First CSV Row As Headers

    Create CSV Criteria
    Add Column Name Equals CSV Restriction  Tag     DEMO
    ${result}=  First CSV Result
    El add variable   input   ${result}

    Open Website
    ${value} =  Evaluate Data           $[csv:value(input,'EventName')]
    ${var} =    Get Length              ${value}
    Search by Global        $[csv:value(input,'EventName')]
    Sleep   5s

Testcase5
    [Tags]       homepage    regression      loop
    [Documentation]     how to test a loop
    #get property from web.properties
    Select Config Domain    web

    # parse CSV
    Parse CSV Resource          $[config:test.data]
    Set First CSV Row As Headers

    Create CSV Criteria
    Add Column Name Equals CSV Restriction  Tag     Valid
    @{result} =  Get CSV List Result

    :FOR  ${row}  IN  @{result}
    \   El add variable   input   ${row}
    \   Open Website
    \   Search by Global        $[csv:value(input,'EventName')]
    Sleep   5s

Testcase5
    [Tags]       homepage    regression      foreach
    [Documentation]     how to test a loop
    #get property from web.properties
    Select Config Domain    web

    # parse CSV
    Parse CSV Resource          $[config:test.data]
    Set First CSV Row As Headers

    Create CSV Criteria
    Add Column Name Equals CSV Restriction  Tag     Valid
    ${result} =  Get CSV List Result

    EL Run Keyword For Each     Go and Search by Global     input       ${result}





*** Keywords ***
Open Website
    [Documentation]
    Navigate To         $[config:url.google]
    Maximize Window

Evaluate Data     [Arguments]    ${data}
    [Documentation]     Check the data if its jspringbot or robot variable. Evaluate afterward
    ${dataStartWith}=   Get Substring   ${data}      0  2
    ${data} =    Run Keyword If  '${dataStartWith}' == '\$['     EL Evaluate   ${data}   ELSE     SetVariable    ${data}
    [return]    ${data}