import QtQuick 2.7
import QtQuick.Controls 2.0

Rectangle {
    id: r
    visible: false
    color: 'black'
    anchors.fill: parent
    Flickable{
        width: r.width
        height: r.height
        contentWidth: r.width
        contentHeight: data.contentHeight+app.fs*2
        Text{
            id: data
            width: r.width-app.fs
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: app.fs*0.5
            text: '<h1>InfoData</h1>'
            color: 'white'
            font.pixelSize: app.fs*0.5
            wrapMode: Text.WordWrap
            textFormat: Text.RichText
        }
    }
    function loadData(file){
        let fileData=''+unik.getFile(file)
        data.text=fileData
        r.visible=true
    }
}
