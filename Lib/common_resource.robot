*** Settings ***
Documentation     Global Varible
Resource          global_resource.robot

*** Variables ***
${TIMEOUTL1}      5
${TIMEOUTL2}      60
${TIMEOUTL3}      60
${BROWSER}        gc    # headlesschrome
${USER_AGENT}     PostmanRuntime/7.15.2    # USER_AGENT
${ACCEPT}         application/json
${CONTENT_TYPE}    application/json    # CONTENT_TYPE
${WEB_ROOT}       ${PROTOCOL}://${DOMAIN}
${DEVICE}         desktop1920x1024    # ipadpro, ipad, iphone, desktop
${DEVICETYPE}     desktop    # mobile, desktop
${DISABLEIMAGE}    false
