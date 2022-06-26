*** Settings ***
Documentation     Global Varible
Resource          common_resource.robot

*** Variables ***
${PROTOCOL}       https    # https
${DOMAIN}         ludik.maville.net    # grafana.geekplus.cc
${USERNAME}       guanhua.jing    # jingguanhua@geekplus.com
${PASSWORD}       jing7811    # IDontknow123!
${APP_API_ROOT_URL}    ${PROTOCOL}://${DOMAIN}
${DIR}            .
${TIME2LOADING}    30
${DBTEPY}         pymysql
${DBNAME}         jiangziya
${DBUSERNAME}     grafana
${DBPASSWORD}     Geekplus@2019
${DBHOST}         am-uf6nnw3xl77u4h9d190650.ads.aliyuncs.com
${DBPORT}         3306
${ENDTIME}        20:59
${STARTTIME}      20:01
