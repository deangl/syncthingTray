#include JSON.ahk
#SingleInstance, force

global consoleUrl
consoleUrl = http://127.0.0.1:8384

global configFile
configFile = %LocalAppData%/Syncthing/config.xml


global x
x := ComObjCreate("WinHttp.WinHttpRequest.5.1")

global lastNew
lastNew := {}

global checkInterval
checkInterval := 2000

global apiKey


getconfig()
getapiKey()
keepOpen()


#Persistent


Menu, Tray, NoStandard
menu, Tray, add, �򿪿���
Menu, Tray, add, ����
Menu, Tray, add, �ر�
Menu, Tray, add, checkNew
Menu, Tray, add, closeTayOnly
Menu, Tray, Default, �򿪿���

Loop{
        Sleep checkInterval
        keepOpen()
        f_checkNew()
}
Return




closeTayOnly:
        ExitApp

keepOpen(){
        Process, Exist, syncthing.exe
        status = %ErrorLevel% 
        if (status == 0 )
        {
        run syncthing.exe -no-console -no-browser
        ; run syncthing.bat
        trayTip, ,����Syncthing
        }
        return
}

�򿪿���:
        Run, % consoleUrl
        return

�ر�:
        closeUrl := consoleUrl . "/rest/system/shutdown"
        x.Open("POST", closeUrl, true)
        x.setRequestHeader("X-API-Key",apiKey)
        x.Send()
        x.WaitForResponse()
        msgbox Syncthing�ѹر�
        ExitApp
        return

����:
        closeUrl := consoleUrl . "/rest/system/restart"
        x.Open("POST", closeUrl, true)
        x.setRequestHeader("X-API-Key",apiKey)
        x.Send()
        x.WaitForResponse()
        backBody := x.ResponseText
        msgbox % backBody
        return
        

GetStatus(){
        try {
                folderUrl := consoleUrl . "/rest/stats/folder"
                x.Open("GET", folderUrl, true)
                x.setRequestHeader("X-API-Key",apiKey)
                x.Send()
                x.WaitForResponse()
        }
        catch{
                trayTip �ȴ�Syncthing waiting....
                return ""
        }
        backBody := x.ResponseText
        return backBody
}



f_checkNew(){
        backBody := GetStatus()
        statusObj := JSON.Load(backBody)
        rsltMsg := ""
        for index, files in statusObj
        {
                if(files.lastFile.at != lastNew[index]){
                        lastNew[index] := files.lastFile.at
                rsltMsg := rsltMsg . index . ":" . files.lastFile.filename . "`n"
                }
        }
        if (StrLen(rsltMsg) > 0){
                trayTip, �������, %rsltMsg% 
        }
        return
}

checkNew:
        f_checkNew()
        return

getapiKey(){
        FileRead, xmldata, %configFile%
        apiKey := StrSplit(xmldata,"<apikey>")[2]
        apiKey := StrSplit(apiKey, "</apikey>")[1]
        ;doc := ComObjCreate("MSXML2.DOMDocument.6.0")
        ;doc.setProperty("SelectionNamespaces", "xmlns:bk='urn:books'")
        ;doc.async := false
        ;doc.loadXML(xmldata)
        ;DocNode := doc.selectSingleNode("/configuration/gui/apikey")
        ;apiKey := DocNode.text
}

getconfig(){
        fileRead, confstr, _trayconf.json
        conf := JSON.load(confstr)
        for key,val in conf
        {
                %key% := val
        }
}