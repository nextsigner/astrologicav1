import QtQuick 2.7
import QtQuick.Window 2.0
import QtQuick.Controls 2.0

ApplicationWindow {
    id: app
    visible: true
    width: app.fs*10
    height: Screen.desktopAvailableHeight-app.fs*3
    x: (Screen.width-app.width)/2+xOffSet
    y: app.fs*2.5
    color: 'black'
    property int xOffSet: 0
    property int fs: Screen.width*0.02
    property string textData: '?'
    Item{
        id: xApp
        anchors.fill: parent
        Rectangle{
            anchors.fill: parent
            color: 'transparent'
            border.width: b?3:0
            border.color: 'red'
            property bool b: false
            Timer{
                running: true
                repeat: true
                interval: 1000
                onTriggered: parent.b=!parent.b
            }
        }
        Flickable{
            anchors.fill: parent
            contentWidth: parent.width
            contentHeight: data.contentHeight+app.fs*2
            Text{
                id: data
                font.pixelSize: app.fs
                color: 'white'
                width: xApp.width-app.fs
                anchors.top: parent.top
                anchors.topMargin: app.fs
                anchors.horizontalCenter: parent.horizontalCenter
                wrapMode: Text.WordWrap
                textFormat: Text.RichText
            }
        }
        MouseArea{
            anchors.fill: parent
            onDoubleClicked: app.close()
        }
    }
    Shortcut{
        sequence: 'Esc'
        onActivated: app.close()
    }
    Component.onCompleted: {
        //let txt='Este es un texto de ejemplo Este es un texto de ejemplo Este es un texto de ejemplo Este es un texto de ejemplo Este es un texto de ejemplo Este es un texto de ejemplo Este es un texto de ejemplo Este es un texto de ejemplo Este es un texto de ejemplo '
        data.text=app.textData
        raise();
        forceActiveFocus();
        requestActivate();
    }
}
