*** Settings ***
Resource          ../Lib/all_resources.robot

*** Keywords ***
wait until data section loading done
    Run Keyword And Ignore Error    Wait Until Element Is Visible    //*[@class="panel-loading"]//*[@class="fa fa-spinner fa-spin"]    ${TIMEOUTL3}
    Run Keyword And Ignore Error    Wait Until Page Does Not Contain Element    //*[@class="panel-loading"]//*[@class="fa fa-spinner fa-spin"]    ${TIMEOUTL3}

verify no error on the dashboard end
    Wait Until Page Does Not Contain Element    //*[contains(@class,"panel-info-corner panel-info-corner--error")]

sleeping for loading
    [Arguments]    ${seconds}
    Sleep    ${seconds}

verify no error on the dashboard begin
    Wait Until Page Does Not Contain Element    //*[contains(@class,"alert alert-error")]

take screenshot and close browser if test failed
    Run Keyword If Test Failed    Capture Page Screenshot
    Close Browser
