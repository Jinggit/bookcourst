*** Settings ***
Library           SeleniumLibrary
Resource          ../Lib/all_resources.robot

*** Keywords ***
choose last n days
    [Arguments]    ${days}
    Wait And Run Keyword    Click Element    //*[@class="btn navbar-button navbar-button--tight"]
    Wait And Run Keyword    Input Text    (//*[@class="css-uimlsy-input-input"])[1]    now-${days}d
    Wait And Run Keyword    Input Text    (//*[@class="css-uimlsy-input-input"])[2]    now
    Wait And Run Keyword    Click Element    //*[text()="Apply time range"]

absolute time range
    [Arguments]    ${starttime}    ${endtime}
    Wait And Run Keyword    Click Element    //*[@class="btn navbar-button navbar-button--tight"]
    Wait And Run Keyword    Input Text    (//*[@class="css-uimlsy-input-input"])[1]    ${starttime}
    Wait And Run Keyword    Input Text    (//*[@class="css-uimlsy-input-input"])[2]    ${endtime}
    Wait And Run Keyword    Click Element    //*[text()="Apply time range"]
