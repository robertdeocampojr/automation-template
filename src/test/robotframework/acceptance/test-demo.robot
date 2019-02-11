*** Settings ***
Resource    ../selenium-resources.robot
Resource    ../util-resources.robot
Resource    ../form-resources.robot

Suite Setup     Set Config And Test Data        web     $[config:test.data.demo]
Test Teardown   Test Tear Down


*** Test Cases ***
Test Case - Demo1
    [Tags]  fordemo
    [Documentation]  test valid user credentials

    #select properties and test data to use
    Get First Data From CSV         input   valid

    # open webpage
    Navigate To         $[config:url.test.demo]
    Maximize Window

    # input username and password
    Type to Input Field     name=firstname          Robert
    Type to Input Field     name=lastname           de Ocampo
    Click Element           id=sex-0

    Sleep       2s
    #validate valid login
    #Verify Element Should Be Visible        $[config:demo.home.message]

Test Case - Demo2
    [Tags]      fordemo1
    [Documentation]  test different invalid user credentials
    Select Config Domain    web

    #parse CSV file for different invalid user credentials
    Set Test Data Property      $[config:test.data.demo]    invalid
    ${result}                   Get CSV List Result

    # iterate different invalid login
    EL Run Keyword For Each    Login And Verify Website     input       ${result}




*** Keywords ***
Login And Verify Website
    # open webpage
    Navigate To         $[config:url.test.demo]
    Maximize Window

    # input username and password
    Type to Input Field     $[config:demo.username.field]       $[csv:value(input,'USERNAME')]
    Type to Input Field     $[config:demo.password.field]       $[csv:value(input,'PASSWORD')]
    Click Element           $[config:demo.login.button]

    Sleep       1s
    #validate invalid login message
    Verify Text Should Be Present        $[csv:value(input,'MESSAGE')]
    Delete All Cookies

Test Tear Down
    Capture Screenshot
    Delete All Cookies