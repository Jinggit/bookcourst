*** Settings ***
Suite Setup       Prepare DesireCaps    ${DEVICE}    # Prepare DesireCaps
Suite Teardown    Close All Browsers
Resource          Lib/all_resources.robot
Library           SeleniumLibrary
