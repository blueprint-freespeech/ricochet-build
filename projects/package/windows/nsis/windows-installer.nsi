# Expects MUI_VERSION to be defined on the command line

!pragma warning error all

; -------------------------------------
; Modern UI
    !include "MUI2.nsh"

; -------------------------------------
; Defines

    !define MUI_PRODUCT "Ricochet Refresh"
    !define MUI_BRANDINGTEXT "${MUI_PRODUCT} v${MUI_VERSION}"
    !define MUI_FILE "ricochet-refresh"

    ; todo: translations for these
    !define MUI_FINISHPAGE_RUN
    !define MUI_FINISHPAGE_RUN_TEXT "Create desktop shortcut"
    !define MUI_FINISHPAGE_RUN_FUNCTION "installDesktopShortcut"
    
    !define MUI_FINISHPAGE_SHOWREADME
    !define MUI_FINISHPAGE_SHOWREADME_TEXT "Create start menu shortcut"
    !define MUI_FINISHPAGE_SHOWREADME_FUNCTION "installStartMenuShortcut"

    !define MUI_ICON "icon.ico"

; -------------------------------------
; General
    ; For translation support
    Unicode true

    ; When we install, a date is freshly generated
    SetDateSave off

    Name "${MUI_PRODUCT}"
    InstallDir "$PROGRAMFILES\${MUI_PRODUCT}"

    OutFile "ricochet-refresh-installer.exe"

    ShowInstDetails show
    ShowUninstDetails show

    RequestExecutionLevel admin

    LicenseData "LICENSE"

; -------------------------------------
; Interface
    !define MUI_ABORTWARNING

; -------------------------------------
; Language Dialogue
    !define MUI_LANGDLL_ALLLANGUAGES

; -------------------------------------
; Pages
    !insertmacro MUI_PAGE_WELCOME
    !insertmacro MUI_PAGE_LICENSE "LICENSE"
    !insertmacro MUI_PAGE_DIRECTORY
    !insertmacro MUI_PAGE_INSTFILES
    !insertmacro MUI_PAGE_FINISH
    
    !insertmacro MUI_UNPAGE_WELCOME
    !insertmacro MUI_UNPAGE_CONFIRM
    !insertmacro MUI_UNPAGE_INSTFILES
    !insertmacro MUI_UNPAGE_FINISH

; -------------------------------------
; Languages
    ; this is the same order as found in src/tego_ui/translation/embedded.qrc
    ; the installer *can* support more languages, but it wouldn't be very nice
    ; if you installed ricochet thinking it supported your language since the
    ; installer did, just to find out it didn't after the fact
    !insertmacro MUI_LANGUAGE "English"
    !insertmacro MUI_LANGUAGE "Italian"
    !insertmacro MUI_LANGUAGE "Spanish"
    !insertmacro MUI_LANGUAGE "Danish"
    !insertmacro MUI_LANGUAGE "PortugueseBR"
    !insertmacro MUI_LANGUAGE "German"
    !insertmacro MUI_LANGUAGE "Bulgarian"
    !insertmacro MUI_LANGUAGE "Czech"
    !insertmacro MUI_LANGUAGE "Finnish"
    !insertmacro MUI_LANGUAGE "French"
    !insertmacro MUI_LANGUAGE "Russian"
    !insertmacro MUI_LANGUAGE "Ukrainian"
    !insertmacro MUI_LANGUAGE "Turkish"
    !insertmacro MUI_LANGUAGE "Dutch"
    ; !insertmacro MUI_LANGUAGE "" Filipino not supported by nsis :/
    !insertmacro MUI_LANGUAGE "Swedish"
    !insertmacro MUI_LANGUAGE "Polish"
    !insertmacro MUI_LANGUAGE "Hebrew"
    !insertmacro MUI_LANGUAGE "Slovenian"
    !insertmacro MUI_LANGUAGE "SimpChinese"
    !insertmacro MUI_LANGUAGE "Estonian"
    ; !insertmacro MUI_LANGUAGE "Italian" # Duplicate: we support it and it_IT
    !insertmacro MUI_LANGUAGE "Norwegian"
    !insertmacro MUI_LANGUAGE "Portuguese"
    !insertmacro MUI_LANGUAGE "Albanian"
    ; !insertmacro MUI_LANGUAGE "" # HK Chinese is not supported by nsis :/
    !insertmacro MUI_LANGUAGE "Japanese"

; -------------------------------------
; Installer
    Section "install"
        SetOutPath "$INSTDIR"

        ; Files we want to install
        File ricochet-refresh.exe
        File tor.exe
        File /r pluggable_transports

        ; Create the uninstaller
        WriteUninstaller "$INSTDIR\Uninstall Ricochet Refresh.exe"

        ; Update registry with uninstall info
        WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${MUI_PRODUCT}" "DisplayName" "${MUI_PRODUCT}"
        WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${MUI_PRODUCT}" "UninstallString" "$INSTDIR\Uninstall Ricochet Refresh.exe"
    SectionEnd

; -------------------------------------    
; Uninstaller   
    Section "uninstall"
        ; Remove install files
        RMDir /r "$INSTDIR"
        
        ; Remove shortcuts
        RmDir /r "$SMPROGRAMS\${MUI_PRODUCT}"
        Delete   "$DESKTOP\${MUI_PRODUCT}.lnk"
        
        ; Remove uninstall info from the registry
        DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\${MUI_PRODUCT}"
        DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${MUI_PRODUCT}"
    SectionEnd

; -------------------------------------
; Functions
    Function .onInit
        !insertmacro MUI_LANGDLL_DISPLAY
    FunctionEnd

    Function installDesktopShortcut
        ; Desktop shortcut
        CreateShortCut "$DESKTOP\${MUI_PRODUCT}.lnk" "$INSTDIR\${MUI_FILE}.exe" ""
    FunctionEnd

    Function installStartMenuShortcut
        ; Start menu shortcut
        CreateDirectory "$SMPROGRAMS\${MUI_PRODUCT}"
        CreateShortCut  "$SMPROGRAMS\${MUI_PRODUCT}\Uninstall.lnk" "$INSTDIR\Uninstall Ricochet Refresh" "" "$INSTDIR\Uninstall Ricochet Refresh" 0
        CreateShortCut  "$SMPROGRAMS\${MUI_PRODUCT}\${MUI_PRODUCT}.lnk" "$INSTDIR\${MUI_FILE}.exe" "" "$INSTDIR\${MUI_FILE}.exe" 0
    FunctionEnd
    
