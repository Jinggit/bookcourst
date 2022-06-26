*** Settings ***
Resource          ../Lib/all_resources.robot

*** Keywords ***
choose warehouse
    [Arguments]    ${warehouse}
    Wait And Run Keyword    Click Element    //*[*[contains(text(),"仓库")]]//value-select-dropdown
    Wait And Run Keyword    Click Element    //*[*[contains(text(),"仓库")]]//input
    Wait And Run Keyword    Input Text    //*[*[contains(text(),"仓库")]]//input    ${warehouse}
    Wait And Run Keyword    Press Keys    //*[*[contains(text(),"仓库")]]//input    RETURN
    Comment    Wait And Run Keyword    Click Element    //*[*[contains(text(),"仓库")]]//value-select-dropdown//*[contains(text(),"${warehouse}")]

refresh dashboard
    Wait And Run Keyword    Click Element    //*[@class="fa fa-refresh"]
