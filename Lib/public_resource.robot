*** Settings ***
Library           RequestsLibrary
Library           OperatingSystem
Library           Collections
Library           String
Library           SeleniumLibrary
Resource          common_resource.robot
Resource          global_resource.robot
Resource          public_api_resource.robot
Library           Screenshot    screenshot_directory=${TEMPDIR}

*** Keywords ***
Save Cookies
    ${set-cookie}=    Get Cookie Value    set-cookie
    [Return]    ${set-cookie}

Load Cookies
    [Arguments]    ${ekb-access-token}
    Add Cookie    ekb-access-token    ${ekb-access-token}    path=/    domain=${DOMAIN}    expiry=2027-09-28 16:21:35    secure=false

Gen Email
    [Timeout]
    ${dd}    ${hh}    ${min}    ${ss}=    Get Time    day,hour, min, sec
    ${email}=    Set Variable    ${EMAILPREFIX}${dd}${hh}${min}${ss}@gmail.com
    [Return]    ${email}

Scroll To Element
    [Arguments]    ${locator}
    Execute Javascript    window.document.evaluate('${locator}', document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.scrollIntoView(true);

MakeCID
    ${yyyy}    ${mm}    ${dd}    ${hh}    ${min}    ${ss}=    Get Time    year,month,day,hour, min, sec
    ${cid}=    Set Variable    ${yyyy}${mm}${dd}${hh}${min}${ss}00000
    [Return]    ${cid}

Get Value and Set Global Variable
    [Arguments]    ${locator}    ${variable_name}
    Wait Until Page Contains Element    ${locator}    ${TIMEOUTL1}
    ${value}=    Get Value    ${locator}
    Set Global Variable    ${variable_name}    ${value}

Prepare DesireCaps
    [Arguments]    ${device}
    ${DC}    Create Dictionary    ignoreProtectedModeSettings=${True}    ingoreZoomSettings=${True}
    Set Global Variable    ${DC}
    ${disabled}    Create List    Chrome PDF Viewer
    ${chromeOptions} =    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Create Directory    ${OUTPUTDIR}/download
    ${prefs} =    Create Dictionary    download.default_directory=${OUTPUTDIR}\\download    profile.default_content_settings.popups=0    ignore_image=2    plugins.plugins_disabled=${disabled}
    Comment    Call Method    ${chromeOptions}    add_argument    --headless
    Call Method    ${chromeOptions}    add_argument    --no-sandbox
    Call Method    ${chromeOptions}    add_argument    --ignore-certificate-errors
    Call Method    ${chromeOptions}    add_argument    --disable-gpu
    ${ignoreImage}=    Set Variable    --blink-settings=imagesEnabled=false
    run keyword if    '${DISABLEIMAGE}'=='true'    Call Method    ${chromeOptions}    add_argument    ${ignoreImage}
    Call Method    ${chromeOptions}    add_experimental_option    prefs    ${prefs}
    Set Global Variable    ${chromeOptions}
    Create WebDriver    Chrome    alias=chromewithdir    chrome_options=${chromeOptions}
    Log    Create Chrome Successfully
    ${result}=    Run Keyword If    '${device}' == 'ipadpro'    Set Window Size    1024    1366
    ...    ELSE IF    '${device}' == 'desktop'    Set Window Size    2835    1292
    ...    ELSE IF    '${device}' == 'ipad'    Set Window Size    768    1024
    ...    ELSE IF    '${device}' == 'iphone'    Set Window Size    414    736
    ...    ELSE IF    '${device}' == 'desktop1366x768'    Set Window Size    1366    768
    ...    ELSE IF    '${device}' == 'desktop1920x1024'    Set Window Size    1920    1024
    ...    ELSE IF    '${device}' == 'desktop1440X900'    Set Window Size    1440    900

Wait and Run Keyword L1
    [Arguments]    ${operation}    ${locator}    ${timeout}=${TIMEOUTL1}    @{rest_arg}
    Wait for Loading Done
    Wait Until Element Is Visible    ${locator}    ${timeout}
    Wait for Loading Done
    Run Keyword    ${operation}    ${locator}    @{rest_arg}
    Wait for Loading Done

Wait and Run Keyword
    [Arguments]    ${operation}    ${locator}    @{rest_arg}
    Wait Until Element Is Visible    ${locator}    ${TIMEOUTL2}
    Run Keyword    ${operation}    ${locator}    @{rest_arg}

Wait and Run Keyword L3
    [Arguments]    ${operation}    ${locator}    @{rest_arg}
    Wait for Loading Done
    Wait Until Element Is Visible    ${locator}    ${TIMEOUTL3}
    Wait for Loading Done
    Run Keyword    ${operation}    ${locator}    @{rest_arg}
    Wait for Loading Done

Wait and Run Keyword Custom
    [Arguments]    ${operation}    ${locator}    ${timeout}    @{rest_arg}
    Wait for Loading Done
    Wait Until Element Is Visible    ${locator}    ${timeout}
    Wait for Loading Done
    Run Keyword    ${operation}    ${locator}    @{rest_arg}
    Wait for Loading Done

Visit
    [Arguments]    ${link}
    Wait for Loading Done
    Run Keyword And Ignore Error    Go To    ${link}
    Wait for Loading Done

Click menu and Visit
    [Arguments]    ${menu_id}    ${menu_name_L2}    ${locator}    ${uri}=${EMPTY}    ${up_down}=${EMPTY}
    FOR    ${var}    IN RANGE    1    4
        ${status}    ${msg}=    Run Keyword And Ignore Error    Wait Until Element Is Enabled    //div[@id='${menu_id}']//div[@class='main-menu-label']    ${TIMEOUTL2}
        Exit FOR Loop If    '${status}'=='PASS'
        Reload Page
    END
    sleep    2
    ${up_count}=    Get Element Count    //div[@class='main-menu-scrollBtn up']
    ${down_count}=    Get Element Count    //div[@class='main-menu-scrollBtn down']
    Run Keyword If    '${up_count}'!='0' and '${up_down}'=='up'    Wait and Run Keyword    Click Element    //div[@class='main-menu-scrollBtn up']
    Run Keyword If    '${down_count}'!='0' and '${up_down}'=='down'    Wait and Run Keyword    Click Element    //div[@id='main-wrapper']//img[@class='img']
    Comment    Run Keyword If    '${up_down}'!='${EMPTY}'    Wait and Run Keyword    Click Element    //div[@id='main-wrapper']//img[@class='img']
    Wait and Run Keyword    Click Element    //div[@id='${menu_id}']//div[@class='main-menu-label']/..
    Wait and Run Keyword    Click Element With JS    //div[contains(@class,'float-menu-item ')]/*[text()='${menu_name_L2}']
    ${status1}    ${msg}=    Run Keyword And Ignore Error    Wait Until Element Is Visible    ${locator}    ${TIMEOUTL3}
    Run Keyword If    '${status1}'=='FAIL'    Visit Until Element Is Visible    ${uri}    ${locator}    3
    Wait for Loading Done

Select Value from Dropdown
    [Arguments]    ${locator}    ${selected_value}    ${index}=1
    Wait for Loading Done
    Wait and Run Keyword    Click Element    ${locator}
    Wait and Run Keyword    Click Element    xpath=(//*[contains(@class,'-placement-') and (not(contains(@class,'hidden')))]//*[text()='${selected_value}'])[${index}]

Select First Value By Dropdown Index
    [Arguments]    ${locator}    ${index}=1
    Wait for Loading Done
    Wait and Run Keyword    Click Element    ${locator}
    Comment    Wait and Run Keyword    Click Element    xpath=((//*[contains(@class,'ant-select-dropdown-menu-root')])[${index}]/li)[1]
    Wait and Run Keyword    Click Element    xpath=//*[contains(@class,'-placement-') and not(contains(@class,'hidden'))]//ul[1]//li[${index}]

Go to Pop Up Menu
    [Arguments]    ${parent_menu_id}    ${child_menu_id}
    ${status}    ${msg}=    Run Keyword And Ignore Error    Wait Until Element Is Visible    //div[@id='${parent_menu_id}']    ${TIMEOUTL1}
    Run Keyword If    '${status}'=='FAIL'    Reload Page
    Wait and Run Keyword    Click Element    //div[@id='${parent_menu_id}']
    ${count}=    Get Element Count    //div[@id='${child_menu_id}']
    Run keyword If    '${count}' == '0'    Wait and Run Keyword    Click Element    //div[@id='${parent_menu_id}']
    ${count}=    Get Element Count    //div[@id='${child_menu_id}']
    Run keyword If    '${count}' == '0'    Wait and Run Keyword    Click Element    //div[@id='${parent_menu_id}']
    ${count}=    Get Element Count    //div[@id='${child_menu_id}']
    Run keyword If    '${count}' == '0'    Wait and Run Keyword    Click Element    //div[@id='${parent_menu_id}']
    Wait and Run Keyword    Click Element    //div[@id='${child_menu_id}']

Generate Random Name
    [Arguments]    ${pre_name}
    ${cname}=    Get Time    epoch
    ${cname}=    Catenate    SEPARATOR=    ${pre_name}    ${cname}
    [Return]    ${cname}

Generate Random String Name
    [Arguments]    ${pre_name}    ${len}=5
    ${cname}=    Generate Random String    ${len}    [LOWER][NUMBERS]
    ${cname}=    Catenate    SEPARATOR=    ${pre_name}    ${cname}
    [Return]    ${cname}

Visit Until Element Is Visible
    [Arguments]    ${url}    ${locator}    ${try}    ${interval}=3
    Visit    ${url}
    FOR    ${var}    IN RANGE    1    ${${try}+1}
        ${status}    ${msg}=    Run Keyword And Ignore Error    Wait Until Element Is Visible    ${locator}    ${interval}
        Exit For Loop If    '${status}'=='PASS'
        Visit    ${url}
    END

Clear and Search
    [Arguments]    ${locator}    ${search_content}
    Wait and Run Keyword    Clear Element Text    ${locator}
    Wait and Run Keyword    Input Text    ${locator}    ${search_content}
    Wait and Run Keyword    Press Keys    ${locator}    RETURN

Click Element With JS
    [Arguments]    ${locator}
    Execute Javascript    function _x(STR_XPATH) { var xresult = document.evaluate(STR_XPATH, document, null, XPathResult.ANY_TYPE, null); var xnodes = []; var xres; while (xres = xresult.iterateNext()) { xnodes.push(xres);} return xnodes;} ele = _x("${locator}")[0]; ele.click()

Clear and Input
    [Arguments]    ${locator}    ${input_content}
    Wait and Run Keyword    Press Keys    ${locator}    CTRL+a
    Repeat Keyword    5    Wait and Run Keyword    Press Keys    ${locator}    BACKSPACE
    Wait and Run Keyword    Input Text    ${locator}    ${input_content}

Sleep and Reload
    [Arguments]    ${time}=2
    Sleep    ${time}
    Reload Page

Wait Until Window Is Not Visible
    [Arguments]    ${index}=1
    Wait for Loading Done
    Wait Until Element Is Not Visible    xpath=(//div[@class='ant-modal-mask'])[${index}]    ${TIMEOUTL1}
    Wait for Loading Done

Add Numbers
    [Arguments]    ${str01}    ${str02}
    ${num_01}=    Convert To Number    ${str01}    2
    ${num_02}=    Convert To Number    ${str02}    2
    ${result}=    Evaluate    ${num_01}+${num_02}
    [Return]    ${result}

Loop Run Keyword Until Element Is Visible
    [Arguments]    ${operation}    ${locator}    ${expected_locator}    @{rest_arg}
    FOR    ${var}    IN    1    4
    Wait and Run Keyword    ${operation}    ${locator}    @{rest_arg}
    ${status}    ${msg}    Run Keyword And Ignore Error    Wait Until Element Is Visible    ${expected_locator}    ${TIMEOUTL1}
    Exit For Loop If    '${status}'=='PASS'

Loop Run Keyword Until Element Is Disppear
    [Arguments]    ${operation}    ${locator}    @{rest_arg}
    FOR    ${var}    IN    1    4
    Wait and Run Keyword    ${operation}    ${locator}    @{rest_arg}
    Sleep    ${SLEEP_TIME_2SEC}
    ${status}    ${msg}    Run Keyword And Ignore Error    Wait Until Element Is Not Visible    ${locator}    ${TIMEOUTL1}
    Exit For Loop If    '${status}'=='PASS'

Set Device
    [Arguments]    ${device}    ${alias}=BrowserA
    Open Browser    ${WEB_ROOT}    ${BROWSER}    options=${chromeOptions}    alias=${alias}
    ${result}=    Run Keyword If    '${device}' == 'ipadpro'    Set Window Size    1024    1366
    ...    ELSE IF    '${device}' == 'desktop'    Set Window Size    2835    1292
    ...    ELSE IF    '${device}' == 'ipad'    Set Window Size    768    1024
    ...    ELSE IF    '${device}' == 'iphone'    Set Window Size    414    736
    ...    ELSE IF    '${device}' == 'desktop1366x768'    Set Window Size    1366    768
    ...    ELSE IF    '${device}' == 'desktop1920x1024'    Set Window Size    1920    1024
    ...    ELSE IF    '${device}' == 'desktop1440X900'    Set Window Size    1440    900

Open Chrome Using Create WebDriver Keyword
    [Arguments]    ${device}
    ${chromeOptions}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${chromeOptions}    add_argument    --ignore-certificate-errors
    Call Method    ${chromeOptions}    add_argument    --disable-gpu
    ${dir}=    set variable    --user-data-dir=${DIR}
    ${homepage}=    set variable    --homepage=https://www.google.com
    Call Method    ${chromeOptions}    add_argument    ${dir}
    Call Method    ${chromeOptions}    add_argument    ${homepage}
    Create WebDriver    Chrome    alias=chromewithdir    chrome_options=${chromeOptions}
    Log    Create Chrome Successfully
    Run Keyword If    '${device}' == 'ipadpro'    Set Window Size    1024    1366
    ...    ELSE IF    '${device}' == 'desktop'    Set Window Size    2835    1292
    ...    ELSE IF    '${device}' == 'ipad'    Set Window Size    768    1024
    ...    ELSE IF    '${device}' == 'iphone'    Set Window Size    414    736
    ...    ELSE IF    '${device}' == 'desktop1366x768'    Set Window Size    1366    768
    ...    ELSE IF    '${device}' == 'desktop1920x1080'    Set Window Size    1920    1080
    ...    ELSE IF    '${device}' == 'desktop1440X900'    Set Window Size    1440    900
    Go To    ${WEB_ROOT}
