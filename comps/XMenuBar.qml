import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Dialogs 1.1
import "../Funcs.js" as JS

MenuBar{
    visible: apps.showMenuBar
    Menu {
        title: qsTr("&Archivo")
        Action { text: qsTr("&Nuevo"); onTriggered: panelNewVNA.state='show'}
        Action { text: qsTr("&Abrir"); onTriggered: panelFileLoader.state='show' }
        Action {enabled: app.fileData!==app.currentData; text: qsTr("&Guardar"); onTriggered: JS.saveJson() }
        //Action { text: qsTr("Save &As...") }
        MenuSeparator { }
        Action { text: qsTr("&Salir"); onTriggered: Qt.quit() }
    }
    Menu {
        title: qsTr("&Ver")
        Action { text: qsTr("&Panel Zoom"); onTriggered: apps.showSWEZ=!apps.showSWEZ; checkable: true; checked: apps.showSWEZ}
        Action { text: qsTr("&Fondo Color de Rueda Zoodiacal"); onTriggered: apps.enableBackgroundColor=!apps.enableBackgroundColor; checkable: true; checked: apps.enableBackgroundColor}
        Action { text: qsTr("&Definir Color de Fondo"); onTriggered: defColor('backgroundColor')}
        Action { text: qsTr("&Definir Color de Texto"); onTriggered: defColor('fontColor')}
        Action { text: qsTr("&Decanatos"); onTriggered: apps.showDec=!apps.showDec; checkable: true; checked: apps.showDec}
    }
    Menu {
        title: qsTr("&Ayuda")
        Action { text: qsTr("&Sobre AstroLógica");onTriggered: mdSA.visible=true}
        Action { text: qsTr("&Sobre Qt");onTriggered: mdSQ.visible=true}
    }
    MessageDialog {
        id: mdSA
        title: "Sobre AstroLógica"
        width: app.fs*10
        standardButtons:  StandardButton.Close
        icon: StandardIcon.Information
        text: "<b>AstroLógica v0.1</b>"
        informativeText: "Esta aplicación fue desarrollada por Ricardo Martín Pizarro.\nJunio 2021 Buenos Aires Argentina\nPara más información: nextsigner@gmail.com\nFue creada con el Framework Qt Open Source 5.15.2"
        onAccepted: {
            close()
        }
    }
    MessageDialog {
        id: mdSQ
        title: "Sobre Qt"
        width: app.fs*10
        standardButtons:  StandardButton.Close
        icon: StandardIcon.Information
        text: "Qt Open Source"
        informativeText:"Qt es la forma más rápida e inteligente de producir software líder en la industria que encanta a los usuarios.\nEl framework Qt tiene licencia doble, disponible tanto con licencias comerciales como de código abierto . La licencia comercial es la opción recomendada para proyectos que no son de código abierto.\nPara más información: https://qt.io/"
        onAccepted: {
            close()
        }
    }
    function defColor(object){
        xSelectColor.visible=true
        xSelectColor.c=object
    }
}
