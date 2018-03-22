*** Settings ***
Library     JSpringBotGlobal
Library     String
Library     Collections

Resource    ../selenium-resources.robot
Resource    ../form-resources.robot



*** Test Cases ***
Test Case - Demo 1
    [Tags]  testdemo
    [Documentation]  test invalid user credentials
    Select Config Domain    web

    # parse CSV file
    Parse CSV Resource          $[config:test.data]
    Set First CSV Row As Headers
    # get csv test data and store to variable
    Create CSV Criteria
    Add Column Name Equals CSV Restriction  Tag     valid
    ${result}=  First CSV Result
    El add variable   input   ${result}

    # open webpage
    Navigate To         $[config:url.facebook]
    Maximize Window

    # input username and password
    Type to Input Field     $[config:facebook.email.field]      $[csv:value(input,'USERNAME')]
    Type to Input Field     $[config:facebook.password.field]   $[csv:value(input,'PASSWORD')]
    Click Element           $[config:facebook.login.button]

    #validate invalid login
    Page Should Contain     The password you’ve entered is incorrect.













Test Case - Demo 2
    [Tags]  testdemo2
    [Documentation]     testing web.properties
    Select Config Domain    web

    Open Frontend Url       $[config:url.ddi]
    Type to Input Field     $[config:first.name.id]    robert


Test Case - Demo 3
    [Tags]  testdemo3
    [Documentation]     testing test data
    Select Config Domain    web

    # parse CSV
    Parse CSV Resource          $[config:test.data]
    Set First CSV Row As Headers

    Create CSV Criteria
    Add Column Name Equals CSV Restriction  Tag     valid
    ${result}=  First CSV Result
    El add variable   input   ${result}


    Open Frontend Url       $[config:url.ddi]
    Type to Input Field     $[config:facebook.email.field]      $[csv:value(input,'FIRSTNAME')]
    Type to Input Field     $[config:facebook.password.field]   $[csv:value(input,'FIRSTNAME')]
    Click Element           $[config:facebook.login.button]






#tutorial video
# jSpringbot Library:        http://jspringbot.org/getting-started.html
# Locating HTML Identifier: https://www.youtube.com/watch?v=YTAdgfzBEQc
# Formulating Xpaths:       https://www.youtube.com/watch?v=As72m9qrAQ8






