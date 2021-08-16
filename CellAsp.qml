import QtQuick 2.0

Rectangle {
    id: r
    height: width
    border.width: 1
    border.color: 'gray'
    color: indexAsp!==-1?arrColors[indexAsp]:'transparent'
    property var arrColors: ['red','#ff8833',  'green', '#124cb1']
    property int indexAsp: -1
    property int indexPosAsp: -1
    SequentialAnimation{
        running: indexPosAsp===sweg.objAspsCircle.currentAspSelected&&sweg.objAspsCircle.currentAspSelected!==-1
        loops: Animation.Infinite
        onRunningChanged: {
            if(!running){
                r.border.width=1
                r.border.color='gray'
            }
        }
        ParallelAnimation{
            PropertyAnimation{
                target: r
                property: "border.width"
                from: 2; to: 4
            }
            PropertyAnimation{
                target: r
                property: "border.color"
                from: "#ffffff"; to: "red"
            }
        }

        PauseAnimation {
            duration: 500
        }
        ParallelAnimation{
            PropertyAnimation{
                target: r
                property: "border.width"
                from: 4; to: 2
            }
            PropertyAnimation{
                target: r
                property: "border.color"
                from: "red"; to: "#ffffff"
            }
        }
    }
//    Rectangle {
//        anchors.fill: parent
//        border.width: 2
//        border.color: 'red'
//        color: 'transparent'
//        //visible: indexPosAsp===sweg.objAspsCircle.currentAspSelected&&sweg.objAspsCircle.currentAspSelected!==-1
//    }
    MouseArea{
        id: ma
        anchors.fill: parent
        property int uCurrentPlanetIndex: -1
        onClicked: {
            if(sweg.objAspsCircle.currentAspSelected!==r.indexPosAsp){
                sweg.objAspsCircle.currentAspSelected=r.indexPosAsp
                swegz.sweg.objAspsCircle.currentAspSelected=r.indexPosAsp
                ma.uCurrentPlanetIndex=app.currentPlanetIndex
                app.currentPlanetIndex=-1
            }else{
                sweg.objAspsCircle.currentAspSelected=-1
                swegz.sweg.objAspsCircle.currentAspSelected=-1
                app.currentPlanetIndex=ma.uCurrentPlanetIndex
            }
        }
    }
    Text{
        text:'<b>'+r.indexPosAsp+'</b>'
        font.pixelSize: 10
        anchors.centerIn: parent
        color: 'white'
        visible: r.indexPosAsp!==-1
    }
}
