*** Settings ***
Library           SeleniumLibrary
Resource          ../Lib/all_resources.robot

*** Keywords ***
获取走偏故障总数
    Wait Until Element Is Visible    //*[//*[contains(text(),"走偏故障总数")]]//*[@class="singlestat-panel-value"]    ${TIMEOUTL2}
    refresh dashboard
    wait until data section loading done
    ${total}=    Get Text    //*[//*[contains(text(),"走偏故障总数")]]//*[@class="singlestat-panel-value"]
    [Return]    ${total}
