*** Settings ***
Documentation     Utils Keywords
Library           Collections
Library           RequestsLibrary
Library           json
Library           String
Library           DateTime
Resource          common_resource.robot
Resource          global_resource.robot
Library           DatabaseLibrary

*** Keywords ***
MakeID
    [Documentation]    random ID
    ${yyyy}    ${mm}    ${dd}    ${hh}    ${min}    ${ss}=    Get Time    year,month,day,hour, min, sec
    ${rand}=    Generate Random String    3    [NUMBERS]
    ${id}=    Set Variable    ${yyyy}${mm}${dd}${hh}${rand}
    [Return]    ${id}

MakeCID
    ${yyyy}    ${mm}    ${dd}    ${hh}    ${min}    ${ss}=    Get Time    year,month,day,hour, min, sec
    ${rand}=    Generate Random String    5    [NUMBERS]
    ${cid}=    Set Variable    ${yyyy}${mm}${dd}${hh}${min}${ss}${rand}
    [Return]    ${cid}

Currency Format
    [Arguments]    ${value}
    [Documentation]    Currency Format
    ${locale}=    Evaluate    locale.setlocale( locale.LC_ALL, '' )    locale
    ${format_value}=    Evaluate    locale.currency(${value}, grouping=True)    locale
    ${ignore_first}=    Get Substring    ${format_value}    1
    [Return]    ${ignore_first}

Generate Email
    ${yyyy}    ${mm}    ${dd}    ${hh}    ${min}    ${ss}=    Get Time    year,month,day,hour, min, sec
    ${rand}=    Generate Random String    3    [NUMBERS]
    ${email}=    Set Variable    apitest${yyyy}${mm}${dd}${hh}${min}${ss}${rand}@qq.com
    [Return]    ${email}

Get List From Api
    [Arguments]    ${resp}    ${seq}    ${element_name}
    ${alist}    Create List
    ${len}=    Get Length    ${resp[${${seq}}]}
    FOR    ${INDEX}    IN RANGE    0    ${len}
    ${el}=    Convert To String    ${resp[${${seq}}][${INDEX}]['${element_name}']}
    Append To List    ${alist}    ${el}
    [Return]    ${alist}

Get List From DB
    [Arguments]    ${query_result}
    ${alist}    Create List
    FOR    ${el}    IN    @{query_result}
    Append To List    ${alist}    ${el[0]}
    [Return]    ${alist}

Compare DB with API
    [Arguments]    ${resp}    ${seq}    ${element_name}    ${dbname}    ${sql}
    ${list_api}=    Get List From Api    ${resp}    ${seq}    ${element_name}
    ${query_result}=    Get Data By SQL Query    ${dbname}    ${sql}
    ${list_db}=    Get List From DB    ${query_result}
    Lists Should Be Equal    ${list_db}    ${list_api}

Compare DB with API Contains
    [Arguments]    ${resp}    ${seq}    ${element_name}    ${dbname}    ${sql}
    ${list_api}=    Get List From Api    ${resp}    ${seq}    ${element_name}
    ${query_result}=    Get Data By SQL Query    ${dbname}    ${sql}
    ${list_db}=    Get List From DB    ${query_result}
    List Should Contain Sub List    ${list_db}    ${list_api}

Connect To DB
    [Arguments]    ${DBTEPY}    ${DBNAME}    ${DBUSERNAME}    ${DBPASSWORD}    ${DBHOST}    ${DBPORT}
    [Documentation]    A basic Keyword for DB connection
    Connect To Database Using Custom Params    ${DBTEPY}    database='${DBNAME}', user='${DBUSERNAME}', password='${DBPASSWORD}', host='${DBHOST}', port=${DBPORT}, ssl={"any_non_empty_dict": True}

Get Data By SQL Query
    [Arguments]    ${dbname}    ${sql}
    Connect To DB    ${DBTEPY}    ${dbname}    ${DBUSERNAME}    ${DBPASSWORD}    ${DBHOST}    ${DBPORT}
    ${queryReasults}=    query    ${sql}
    [Teardown]    Disconnect From Database
    [Return]    ${queryReasults}

Add_ApiKey_Params
    [Arguments]    ${bodyTokenname}    ${bodyTokenvalue}    ${params}
    ${params}=    Evaluate    ${params}
    Set To Dictionary    ${params}    ${bodyTokenname}    ${bodyTokenvalue}
    ${params}=    json.dumps    ${params}
    [Return]    ${params}

Create_File_Dict
    [Arguments]    ${file_dict}
    &{file_dict}=    json.loads    ${file_dict}
    ${files}=    Create Dictionary
    FOR    ${file_param}    IN    @{file_dict.keys()}
    ${test_suite_dir}=    Evaluate    os.path.dirname('${SUITE SOURCE}')    modules=os
    ${filename}=    Get From Dictionary    ${file_dict}    ${file_param}
    ${path}    ${ext}=    Split Extension    ${filename}
    ${file_data}=    Evaluate    ('${filename}',open(r'${filename}','rb'),'image/${ext}')    #('${filename}',open(r'${test_suite_dir}/${filename}','rb'),'image/${ext}')
    Set To Dictionary    ${files}    ${file_param}=${file_data}
    [Return]    &{files}

Generate Phone
    ${phone}=    Generate Random String    11    [NUMBERS]
    [Return]    ${phone}

Clean Testdata From Database
    [Arguments]    ${sql}
    Connect To Database    MySQLdb    ${DB_NAME}    ${DB_ACCOUNT}    \    ${DB_IP}    ${DB_PORT}
    Execute Sql String    ${sql}    #delete from commonauth_sign where userinfo_id=${id} order by id desc limit 1;

Set Random Value To Json Key
    [Arguments]    ${data}    ${key}
    ${data}=    json.loads    ${data}
    ${str}=    Generate Random String    5    [LOWER]
    Set To Dictionary    ${data}    ${key}    ${data['name']}${str}
    [Return]    ${data}

Replace Variable With Random Value
    [Arguments]    ${data}    ${variablename}
    ${temp}=    Generate Random String    5    [LOWER]
    ${data}=    Replace String Using Regexp    ${data}    ${variablename}    ${temp}
    [Return]    ${data}    ${temp}

Replace Variable With Specific Value
    [Arguments]    ${data}    ${variablename}    ${value}
    ${data}=    Replace String Using Regexp    ${data}    ${variablename}    ${value}
    [Return]    ${data}

Get Current Time Stamp
    ${time}=    Get Time    epoch
    ${time}=    Set Variable    ${time}000
    [Return]    ${time}

Get One Month Later Time Stamp
    ${time}=    Get Time    epoch    UTC + 30 days
    ${time}=    Set Variable    ${time}000
    [Return]    ${time}

Request Until Reponse Success
    [Arguments]    ${condition}    ${retry}    ${interval}    ${api_request_keyword}    @{restarg}
    ${retry}    Convert To Integer    ${retry}
    FOR    ${var}    IN RANGE    1    ${retry+1}
        ${resp}=    Run Keyword    ${api_request_keyword}    @{restarg}
        Exit For Loop If    ${condition}
        Sleep    ${interval}
    END
    [Return]    ${resp}
