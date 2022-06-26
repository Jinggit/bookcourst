*** Settings ***
Library           SeleniumLibrary
Resource          ../Lib/all_resources.robot

*** Keywords ***
机器人充电明细为空
    Wait Until Element Is Visible    //*[//*[contains(text(),"机器人充电明细")] and @id="panel-2"]//*[contains(text(),"No data to show")]    ${TIMEOUTL2}

机器人充电明细不为空
    Wait Until Element Is Not Visible    //*[//*[contains(text(),"机器人充电明细")] and @id="panel-2"]//*[contains(text(),"No data to show")]    ${TIMEOUTL2}
