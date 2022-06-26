*** Settings ***
Library           SeleniumLibrary
Resource          ../Lib/all_resources.robot

*** Keywords ***
login
    [Arguments]    ${username}    ${password}
    Wait And Run Keyword    Input Text    //*[@id="loginid"]    ${username}
    Wait And Run Keyword    Input Text    //*[@id="userpassword"]    ${password}
    Wait And Run Keyword    Click Element    //*[@id="submit"]
    Sleep    5

first_login
    [Arguments]    ${username}    ${password}
    Wait And Run Keyword    Input Text    //*[@name="user"]    admin
    Wait And Run Keyword    Input Text    //*[@name="password"]    admin
    Wait And Run Keyword    Click Element    //*[text()="Log In"]
    Sleep    5
    Wait And Run Keyword    Click Element    //*[@id="newPassword"]
    Wait And Run Keyword    Input Text    //*[@id="newPassword"]    ${password}
    Wait And Run Keyword    Click Element    //*[@name="confirmNew"]
    Wait And Run Keyword    Input Text    //*[@name="confirmNew"]    ${password}
    Wait And Run Keyword    Click Element    //*[@class="btn btn-large p-x-2 btn-primary"]
    Sleep    5
