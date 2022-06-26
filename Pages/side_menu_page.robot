*** Settings ***
Library           SeleniumLibrary
Resource          ../Lib/all_resources.robot

*** Keywords ***
go to dashboard by menu
    [Arguments]    ${l1}    ${l2}
    Wait And Run Keyword    Click Element    //*[@class="sidemenu-link" and @href="/"]
    Comment    Wait Until Page Contains    Welcome to Grafana    ${TIMEOUTL3}
    Wait And Run Keyword    Click Element    //*[@class="gicon gicon-manage"]
    Wait And Run Keyword    Click Element    //*[@class="search-section__header__text" and text()="${l1}"]
    Wait And Run Keyword    Click Element    //*[@class="search-item__body-title" and text()="${l2}"]
