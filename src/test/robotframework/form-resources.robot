*** Settings ***
Library     JSpringBotGlobal
Library     String
Library     Collections

*** Variables ***
${POLL_MILLIS}      500
${TIMEOUT_MILLIS}    10000
${MAX_RESULT_DISPLAY}    250
${REGEX_NUM}      [0-9]+
${HTML_CODE_SYNTAX}      &#

*** Keywords ***
Open Frontend Url     [Arguments]    ${url}
    Navigate To     ${url}
    Maximize Window

Type to Input Field     [Arguments]    ${loactor}     ${value}
    Click Element       ${loactor}
    Input Text          ${loactor}     ${value}