*** Settings ***
Library     JSpringBotGlobal
Library     String
Library     Collections
Library     DateTime

Resource    locators.robot
Resource    constant.robot

*** Variables ***
${POLL_MILLIS}      500
${TIMEOUT_MILLIS}    60000


######################################################################
#                   Events and Actions Keywords                      #
######################################################################
*** Keywords ***
Test Tear Down
    Run Keyword If Test Failed          Take Screenshot
    Select Window                       ${PARENT_WINDOW}

Suite Tear Down
    Capture Screenshot
    Delete All Cookies

Take Screenshot
    ${SCREENSHOT_LOCATION}      Capture Screenshot
    Set Global Variable         ${SCREENSHOT_LOCATION}        ${SCREENSHOT_LOCATION}

Navigate To Form    [Arguments]     ${url}
    [Documentation]     Go/Navigate to a given url
    ${url}          Evaluate Data       ${url}
    Navigate To                         ${url}
	Maximize Window

Is Element Present Without Wait Time        [Arguments]         ${locator}
    [Documentation]     checking if element present without the implicit wait time
    Set Implicit Wait Time          0
    ${isPresent}                    Is Element Present          ${locator}
    Set Implicit Wait Time          10
    [return]                        ${isPresent}

Click Button        [Arguments]         ${locator}
    [Documentation]     clicks button, link and etc
    ${locator}                          Evaluate Data       ${locator}
    Run Keyword And Ignore Error        Highlight Element   ${locator}
    Click Element                       ${locator}

Click Button By Action        [Arguments]         ${locator}
    [Documentation]     clicks button, link and etc by action
    ${locator}                          Evaluate Data       ${locator}
    Run Keyword And Ignore Error        Highlight Element   ${locator}
    Action Start
    Action Move To Element	            ${locator}
    Action Click
    Action Perform

Click Button By JS        [Arguments]         ${locator}
    [Documentation]     clicks button, link and etc through javascript
    ${locator}                          Evaluate Data       ${locator}
    Wait For Visible                    ${locator}
    Run Keyword And Ignore Error        Highlight Element   ${locator}
    Element Execute JavaScript          ${locator}          arguments[0].click();

Click Checkbox By Value        [Arguments]         ${locator}       ${value}
    [Documentation]     clicks checkbox by value
    ${locator}          Evaluate Data       ${locator}
    ${locator}          Replace String      ${locator}     VALUE    ${value}
    Wait For Visible    ${locator}
    Run Keyword And Ignore Error        Highlight Element   ${locator}
    Click Element       ${locator}

Type Text           [Arguments]         ${locator}      ${text}
    [Documentation]     supply input for a field
    ${locator}          Evaluate Data   ${locator}
    ${text}             Evaluate Data   ${text}
    Wait For Visible    ${locator}
    Run Keyword And Ignore Error        Highlight Element   ${locator}
    Input Text          ${locator}      ${text}

Get Text Field Value    [Arguments]         ${locator}
    [Documentation]     get and store field text value
    ${locator}=         Evaluate Data   ${locator}
    Wait For Visible    ${locator}
    Run Keyword And Ignore Error        Highlight Element   ${locator}
    ${value}            Get Text        ${locator}
    [return]            ${value}

Get Dropdown Selected Label Value   [Arguments]         ${locator}
    [Documentation]     get the dropdown selected lable value
    ${locator}                          Evaluate Data               ${locator}
    ${selectedValue}                    Get Selected List Label     ${locator}
    Run Keyword And Ignore Error        Highlight Element           ${locator}
    [return]                            ${selectedValue}

Select By Index             [Arguments]         ${locator}      ${index}
    [Documentation]     select a value in a drop-down using its index
    ${locator}          Evaluate Data   ${locator}
    Wait For Visible                    ${locator}
    Run Keyword And Ignore Error        Highlight Element   ${locator}
    Select From List By Index           ${locator}          ${index}

Select By Value Displayed   [Arguments]         ${locator}      ${value}
    [Documentation]     select a value in a drop-down using its label displayed
    ${value}            Evaluate Data   ${value}
    ${locator}          Evaluate Data   ${locator}
    Wait For Visible                    ${locator}
    Run Keyword And Ignore Error        Highlight Element               ${locator}
    ${selectedValues}                   Run Keyword And Ignore Error    Get Selected List Labels        ${locator}
    ${isSelected}                       Is String Contains              ${selectedValues}               ${value}
    Run Keyword Unless                  ${isSelected}                   Select From List By Label       ${locator}          ${value}

Table Scroll Down   [Arguments]         ${locator}
    [Documentation]     scrolls table down
    ${locator}          Evaluate Data   ${locator}
    Action Start
    Action Move To Element	            ${locator}
    Action Click And Hold               ${locator}
    Action Send Keys	                cord=PAGE_DOWN|PAGE_DOWN
    Action Release
    Action Perform

Table Scroll Up   [Arguments]         ${locator}
    [Documentation]     scrolls table up
    ${locator}          Evaluate Data   ${locator}
    Action Start
    Action Move To Element	            ${locator}
    Action Click And Hold               ${locator}
    Action Send Keys	                cord=PAGE_UP|PAGE_UP
    Action Release
    Action Perform

Drag And Drop Element   [Arguments]     ${fromlocator}      ${tolocator}
    [Documentation]     drag and drop
    ${fromlocator}      Evaluate Data   ${fromlocator}
    ${tolocator}        Evaluate Data   ${tolocator}
    Run Keyword And Ignore Error        Highlight Element   ${fromlocator}
    Run Keyword And Ignore Error        Highlight Element   ${tolocator}
    Drag And Drop                       ${fromlocator}      ${tolocator}

Reload Current Page
    [Documentation]  reload the current page
    Reload Page

Mouse Over Element                  [Arguments]    ${locator}
    [Documentation]         mouse over the element by locator
    ${locator}                      Evaluate Data           ${locator}
    Run Keyword And Ignore Error    Highlight Element       ${locator}
    Mouse Over                                              ${locator}
    Sleep                           500ms

Press Arrow Up To Element   [Arguments]         ${locator}
    [Documentation]     move to that element and press arrow up
    Action Start
    Action Move To Element	            ${locator}
    Action Click                        ${locator}
    Action Send Keys	                cord=ARROW_UP
    Action Perform

Press Arrow Down To Element   [Arguments]         ${locator}
    [Documentation]     move to that element and press arrow down
    Action Start
    Action Move To Element	            ${locator}
    Action Click                        ${locator}
    Action Send Keys	                cord=ARROW_DOWN
    Action Perform

Press Arrow Right Button
    [Documentation]     move to that element and press arrow down
    Action Start
    Action Send Keys	                cord=ARROW_RIGHT
    Action Perform

Is Checkbox Selected          [Arguments]         ${locator}
    [Documentation]     verify is checkbox selected
    ${locator}          Evaluate Data   ${locator}
    ${status}=          Run Keyword And Return Status   Checkbox Should Be Selected      ${locator}
    Run Keyword And Ignore Error        Highlight Element   ${locator}
    [Return]            ${status}

Press Back Space
    [Documentation]     press back space
    Action Start
    Action Send Keys    cord=BACK_SPACE
    Action Perform

Press Escape Button
    [Documentation]     press escape button
    Action Start
    Action Send Keys    cord=ESCAPE
    Action Perform

Press Enter Button
    [Documentation]     press enter button
    Action Start
    Action Send Keys    cord=ENTER
    Action Perform

Select Checkbox Element        [Arguments]         ${locator}
    ${locator}          Evaluate Data   ${locator}
    Wait For Visible    ${locator}
    Run Keyword And Ignore Error        Highlight Element   ${locator}
    Select Checkbox     ${locator}

Unselect Checkbox Element        [Arguments]         ${locator}
    [Documentation]     unselect checkbox element
    ${locator}          Evaluate Data   ${locator}
    Wait For Visible    ${locator}
    Run Keyword And Ignore Error        Highlight Element   ${locator}
    Unselect Checkbox   ${locator}

Open New Browser        [Arguments]     ${url}
    [Documentation]     Open new browser and navigate to URL
    Element Execute Javascript              css=body    window.open('blank')
    ${windowHandles}=	                    Get Window Handles
    Select Window	                        $[var('windowHandles')[1]]
    Sleep                                   2s
    Navigate To Form                        ${url}

Select New Window       [Arguments]     ${title}
    [Documentation]  select new window
    ${window}=	                            Get Window Handle
    EL Add Variable	                        parentWindow	            $[var('window')]
    ${windowHandles}=	                    Get Window Handles
    ${windowIndices}=	                    EL Evaluate	                $[col:size(var('windowHandles'))]
    EL Should Be True	                    $[var('windowIndices') gt 1]
    EL Add Variable	                        lastOpenedWindowIndex	    $[i:var('windowIndices') - 1]
    EL Add Variable	                        lastOpenedWindow	        $[var('windowHandles')[lastOpenedWindowIndex]]
    Select Window	                        $[var('windowHandles')[lastOpenedWindowIndex]]
    Title Should Be                         ${title}

Get Element Position        [Arguments]         ${locator}
    [Documentation]     get x and y postion of an element
    ${locator}          Evaluate Data   ${locator}
    Wait For Visible    ${locator}
    #Run Keyword And Ignore Error        Highlight Element   ${locator}
    ${horizantal}       Get Horizontal Position         ${locator}
    ${vertical}         Get Vertical Position           ${locator}
    ${postion}          Create List                     ${horizantal}           ${vertical}
    [return]            ${postion}

Select Date In Calendar     [Arguments]     ${date}
    [Documentation]     Select Date In Calendar in yyyy-MM-dd format
    &{months}=       Create Dictionary      01=January  02=February     03=March    04=April    05=May  06=June     07=July     08=August   09=September    10=October  11=November     12=December
    #${date}=         Print Date Time
    @{tempList}=     Split String           ${date}         -
    ${year}=         Get From List          ${tempList}     0
    ${mm}=           Get From List          ${tempList}     1
    ${day}=          Get From List          ${tempList}     2
    Click Button                            ${LOCATORS.GENERIC_DAYPICKER_GRID_HEADER}
    Click Button                            ${LOCATORS.GENERIC_MONTHPICKER_GRID_HEADER}
    ${locator}=      Replace String         ${LOCATORS.GENERIC_YEARPICKER_GRID_VALUE}       VALUE       ${year}
    Click Button                            ${locator}
    ${month}=        Get From Dictionary    ${months}       ${mm}
    ${locator}=      Replace String         ${LOCATORS.GENERIC_MONTHPICKER_GRID_VALUE}      VALUE       ${month}
    Click Button                            ${locator}
    ${locator}=      Replace String         ${LOCATORS.GENERIC_DAYPICKER_GRID_VALUE}        VALUE       ${day}
    Click Button                            ${locator}

######################################################################
#                           Wait  Keywords                           #
######################################################################
Wait For Element     [Arguments]    ${locator}
    [Documentation]     Polls every 500 or half a second and will fail when timeout is reached (see values on contants POLL_MILLIS and TIMEOUT_MILLIS).
    Wait Till Element Found     ${locator}    ${POLL_MILLIS}    ${TIMEOUT_MILLIS}
    Wait Till Element Visible     ${locator}    ${POLL_MILLIS}    ${TIMEOUT_MILLIS}

Wait For Visible     [Arguments]    ${locator}
    [Documentation]     Polls every 500 or half a second and will fail when timeout is reached (see values on contants POLL_MILLIS and TIMEOUT_MILLIS).
    Wait Till Element Visible     ${locator}    ${POLL_MILLIS}    ${TIMEOUT_MILLIS}

Wait Element Contains Text     [Arguments]    ${locator}    ${message}
    [Documentation]     Polls every 500 or half a second and will fail when timeout is reached (see values on contants POLL_MILLIS and TIMEOUT_MILLIS).
    Wait Till Element Contains Text     ${locator}    ${message}    ${POLL_MILLIS}    ${TIMEOUT_MILLIS}


######################################################################
#                Validations and Checkpoints Keywords                #
######################################################################
Verify Element Text Should Not Be Empty     [Arguments]    ${locator}
    [Documentation]     Verify element text should not be empty or null
    ${value}                 Get Text       ${locator}
    Should Not Be Empty      ${value}       Element [${locator}] should not be empty!

Verify Element Should Be Present        [Arguments]    ${locator}
    [Documentation]     Searches the page for the given element. Returns true if a match is found and false if none.
    Should Be True          ${isPresent}    Element [${locator}] should be present!
    Run Keyword And Ignore Error            Highlight Element   ${locator}

Verify Text Should Be Present           [Arguments]    ${text}
    [Documentation]     Searches the page for the given text. Returns true if a match is found and false if none.
    ${text} =           Evaluate Data           ${text}
    ${locator}=         Replace String          ${GENERIC_XPATH_TEXT}     VALUE    ${text}
    ${isPresent} =      Is Element Present      ${locator}
    Should Be True      ${isPresent}            Text [${text}] is not present!

Verify Text Should Not Be Present           [Arguments]    ${text}
    [Documentation]     Searches the page for the given text. Returns true if a match is found and false if none.
    ${text} =           Evaluate Data           ${text}
    ${locator}=         Replace String          ${GENERIC_XPATH_TEXT}     VALUE    ${text}
    ${isPresent} =      Is Element Present      ${locator}
    Should Not Be True  ${isPresent}            Text [${text}] is present!

Verify Element Should Be Visible By Value        [Arguments]    ${locator}    ${value}
    [Documentation]     Verify if element is visible - passing a locator with variable for its value
    ${locator}          Replace String       ${locator}     VALUE    ${value}
    ${isPresent}        Is Element Present      ${locator}
    Should Be True      ${isPresent}            Element [${locator}] is not present!
    ${isVisble}         Is Element Visible      ${locator}
    Should Be True      ${isVisble}             Element [${locator}] is not visible!
    Run Keyword And Ignore Error        Highlight Element   ${locator}

Verify Element Should Be Visible        [Arguments]    ${locator}
    [Documentation]     Verify if element is visible
    ${locator}          Evaluate Data           ${locator}
    ${isPresent}        Is Element Present      ${locator}
    Should Be True      ${isPresent}            Element [${locator}] is not present!
    ${isVisble}         Is Element Visible      ${locator}
    Should Be True      ${isVisble}             Element [${locator}] is not visible!
    Run Keyword And Ignore Error                Highlight Element       ${locator}

Verify Element Should Be Disabled        [Arguments]        ${locator}
    [Documentation]     Verify if element is disabled
    Element Should Be Disabled          ${locator}
    Run Keyword And Ignore Error        Highlight Element   ${locator}

Verify Element Should Be Enabled         [Arguments]        ${locator}
    [Documentation]     Verify if element is enabled
    Element Should Be Enabled           ${locator}
    Run Keyword And Ignore Error        Highlight Element   ${locator}

Verify Element Should Not Be Present        [Arguments]    ${locator}
    [Documentation]         Verify element should not be present
    ${locator}              Evaluate Data           ${locator}
    ${isPresent}            Is Element Present      ${locator}
    Should Not Be True      ${isPresent}            Element [${locator}] is present!

Verify Element Should Not Be Visible        [Arguments]    ${locator}
    [Documentation]         Verify element should not be visble
    ${locator}              Evaluate Data           ${locator}
    ${isVisble}             Is Element Visible      ${locator}
    Should Not Be True      ${isVisble}             Element [${locator}] is visible!

Verify Element Value Length     [Arguments]     ${locator}     ${length}
    [Documentation]         Verify element value length
    ${locator}                          Evaluate Data       ${locator}
    Run Keyword And Ignore Error        Highlight Element   ${locator}
    ${value}                            Get Value           ${locator}
    ${getLength}                        Get Length          ${value}
    Should Be Equal As Integers         ${getLength}        ${length}    Element Length is not as expected [${getLength} != ${length}]

Verify Element Value             [Arguments]            ${locator}     ${expectedValue}
    [Documentation]         Verify element value
    ${locator}                      Evaluate Data       ${locator}
    ${expectedValue}                Evaluate Data       ${expectedValue}
    Run Keyword And Ignore Error    Highlight Element   ${locator}
    ${currectValue}                 Get Value           ${locator}
    Should Be Equal As Strings      ${currectValue}     ${expectedValue}    Element value is not as expected [${currectValue} != ${expectedValue}]

Verify Dropdown Selected Label    [Arguments]    ${locator}       ${expectedValue}
    [Documentation]         Verify drop-down selected value
    ${locator}                      Evaluate Data               ${locator}
    ${expectedValue}                Evaluate Data               ${expectedValue}
    ${currectValue}                 Get Selected List Label     ${locator}
    Should Be Equal As Strings      ${currectValue}             ${expectedValue}    Element value is not as expected [${currectValue} != ${expectedValue}]

Verify Element Value Should Not Be Empty     [Arguments]    ${locator}
    [Documentation]     Verify element text should not be empty or null
    ${locator}              Evaluate Data       ${locator}
    Run Keyword And Ignore Error                Highlight Element   ${locator}
    ${value}                Get Value           ${locator}
    Should Not Be Empty                         ${value}            Element [${locator}] value is empty!

Verify Element Value Should Be Empty        [Arguments]    ${locator}
    [Documentation]     Verify element text should be empty or null
    ${locator}              Evaluate Data       ${locator}
    Run Keyword And Ignore Error                Highlight Element   ${locator}
    ${value}                Get Value           ${locator}
    Should Be Empty                             ${value}}            Element [${locator}] value is not empty!

Verify Downloaded File Exist        [Arguments]    ${filename}
    [Documentation]     checks if file downloaded exists
    #Download Should Exists      ${filename}
    Should Exist      ${filename}

Verify Downloaded File Exist In Default Folder        [Arguments]    ${filename}
    [Documentation]     checks if file downloaded exists - selenium.download.directory=/tmp/selenium
    Download Should Exists      ${filename}

Verify Checkbox Should Not Be Selected          [Arguments]         ${locator}
    [Documentation]     verify checkbox shoud not be selected
    ${locator}          Evaluate Data   ${locator}
    ${STATUS}=          Run Keyword And Return Status   Checkbox Should Be Selected      ${locator}
    Run Keyword And Ignore Error        Highlight Element   ${locator}
    Should Not Be True  ${STATUS}

Verify Checkbox Should Be Selected          [Arguments]         ${locator}
    [Documentation]     verify checkbox shoud be selected
    ${locator}          Evaluate Data   ${locator}
    ${STATUS}=          Run Keyword And Return Status   Checkbox Should Be Selected      ${locator}
    Run Keyword And Ignore Error        Highlight Element   ${locator}
    Should Be True      ${STATUS}