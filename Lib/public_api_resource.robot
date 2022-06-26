*** Settings ***
Documentation     public keywords
Library           Collections
Library           RequestsLibrary
Library           json
Library           String
Library           DateTime
Resource          common_resource.robot
Resource          global_resource.robot
Resource          utils_resource.robot

*** Keywords ***
Put Request with Cookie and Json
    [Arguments]    ${root}    ${uri}    ${cookies}    @{form_data}
    Create Session    demo    ${root}
    ${data}=    Create Dictionary    @{form_data}
    ${headers}=    Create Dictionary    Content-Type=${CONTENT_TYPE}    User-Agent=${USER_AGENT}    cookie=${cookies}
    ${data}=    json.loads    ${data['param']}
    ${resp}=    Put Request    demo    ${uri}    ${data}    \    ${EMPTY}    ${headers}    timeout=${TIMEOUTL2}
    Log    ${resp}
    ${status}    ${resp_content}=    Run Keyword and Ignore Error    Evaluate    "${resp.json()}".encode('utf-8').decode('unicode_escape')
    Log    ${resp_content}
    [Return]    ${resp}

Post Request with Dict and Cookie
    [Arguments]    ${root}    ${uri}    ${session}    @{form_data}
    Create Session    demo    ${root}    disable_warnings=1
    ${data}=    Create Dictionary    @{form_data}
    Comment    ${json_data}=    json.dumps    ${data}
    ${headers}=    Create Dictionary    &{HEADER}    Content-Type=${CONTENT_TYPE}    User-Agent=${USER_AGENT}    Cookie=${session}
    Comment    ${json_headers}=    json.dumps    ${headers}
    ${resp}=    Post Request    demo    ${uri}    ${data}    \    ${headers}    timeout=${TIMEOUT}
    Log    ${resp}
    ${status}    ${resp_content}=    Run Keyword and Ignore Error    Evaluate    "${resp.json()}".encode('utf-8').decode('unicode_escape')
    Log    ${resp_content}
    [Return]    ${resp}

List Should Contain Value Contain
    [Arguments]    ${str}    ${val}
    ${status}=    Set Variable    FAIL
    FOR    ${item}    IN    @{str}
    ${item}=    Evaluate    "${item}".decode('utf8')
    ${status}    ${value}=    Run Keyword and Ignore Error    Should Contain    ${item}    ${val}
    Run Keyword If    '${status}' == 'PASS'    Exit For Loop
    Should Be Equal    ${status}    PASS
    [Return]    ${status}

Post Request with Dict
    [Arguments]    ${root}    ${uri}    @{form_data}
    Create Session    demo    ${root}    disable_warnings=1
    ${data}=    Create Dictionary    @{form_data}
    ${headers}=    Create Dictionary    &{HEADER}    Content-Type=${CONTENT_TYPE}    User-Agent=${USER_AGENT}
    ${resp}=    Post Request    demo    ${uri}    ${data}    \    ${headers}    timeout=${TIMEOUT}
    Log    ${resp}
    ${status}    ${resp_content}=    Run Keyword and Ignore Error    Evaluate    "${resp.json()}".encode('utf-8').decode('unicode_escape')
    Log    ${resp_content}
    [Return]    ${resp}

Get Request with Auth
    [Arguments]    ${root}    ${uri}    ${auth}    ${param}
    Create Session    alias=test    url=${root}    disable_warnings=1
    ${headers}=    Create Dictionary    Authorization=Bearer ${auth}    User-Agent=${USER_AGENT}    accept=${ACCEPT}
    ${param}=    json.loads    ${param}
    ${resp}=    Get Request    alias=test    uri=${uri}    headers=${headers}    params=${param}    timeout=${TIMEOUTL2}
    ${status}    ${resp_content}=    Run Keyword and Ignore Error    Evaluate    "${resp.json()}"
    Log    ${resp_content}
    [Return]    ${resp}

Del Request with Cookie
    [Arguments]    ${root}    ${uri}    ${cookies}
    Create Session    demo    ${root}
    ${headers}=    Create Dictionary    &{HEADER}    Content-Type=${CONTENT_TYPE}    Cookie=${cookies}    User-Agent=${USER_AGENT}
    ${resp}=    Delete Request    demo    ${uri}    ${headers}    timeout=${TIMEOUT}
    Log    ${resp}
    ${status}    ${resp_content}=    Run Keyword and Ignore Error    Evaluate    "${resp.json()}".encode('utf-8').decode('unicode_escape')
    Log    ${resp_content}
    [Return]    ${resp}

Post Request with Json and Cookie and Params
    [Arguments]    ${root}    ${uri}    ${session}    ${param}    ${data}
    Create Session    demo    ${root}    disable_warnings=1
    ${headers}=    Create Dictionary    Content-Type=${CONTENT_TYPE}    User-Agent=${USER_AGENT}    Cookie=${session}
    ${param}=    json.loads    ${param}
    ${resp}=    Post Request    alias=test    uri=${uri}    headers=${headers}    params=${param}    data=${data}    timeout=${TIMEOUTL2}
    Log    ${resp}
    ${status}    ${resp_content}=    Run Keyword and Ignore Error    Evaluate    "${resp.json()}"
    Log    ${resp_content}
    [Return]    ${resp}

Post Request with Json and Cookie
    [Arguments]    ${root}    ${uri}    ${session}    @{form_data}
    Create Session    demo    ${root}    disable_warnings=1
    ${data}=    Create Dictionary    @{form_data}
    ${headers}=    Create Dictionary    Content-Type=${CONTENT_TYPE}    User-Agent=${USER_AGENT}    Cookie=${session}
    ${data}=    json.loads    ${data['param']}
    ${resp}=    Post Request    demo    ${uri}    ${data}    \    ${headers}    timeout=${TIMEOUTL2}
    Log    ${resp}
    ${status}    ${resp_content}=    Run Keyword and Ignore Error    Evaluate    "${resp.json()}"
    Log    ${resp_content}
    [Return]    ${resp}

Post Request With Json
    [Arguments]    ${root}    ${uri}    ${data}
    Create Session    alias=test    url=${root}    disable_warnings=1
    ${headers}=    Create Dictionary    Content-Type=${CONTENT_TYPE}    User-Agent=${USER_AGENT}    accept=${ACCEPT}
    ${resp}=    Post Request    alias=test    uri=${uri}    data=${data}    headers=${headers}    timeout=${TIMEOUTL2}
    ${status}    ${resp_content}=    Run Keyword and Ignore Error    Evaluate    "${resp.json()}"
    Log    ${resp_content}
    [Return]    ${resp}

Get Request Pro
    [Arguments]    ${root}    ${uri}    @{form_data}
    Create Session    demo    ${root}    disable_warnings=1
    ${data}=    Create Dictionary    @{form_data}
    Comment    ${json_data}=    json.dumps    ${data}
    ${headers}=    Create Dictionary    &{HEADER}    User-Agent=${USER_AGENT}
    ${resp}=    Get Request    demo    ${uri}    ${headers}    ${data}    timeout=${TIMEOUT}
    Log    ${resp}
    ${status}    ${resp_content}=    Run Keyword and Ignore Error    Evaluate    "${resp.json()}".encode('utf-8').decode('unicode_escape')
    Log    ${resp_content}
    [Return]    ${resp}

Get Request with Cookie and Customized User-Agent
    [Arguments]    ${root}    ${uri}    ${cookies}    ${UserAgent}    @{form_data}
    Create Session    demo    ${root}    disable_warnings=1
    ${data}=    Create Dictionary    @{form_data}
    Comment    ${json_data}=    json.dumps    ${data}
    ${headers}=    Create Dictionary    &{HEADER}    Cookie=${cookies}    User-Agent=${UserAgent}
    ${resp}=    Get Request    demo    ${uri}    ${headers}    \    ${data}    timeout=${TIMEOUT}
    Log    ${resp}
    ${status}    ${resp_content}=    Run Keyword and Ignore Error    Evaluate    "${resp.json()}".encode('utf-8').decode('unicode_escape')
    Log    ${resp_content}
    [Return]    ${resp}

Post Request With File and Data
    [Arguments]    ${root}    ${uri}    ${cookies}    @{form_data}
    Create Session    demo    ${root}    disable_warnings=1
    &{files}=    Create_File_Dict    ${form_data[1]}
    ${data}=    Create Dictionary    @{form_data}
    ${headers}=    Create Dictionary    User-Agent=${USER_AGENT}    Cookie=${cookies}
    ${resp}=    Post Request    demo    ${uri}    ${data}    ${EMPTY}    ${headers}    files=${files}    timeout=${TIMEOUT}
    Log    ${resp}
    ${status}    ${resp_content}=    Run Keyword and Ignore Error    Evaluate    "${resp.json()}".encode('utf-8').decode('unicode_escape')
    Log    ${resp_content}
    [Return]    ${resp}

Post Request With Dict and Request Header Token Body Token
    [Arguments]    ${root}    ${uri}    ${cookie}    ${headerTokenname}    ${headerTokenvalue}    ${bodyTokenname}    ${bodyTokenvalue}    @{form_data}
    Create Session    demo    ${root}    disable_warnings=1
    &{data}=    Create Dictionary    @{form_data}
    ${bodyTokenname}=    Split String    ${bodyTokenname}    ,
    ${bodyTokenvalue}=    Split String    ${bodyTokenvalue}    ,
    &{token}=    Evaluate    dict(zip(${bodyTokenname}, ${bodyTokenvalue}))
    ${data}=    Create Dictionary    &{data}    &{token}
    ${headers}=    Create Dictionary    &{HEADER}    Content-Type=${CONTENT_TYPE}    User-Agent=${USER_AGENT}    ${headerTokenname}=${headerTokenvalue}    Cookie=${cookie}
    ${resp}=    Post Request    demo    ${uri}    ${data}    \    ${headers}    timeout=${TIMEOUT}
    Log    ${resp}
    ${status}    ${resp_content}=    Run Keyword and Ignore Error    Evaluate    "${resp.json()}".encode('utf-8').decode('unicode_escape')
    Log    ${resp_content}
    [Return]    ${resp}

Post Request With Dict and Request Header Token
    [Arguments]    ${root}    ${uri}    ${cookie}    ${headerTokenname}    ${headerTokenvalue}    @{form_data}
    Create Session    demo    ${root}    disable_warnings=1
    ${data}=    Create Dictionary    @{form_data}
    ${headers}=    Create Dictionary    &{HEADER}    Content-Type=${CONTENT_TYPE}    User-Agent=${USER_AGENT}    ${headerTokenname}=${headerTokenvalue}    Cookie=${cookie}
    ${resp}=    Post Request    demo    ${uri}    ${data}    \    ${headers}    timeout=${TIMEOUT}
    Log    ${resp}
    ${status}    ${resp_content}=    Run Keyword and Ignore Error    Evaluate    "${resp.json()}".encode('utf-8').decode('unicode_escape')
    Log    ${resp_content}
    [Return]    ${resp}

Post Request With Dict and Request Body Token
    [Arguments]    ${root}    ${uri}    ${cookie}    ${bodyTokenname}    ${bodyTokenvalue}    @{form_data}
    Create Session    demo    ${root}    disable_warnings=1
    &{data}=    Create Dictionary    @{form_data}
    ${bodyTokenname}=    Split String    ${bodyTokenname}    ,
    ${bodyTokenvalue}=    Split String    ${bodyTokenvalue}    ,
    &{token}=    Evaluate    dict(zip(${bodyTokenname}, ${bodyTokenvalue}))
    ${data}=    Create Dictionary    &{data}    &{token}
    ${headers}=    Create Dictionary    &{HEADER}    Content-Type=${CONTENT_TYPE}    User-Agent=${USER_AGENT}    Cookie=${cookie}
    ${resp}=    Post Request    demo    ${uri}    ${data}    \    ${headers}    timeout=${TIMEOUT}
    Log    ${resp}
    ${status}    ${resp_content}=    Run Keyword and Ignore Error    Evaluate    "${resp.json()}".encode('utf-8').decode('unicode_escape')
    Log    ${resp_content}
    [Return]    ${resp}

Get Request With Dict And Request Header Token Body Token
    [Arguments]    ${root}    ${uri}    ${cookie}    ${headerTokenname}    ${headerTokenvalue}    ${bodyTokenname}    ${bodyTokenvalue}    @{form_data}
    Create Session    demo    ${root}    disable_warnings=1
    &{data}=    Create Dictionary    @{form_data}
    ${bodyTokenname}=    Split String    ${bodyTokenname}    ,
    ${bodyTokenvalue}=    Split String    ${bodyTokenvalue}    ,
    &{token}=    Evaluate    dict(zip(${bodyTokenname}, ${bodyTokenvalue}))
    ${data}=    Create Dictionary    &{data}    &{token}
    ${headers}=    Create Dictionary    &{HEADER}    Content-Type=${CONTENT_TYPE}    User-Agent=${USER_AGENT}    ${headerTokenname}=${headerTokenvalue}    Cookie=${cookie}
    ${resp}=    Get Request    demo    ${uri}    ${headers}    \    ${data}    timeout=${TIMEOUT}
    Log    ${resp}
    ${status}    ${resp_content}=    Run Keyword and Ignore Error    Evaluate    "${resp.json()}".encode('utf-8').decode('unicode_escape')
    Log    ${resp_content}
    [Return]    ${resp}

Get Request With Dict and Request Header Token
    [Arguments]    ${root}    ${uri}    ${cookie}    ${headerTokenname}    ${headerTokenvalue}    @{form_data}
    Create Session    demo    ${root}    disable_warnings=1
    ${data}=    Create Dictionary    @{form_data}
    ${data}=    Set Variable    ${data['param']}
    Comment    ${param}=    Evaluate    urllib.parse.urlencode(${data})    urllib
    Comment    ${request_url}=    Set Variable    ${root}${uri}${param}
    ${data}=    json.loads    ${data}
    ${headers}=    Create Dictionary    &{HEADER}    Content-Type=${CONTENT_TYPE}    User-Agent=${USER_AGENT}    ${headerTokenname}=${headerTokenvalue}    Cookie=${cookie}
    ${resp}=    Get Request    demo    ${uri}    ${headers}    \    ${data}    timeout=${TIMEOUT}
    Log    ${resp}
    ${status}    ${resp_content}=    Run Keyword and Ignore Error    Evaluate    "${resp.json()}".encode('utf-8').decode('unicode_escape')
    Log    ${resp_content}
    [Return]    ${resp}

Get Request With Dict and Request Body Token
    [Arguments]    ${root}    ${uri}    ${cookie}    ${bodyTokenname}    ${bodyTokenvalue}    @{form_data}
    Create Session    demo    ${root}    disable_warnings=1
    &{data}=    Create Dictionary    @{form_data}
    ${bodyTokenname}=    Split String    ${bodyTokenname}    ,
    ${bodyTokenvalue}=    Split String    ${bodyTokenvalue}    ,
    &{token}=    Evaluate    dict(zip(${bodyTokenname}, ${bodyTokenvalue}))
    ${data}=    Create Dictionary    &{data}    &{token}
    ${headers}=    Create Dictionary    &{HEADER}    Content-Type=${CONTENT_TYPE}    User-Agent=${USER_AGENT}    Cookie=${cookie}
    ${resp}=    Get Request    demo    ${uri}    ${headers}    \    ${data}    timeout=${TIMEOUT}
    Log    ${resp}
    ${status}    ${resp_content}=    Run Keyword and Ignore Error    Evaluate    "${resp.json()}".encode('utf-8').decode('unicode_escape')
    Log    ${resp_content}
    [Return]    ${resp}

Post Request With Dict and Request Body Token Special
    [Arguments]    ${root}    ${uri}    ${cookie}    ${bodyTokenname}    ${bodyTokenvalue}    @{form_data}
    Create Session    demo    ${root}    disable_warnings=1
    ${params}=    Add_ApiKey_Params    ${bodyTokenname}    ${bodyTokenvalue}    ${form_data[1]}
    &{data}=    Create Dictionary    ${form_data[0]}    ${params}
    ${headers}=    Create Dictionary    &{HEADER}    Content-Type=${CONTENT_TYPE}    User-Agent=${USER_AGENT}    Cookie=${cookie}
    ${resp}=    Post Request    demo    ${uri}    ${data}    \    ${headers}    timeout=${TIMEOUT}
    Log    ${resp}
    ${status}    ${resp_content}=    Run Keyword and Ignore Error    Evaluate    "${resp.json()}".encode('utf-8').decode('unicode_escape')
    Log    ${resp_content}
    [Return]    ${resp}

Post Request With File and Dict and Request Header Token Body Token
    [Arguments]    ${root}    ${uri}    ${cookie}    ${headerTokenname}    ${headerTokenvalue}    ${bodyTokenname}    ${bodyTokenvalue}    @{form_data}
    Create Session    demo    ${root}    disable_warnings=1
    &{files}=    Create_File_Dict    ${form_data[1]}
    &{data}=    Create Dictionary    @{form_data}
    ${bodyTokenname}=    Split String    ${bodyTokenname}    ,
    ${bodyTokenvalue}=    Split String    ${bodyTokenvalue}    ,
    &{token}=    Evaluate    dict(zip(${bodyTokenname}, ${bodyTokenvalue}))
    ${data}=    Create Dictionary    &{data}    &{token}
    ${headers}=    Create Dictionary    User-Agent=${USER_AGENT}    ${headerTokenname}=${headerTokenvalue}    Cookie=${cookie}
    ${resp}=    Post Request    demo    ${uri}    ${data}    ${EMPTY}    ${headers}    files=${files}    timeout=${TIMEOUT}
    Log    ${resp}
    ${status}    ${resp_content}=    Run Keyword and Ignore Error    Evaluate    "${resp.json()}".encode('utf-8').decode('unicode_escape')
    Log    ${resp_content}
    [Return]    ${resp}

Post Request With File and Dict and Request Header Token
    [Arguments]    ${root}    ${uri}    ${cookie}    ${headerTokenname}    ${headerTokenvalue}    @{form_data}
    Create Session    demo    ${root}    disable_warnings=1
    &{files}=    Create_File_Dict    ${form_data[1]}
    ${data}=    Create Dictionary    @{form_data}
    ${headers}=    Create Dictionary    User-Agent=${USER_AGENT}    ${headerTokenname}=${headerTokenvalue}    Cookie=${cookie}
    ${resp}=    Post Request    demo    ${uri}    ${data}    ${EMPTY}    ${headers}    files=${files}    timeout=${TIMEOUT}
    Log    ${resp}
    ${status}    ${resp_content}=    Run Keyword and Ignore Error    Evaluate    "${resp.json()}".encode('utf-8').decode('unicode_escape')
    Log    ${resp_content}
    [Return]    ${resp}

Post Request With File and Dict and Request Body Token
    [Arguments]    ${root}    ${uri}    ${cookie}    ${bodyTokenname}    ${bodyTokenvalue}    @{form_data}
    Create Session    demo    ${root}    disable_warnings=1
    &{files}=    Create_File_Dict    ${form_data[1]}
    &{data}=    Create Dictionary    @{form_data}
    ${bodyTokenname}=    Split String    ${bodyTokenname}    ,
    ${bodyTokenvalue}=    Split String    ${bodyTokenvalue}    ,
    &{token}=    Evaluate    dict(zip(${bodyTokenname}, ${bodyTokenvalue}))
    ${data}=    Create Dictionary    &{data}    &{token}
    ${headers}=    Create Dictionary    User-Agent=${USER_AGENT}    Cookie=${cookie}
    ${resp}=    Post Request    demo    ${uri}    ${data}    ${EMPTY}    ${headers}    files=${files}    timeout=${TIMEOUT}
    Log    ${resp}
    ${status}    ${resp_content}=    Run Keyword and Ignore Error    Evaluate    "${resp.json()}".encode('utf-8').decode('unicode_escape')
    Log    ${resp_content}
    [Return]    ${resp}

Post Request With Json and Request Header Token
    [Arguments]    ${root}    ${uri}    ${cookie}    ${headerTokenname}    ${headerTokenvalue}    @{form_data}
    Create Session    demo    ${root}    disable_warnings=1
    ${data}=    Create Dictionary    @{form_data}
    ${headers}=    Create Dictionary    &{HEADER}    Content-Type=${CONTENT_TYPE}    User-Agent=${USER_AGENT}    ${headerTokenname}=${headerTokenvalue}    Cookie=${cookie}
    ${data}=    json.loads    ${data['param']}
    ${resp}=    Post Request    demo    ${uri}    ${data}    \    ${headers}
    Log    ${resp}
    ${status}    ${resp_content}=    Run Keyword and Ignore Error    Evaluate    "${resp.json()}".encode('utf-8').decode('unicode_escape')
    Log    ${resp_content}
    [Return]    ${resp}

Delete Request With Request Header Token
    [Arguments]    ${root}    ${uri}    ${cookie}    ${headerTokenname}    ${headerTokenvalue}
    Create Session    demo    ${root}    disable_warnings=1
    ${headers}=    Create Dictionary    &{HEADER}    Content-Type=${CONTENT_TYPE}    User-Agent=${USER_AGENT}    ${headerTokenname}=${headerTokenvalue}    Cookie=${cookie}
    ${resp}=    Delete Request    demo    ${uri}    \    \    ${headers}
    Log    ${resp}
    ${status}    ${resp_content}=    Run Keyword and Ignore Error    Evaluate    "${resp.json()}".encode('utf-8').decode('unicode_escape')
    Log    ${resp_content}
    [Return]    ${resp}

Delete Request with Cookie
    [Arguments]    ${root}    ${uri}    ${cookies}    ${param}
    Create Session    alias=test    url=${root}    disable_warnings=1
    ${headers}=    Create Dictionary    Cookie=${cookies}    User-Agent=${USER_AGENT}    accept=${ACCEPT}
    ${param}=    json.loads    ${param}
    ${resp}=    Delete Request    alias=test    uri=${uri}    headers=${headers}    params=${param}    timeout=${TIMEOUTL2}
    ${status}    ${resp_content}=    Run Keyword and Ignore Error    Evaluate    "${resp.json()}"
    Log    ${resp_content}
    [Return]    ${resp}

Put Request With Auth Param Data
    [Arguments]    ${root}    ${uri}    ${auth}    ${param}    ${data}
    Create Session    alias=test    url=${root}    disable_warnings=1
    ${headers}=    Create Dictionary    Authorization=Bearer ${auth}    Content-Type=${CONTENT_TYPE}    User-Agent=${USER_AGENT}    accept=${ACCEPT}
    ${param}=    json.loads    ${param}
    ${resp}=    Put Request    alias=test    uri=${uri}    headers=${headers}    params=${param}    data=${data}    timeout=${TIMEOUTL2}
    ${status}    ${resp_content}=    Run Keyword and Ignore Error    Evaluate    "${resp.json()}".encode('utf-8').decode('unicode_escape')
    Log    ${resp_content}
    [Return]    ${resp}

Put Request With Json
    [Arguments]    ${root}    ${uri}    @{data}
    Create Session    alias=test    url=${root}    disable_warnings=1
    ${headers}=    Create Dictionary    Content-Type=${CONTENT_TYPE}    User-Agent=${USER_AGENT}    accept=${ACCEPT}
    ${resp}=    Put Request    alias=test    uri=${uri}    data=${data}    headers=${headers}
    ${status}    ${resp_content}=    Run Keyword and Ignore Error    Evaluate    "${resp.json()}".encode('utf-8').decode('unicode_escape')
    Log    ${resp_content}

Post Request With Cookie Param Data
    [Arguments]    ${root}    ${uri}    ${auth}    ${param}    ${data}
    Create Session    alias=test    url=${root}    disable_warnings=1
    ${headers}=    Create Dictionary    Authorization=Bearer ${auth}    Content-Type=${CONTENT_TYPE}    User-Agent=${USER_AGENT}    accept=${ACCEPT}
    ${param}=    json.loads    ${param}
    ${resp}=    Post Request    alias=test    uri=${uri}    headers=${headers}    params=${param}    data=${data}    timeout=${TIMEOUT}
    ${status}    ${resp_content}=    Run Keyword and Ignore Error    Evaluate    "${resp.json()}".encode('utf-8').decode('unicode_escape')
    Log    ${resp_content}
    [Return]    ${resp}

Delete Request with Cookie Param
    [Arguments]    ${root}    ${uri}    ${cookies}    ${param}
    Create Session    alias=test    url=${root}
    ${headers}=    Create Dictionary    Content-Type=${CONTENT_TYPE}    Cookie=${cookies}    User-Agent=${USER_AGENT}    accept=${ACCEPT}
    ${param}=    json.loads    ${param}
    ${resp}=    Delete Request    alias=test    uri=${uri}    headers=${headers}    timeout=${TIMEOUT}    params=${param}
    Log    ${resp}
    ${status}    ${resp_content}=    Run Keyword and Ignore Error    Evaluate    "${resp.json()}".encode('utf-8').decode('unicode_escape')
    Log    ${resp_content}
    [Return]    ${resp}

Post Request With Param Data
    [Arguments]    ${root}    ${uri}    ${param}    ${data}
    Create Session    alias=test    url=${root}    disable_warnings=1
    ${headers}=    Create Dictionary    Content-Type=${CONTENT_TYPE}    User-Agent=${USER_AGENT}    accept=${ACCEPT}
    ${param}=    json.loads    ${param}
    ${resp}=    Post Request    alias=test    uri=${uri}    headers=${headers}    params=${param}    data=${data}    timeout=${TIMEOUT}
    ${status}    ${resp_content}=    Run Keyword and Ignore Error    Evaluate    "${resp.json()}".encode('utf-8').decode('unicode_escape')
    Log    ${resp_content}
    [Return]    ${resp}
