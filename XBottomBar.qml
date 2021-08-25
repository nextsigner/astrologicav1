import QtQuick 2.0

Rectangle {
    id: r
    width: parent.width
    height: app.fs
    color: 'black'
    border.width: 1
    border.color: 'white'
    //anchors.bottom: parent.bottom
    property alias objPanelCmd: panelCmd
    property alias objXState: xStatus
    state: "hide"
    states: [
        State {
            name: "show"
            PropertyChanges {
                target: r
                y:r.parent.height-r.height
            }
        },
        State {
            name: "hide"
            PropertyChanges {
                target: r
                y:r.parent.height
            }
        }
    ]
    Behavior on y {enabled: apps.enableFullAnimation;NumberAnimation{duration: app.msDesDuration;easing.type: Easing.InOutQuad}}
    XStatus{id: xStatus;}
    PanelCmd{
        id: panelCmd
        width: parent.width-xStatus.width
        onStateChanged: if(state==='show')r.state='show'
    }
}
