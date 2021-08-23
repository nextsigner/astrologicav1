import QtQuick 2.7
import QtQuick.Controls 2.0
import Qt.labs.folderlistmodel 2.12
import "comps" as Comps
import "Funcs.js" as JS
Rectangle {
    id: r
    width: parent.width
    height: parent.height*0.5
    color: 'black'
    border.width: 2
    border.color: 'white'
    x:0-r.width
    anchors.bottom: parent.bottom

    state: 'hide'
    states: [
        State {
            name: "show"
            PropertyChanges {
                target: r
                x:0
            }
        },
        State {
            name: "hide"
            PropertyChanges {
                target: r
                x:0-r.width
            }
        }
    ]
    Behavior on x{enabled: app.enableAn;NumberAnimation{duration: app.msDesDuration}}

    Column{
        anchors.centerIn: parent
        spacing: app.fs*0.25
        Button{
            id: bot
            text: 'Recargar Panel Remoto'
            visible: false
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: JS.showMsgDialog('Error! - Zool Informa', 'Problemas de conexión a internet', 'No hay buena conexión de internet.\n\nEl panel remoto lateral de la izquierda será desactivado.\n\nIntenta más tarde.\n\nPor alguna razón, la aplicación no está pudiendo acceder a internet para obtener los datos requeridos. Error: '+data)

        }
        Button{
            id: bot2
            text: 'Cerrar Panel Remoto'
            visible: bot.visible
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: r.state='hide'
        }

    }
    Timer{
        running: true
        repeat: false
        interval: 5000
        onTriggered: JS.getRD('https://github.com/nextsigner/nextsigner.github.io/raw/master/zool/panelremoto/main.qml', r)
    }
    function setData(data, isData){
        if(isData){
            console.log('Host: '+data)
            unik.setFile(apps.jsonsFolder+'/PanelRemotoDoc.qml', data)
            let comp=Qt.createQmlObject(data, r, 'xzoolpanelremoto')
        }else{
            console.log('setXZoolStart Data '+isData+': '+data)
            r.state='show'
            bot.visible=true
            if(unik.fileExist(apps.jsonsFolder+'/PanelRemotoDoc.qml')){
                let fd=unik.getFile(apps.jsonsFolder+'/PanelRemotoDoc.qml')
                comp=Qt.createQmlObject(fd, r, 'xzoolpanelremoto')
            }else{
                JS.showMsgDialog('Error! - Zool Informa', 'Problemas de conexión a internet', 'No hay buena conexión de internet.\n\nEl panel remoto lateral de la izquierda será desactivado.\n\nIntenta más tarde.\n\nPor alguna razón, la aplicación no está pudiendo acceder a internet para obtener los datos requeridos. Error: '+data)
            }
        }
    }
}
