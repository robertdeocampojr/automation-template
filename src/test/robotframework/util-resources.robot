*** Settings ***
Library     JSpringBotGlobal
Library     String
Library     Collections
Library     OperatingSystem

*** Variables ***
${FIELD_LOCATOR_MAPPING_LOCATION}     classpath:data/FieldMapping.csv

######################################################################
#               Utility and Data Manipulation Keywords               #
######################################################################
*** Keywords ***
Set Config Data    [Arguments]    ${form}
    [Documentation]     Set the config property to use by passing the form to test and using default test data csv
    Select Config Domain    ${form}

Set Config Property   [Arguments]    ${prop}
    [Documentation]     Set the config property only
    Select Config Domain    ${prop}

Set Test Data Property     [Arguments]  ${location}     ${tag}
    [Documentation]     set the csv resource location and its TAG criteria
    Parse CSV Resource      ${location}
    Set First CSV Row As Headers
    Create CSV Criteria
    Add Column Name Equals CSV Restriction  Tag     ${tag}

Get Web Config Property     [Arguments]     ${prop}
    [Documentation]     Get the value of property from config
    Select Config Domain    web
    ${value} =              Get Config Property     ${prop}
    [Return]                ${value}

Remove Files In Directory       [Arguments]     ${path}     ${file}
    [Documentation]     Remove files in directory
    Remove Files        ${path}${/}${file}

Evaluate Data     [Arguments]    ${data}
    [Documentation]     Check the data if its jspringbot or robot variable - evaluate afterward.
    ${dataStartWith}=   Get Substring   ${data}      0  2
    ${data} =    Run Keyword If  '${dataStartWith}' == '\$['     EL Evaluate   ${data}   ELSE     SetVariable    ${data}
    [return]    ${data}

Set Config And Test Data    [Arguments]    ${form}   ${testData}
    [Documentation]     Set the config property and test data to use by passing the form to test
    Select Config Domain    ${form}
    Parse CSV Resource      ${testData}
    Set First CSV Row As Headers

Get All Data From CSV     [Arguments]     ${tag}
    [Documentation]     Get all row data from csv file
    #Get data from csv file
    Create CSV Criteria
    Add Column Name Equals CSV Restriction  Tag     ${tag}

    ${result} =  Get CSV List Result
    [return]    ${result}

Get First Data From CSV     [Arguments]    ${variable}   ${tag}
    [Documentation]     Get First row data from csv file and set it as variable
    Create CSV Criteria
    Add Column Name Equals CSV Restriction  Tag     ${tag}
    ${result}=  First CSV Result
    El add variable   ${variable}   ${result}

Generate Random Integer
    [Documentation]     generate a random integer
    ${var} =    Generate Random String      4      [NUMBERS]
    [return]    ${var}

######################################################################
#                     CSV File Creation Keywords                     #
######################################################################
Create CSV File             [Arguments]    ${path}     ${filename}
    [Documentation]     Create CSV File in specified location
    Parse State CSV Resource	REPORT   ${path}/${filename}

Append Line to CSV File     [Arguments]    ${header}     ${line}
    [Documentation]     Append a line in the CSV File
    Switch CSV State    REPORT
    Set CSV Headers     ${header}
    Append CSV Line	    ${line}
    #Switch CSV State    TESTDATA

Create CSV For Page Response   [Arguments]    ${event}     ${comment}      ${response}
    [Documentation]     create a csv file report for page response
    ${path}                     Set Variable        ${EXECDIR}/target/robotframework-reports
    ${filename}                 EL Evaluate         $[config:csv.report.filename.page.response]
    ${time}                     El Evaluate         $[${response} / 1000]

    ${line}                     SetVariable         ${event},${comment},${time}

    Create CSV File             ${path}                             ${filename}
    Append Line to CSV File     EVENT,COMMENT(from mainmenu),RESPONSE_TIME(seconds)         ${line}

Create CSV For Compare Version  [Arguments]    ${env}     ${url}      ${version}
    [Documentation]     create a csv file report for compare software version
    ${currentNow}	    EL Evaluate	        $[date:current()]
    ${report}           EL Evaluate         $[config:csv.report.location]
    ${path}             Set Variable        ${EXECDIR}/${report}
    ${filename}         EL Evaluate         $[config:csv.report.filename.compare.version]
    ${line}             SetVariable         ${currentNow},${env},${url},${version}

    Create CSV File             ${path}                             ${filename}
    Append Line to CSV File     DATE,LABEL,URL,VERSION              ${line}


######################################################################
#                     CSV File Creation Keywords                     #
######################################################################
Should Be Equal As Absolute Number     [Arguments]    ${value1}     ${value2}
    [Documentation]     verify two numbers absolute value are equal
    ${value1}       Evaluate Data       ${value1}
    ${value2}       Evaluate Data       ${value2}
    ${value1}       Evaluate            abs(${value1})
    ${value2}       Evaluate            abs(${value2})
    Should Be Equal As Integers         ${value1}       ${value2}