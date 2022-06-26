*** Settings ***
Suite Teardown    Close All Browsers
Force Tags        stage
Resource          ../Lib/all_resources.robot
Library           SeleniumLibrary

*** Test Cases ***
book_tennis
    [Template]    book_tennis_template
    数据    ${STARTTIME}    ${ENDTIME}    0040250539    19781216    jingghster@gmail.com
    [Teardown]

*** Keywords ***
book_tennis_template
    [Arguments]    ${log}    ${starttime}    ${endtime}    ${citicard}    ${dob}    ${email}
    init_test
    ${today}=    Get Time    day
    ${today}=    Convert To Integer    ${today}
    ${aftertomorrow}=    Get Time    day    NOW + 36h
    ${aftertomorrow}=    Convert To Integer    ${aftertomorrow}
    Wait And Run Keyword    Click Element    //*[@id="ctlBlocRecherche_ctlPeriodes_ctlSelectionDates_ctlCalendrier_Top"]//*[text()='${today}']
    Wait And Run Keyword    Click Element    //*[@id="ctlBlocRecherche_ctlPeriodes_ctlSelectionDates_ctlCalendrier_Top"]//*[text()='${aftertomorrow}']
    Wait And Run Keyword    Input Text    //*[@id="ctlBlocRecherche_ctlPeriodes_ctlSelectionHeures_ctlDebut_dateInput_text"]    ${starttime}
    Wait And Run Keyword    Input Text    //*[@id="ctlBlocRecherche_ctlPeriodes_ctlSelectionHeures_ctlFin_dateInput_text"]    ${endtime}
    Wait And Run Keyword    Click Element    //*[@id="ctlBlocRecherche_ctlRestrictions_ctlSelTypeEspace_ctlListe_ctl06_ctlLigne_ctlSelection"]
    Sleep    2
    Wait And Run Keyword    Click Element    //*[@name="ctlBlocRecherche$ctlPeriodes$ctlRechercher"]
    ${height}=    Execute Javascript    return document.body.scrollHeight
    Set Window Size    1920    ${height}
    Capture Page Screenshot
    Wait And Run Keyword    Click Element    //*[@id="ctlGrille_ctlGrilleEspace_ctlListeEspaces_ctl01_ctlLigneEspace_ctlSelectionPanier_ctlImageButtonSelecteur"]
    Sleep    2
    Wait And Run Keyword    Click Element    //*[@id="ctlGrille_ctlMenuActionsHaut_ctlAppelPanierIdent"]
    Wait And Run Keyword    Input Text    //*[@id="ctlPanierEspaces_ctlEspaces_ctl00_ctlRow_ctlListeIdentification_ctlListe_itm0_ctlBloc_ctlDossier"]    ${citicard}
    Wait And Run Keyword    Input Text    //*[@id="ctlPanierEspaces_ctlEspaces_ctl00_ctlRow_ctlListeIdentification_ctlListe_itm0_ctlBloc_ctlNip"]    ${dob}
    Wait And Run Keyword    Click Element    //*[@id="ctlMenuActionsHaut_ctlAppelPanierConfirm"]
    Wait Until Page Contains Element    //*[@id="panierDelais"]
    Sleep    2
    Wait And Run Keyword    Click Element    //*[@id="ctlMenuActionsHaut_ctlAppelPanierConfirm"]
    Wait And Run Keyword    Click Element    //*[@id="ctlConditions_ctlCheckPaiementElec"]
    Wait And Run Keyword    Input Text    //*[@id="ctlConditions_ctlCourriel"]    ${email}
    Wait And Run Keyword    Click Element    //*[@id="ctlMenuActionBas_ctlCompleterGratuit"]
    Wait And Run Keyword    Click Element    //*[@id="ctlConditions_ctlCheckLoc"]
    Wait And Run Keyword    Click Element    //*[@id="ctlConditions_ctlCheckPaiementElec"]
    Wait And Run Keyword    Click Element    //*[@id="ctlMenuActionBas_ctlCompleterGratuit"]
    Wait And Run Keyword    Click Element    //*[@id="ctlFormulaireCourriel_ctlSelection"]
    Wait And Run Keyword    Input Text    //*[@id="ctlFormulaireCourriel_ctlAdresse"]    ${email}
    Sleep    2
    Wait And Run Keyword    Click Element    //*[@id="ctlFormulaireCourriel_ctlEnvoyer"]
    Sleep    5
    [Teardown]    Close Browser

init_test
    Comment    Set Device    ${DEVICE}
    Go To    ${WEB_ROOT}/Brossard-LudikIC2Prod_Enligne/Pages/Anonyme/Recherche/Page.fr.aspx?m=5
    Wait And Run Keyword    Click Element    //*[@id="ctlHautPage_ctlMenu_ctlLienEspaces"]
