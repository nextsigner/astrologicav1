import QtQuick 2.12
import QtGraphicalEffects 1.0

Item {
    id: r
    height: width
    anchors.centerIn: parent
    property int isAsc: 0
    property int isMC: 0
    property int gdegAsc: -1
    property int mdegAsc: -1
    property int gdegMC: -1
    property int mdegMC: -1
    property alias ejeAscendente: ejeAsc
    state: sweg.state
    states: [
        State {
            name: sweg.aStates[0]
            PropertyChanges {
                target: r
                width: sweg.width
            }
            PropertyChanges {
                target: ejeAsc
                width: sweg.objSignsCircle.width+sweg.fs*0.5
            }
            PropertyChanges {
                target: ejeMC
                width: sweg.objSignsCircle.width+sweg.fs*2//*0.5
            }
        },
        State {
            name: sweg.aStates[1]
            PropertyChanges {
                target: r
                width: sweg.width-sweg.fs*5
            }
            PropertyChanges {
                target: ejeAsc
                width: sweg.objSignsCircle.width+sweg.fs*3
            }
            PropertyChanges {
                target: ejeMC
                width: sweg.objSignsCircle.width+sweg.fs*3
            }
        },
        State {
            name: sweg.aStates[2]
            PropertyChanges {
                target: r
                width: sweg.width-sweg.fs
            }
            PropertyChanges {
                target: ejeAsc
                //width: sweg.objSignsCircle.width
                width: sweg.width-sweg.fs
            }
            PropertyChanges {
                target: ejeMC
                //width: sweg.objSignsCircle.width
                width: sweg.width-sweg.fs
            }
        }
    ]
    Rectangle{
        id: ejeAsc
        width: sweg.objSignsCircle.width
        height: 1
        anchors.centerIn: parent
        color: 'transparent'
        antialiasing: true
        Rectangle{
            id: xIconAsc
            property bool selected: app.currentPlanetIndex===15
            width: selected?sweg.fs*2:sweg.fs
            height: width
            radius: width*0.5
            color: 'black'
            border.width: sweg.objHousesCircle.wb
            border.color: co.color
            antialiasing: true
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: 0
            anchors.right: parent.left
            onSelectedChanged:{
                app.uSon='asc_'+app.objSignsNames[r.isAsc]+'_1'
            }
            state: sweg.state
            states: [
                State {
                    name: sweg.aStates[0]
                    PropertyChanges {
                        target: xIconAsc
                        anchors.rightMargin: !xIconAsc.selected?0:0-sweg.width*0.5-sweg.fs*0.25
                        anchors.verticalCenterOffset: !xIconAsc.selected?0-sweg.fs*2:0

                    }
                },
                State {
                    name: sweg.aStates[1]
                    PropertyChanges {
                        target: xIconAsc
                        anchors.rightMargin: app.currentPlanetIndex===14?0- housesCircle.width*0.5-xIconAsc.width*0.5-sweg.fs*1.5:0
                        //anchors.rightMargin: !xIconAsc.selected?0:0-sweg.width*0.5-sweg.fs*0.25
                        anchors.verticalCenterOffset: !xIconAsc.selected?0-sweg.fs*2:0
                    }
                },
                State {
                    name: sweg.aStates[2]
                    PropertyChanges {
                        target: xIconAsc
                        anchors.rightMargin: !xIconAsc.selected?0:0+sweg.fs//*0.25
                        //anchors.rightMargin: !xIconAsc.selected?0:0-sweg.width*0.5-sweg.fs*0.25
                        anchors.verticalCenterOffset: !xIconAsc.selected?0-sweg.fs*2:0
                    }
                }
            ]
            SequentialAnimation on color {
                running: true
                loops: Animation.Infinite
                PropertyAnimation {
                    target: co;
                    property: "color"
                    from: 'red'
                    to: 'yellow'
                }
                PauseAnimation {
                    duration: 100
                }
                PropertyAnimation {
                    target: co;
                    property: "color"
                    from: 'yellow'
                    to: 'red'
                }
            }
            Behavior on anchors.rightMargin{enabled: apps.enableFullAnimation;NumberAnimation{duration: 500;easing.type: Easing.InOutQuad}}
            //Behavior on width{enabled: apps.enableFullAnimation;NumberAnimation{duration: 250;easing.type: Easing.InOutQuad}}
            Image {
                id: img
                source: "./resources/imgs/signos/"+r.isAsc+".svg"
                width: parent.width*0.65
                height: width
                anchors.centerIn: parent                
            }
            ColorOverlay {
                id: co
                anchors.fill: img
                source: img
                color: 'red'
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    sweg.objHousesCircle.currentHouse=sweg.objHousesCircle.currentHouse!==1?1:-1
                }
            }
            Column{
                //anchors.centerIn: co
                width: parent.width
                anchors.verticalCenter: parent.verticalCenter
                spacing: sweg.fs*0.05
                Text{
                    text: 'Asc '+app.signos[r.isAsc]
                    font.pixelSize: sweg.fs*0.5
                    color: 'white'
                    width: contentWidth
                    anchors.right: parent.right
                    horizontalAlignment: Text.AlignRight
                    Rectangle{
                        width: parent.contentWidth+3
                        height: parent.contentHeight+3
                        color: 'black'
                        border.width: 1
                        border.color: 'white'
                        radius: sweg.fs*0.1
                        z: parent.z-1
                        opacity: 0.5
                        antialiasing: true
                        anchors.centerIn: parent
                    }
                }
                Item{width: xIconAsc.width;height: width}
                Text{
                    text: '°'+r.gdegAsc+' \''+r.mdegAsc+''
                    font.pixelSize: sweg.fs*0.5
                    color: 'white'
                    width: contentWidth
                    anchors.right: parent.right
                    horizontalAlignment: Text.AlignRight
                    Rectangle{
                        width: parent.contentWidth+3
                        height: parent.contentHeight+3
                        color: 'black'
                        border.width: 1
                        border.color: 'white'
                        radius: sweg.fs*0.1
                        z: parent.z-1
                        opacity: 0.5
                        anchors.centerIn: parent
                        antialiasing: true
                    }
                }
            }
            Rectangle{
                id: lineSenAsc
                width: 2
                height: Math.abs(parent.anchors.verticalCenterOffset)//-parent.height*0.25
                color: 'red'
                //anchors.horizontalCenter: parent.horizontalCenter
                anchors.left: parent.right
                anchors.leftMargin: sweg.state!==sweg.aStates[2]?sweg.fs*0.125:sweg.fs*0.35
                anchors.top: parent.verticalCenter

            }
            Rectangle{
                width: sweg.fs*0.5
                height: 2
                color: 'red'
                anchors.bottom: lineSenAsc.top
                anchors.right: lineSenAsc.right
                z:parent.z-1
            }
        }
    }
    Rectangle{
        id: ejeMC
        height: 1
        anchors.centerIn: parent
        color: 'transparent'
        antialiasing: true
        Rectangle{
            id: xIconMC
            property bool selected: app.currentPlanetIndex===16
            width: selected?sweg.fs*2:sweg.fs
            height: width
            radius: width*0.5
            color: 'black'
            border.width: sweg.objHousesCircle.wb
            border.color: co2.color
            antialiasing: true
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.left
            anchors.rightMargin: 0
            //opacity: app.currentPlanetIndex===16&&anchors.rightMargin!==0?1.0:0.0
            onSelectedChanged:{
                app.uSon='mc_'+app.objSignsNames[r.isMC]+'_10'
            }
            Behavior on anchors.rightMargin{enabled: apps.enableFullAnimation;NumberAnimation{duration: 500;easing.type: Easing.InOutQuad}}
            Behavior on x{enabled: apps.enableFullAnimation;NumberAnimation{duration: 500;easing.type: Easing.InOutQuad}}
            state: sweg.state
            states: [
                State {
                    name: sweg.aStates[0]
                    PropertyChanges {
                        target: xIconMC
                        anchors.rightMargin: !xIconMC.selected?0:0-sweg.width*0.5-sweg.fs
                    }                   
                },
                State {
                    name: sweg.aStates[1]
                    PropertyChanges {
                        target: xIconMC
                        anchors.rightMargin: !xIconMC.selected?0:0-sweg.width*0.5+sweg.fs*0.5
                    }
                },
                State {
                    name: sweg.aStates[2]
                    PropertyChanges {
                        target: xIconMC
                        anchors.rightMargin: !xIconMC.selected?0+sweg.fs*0.5:0-sweg.width*0.5-sweg.fs*0.5
                    }
                }
            ]
            SequentialAnimation on color {
                running: true
                loops: Animation.Infinite
                PropertyAnimation {
                    target: co2;
                    property: "color"
                    from: 'red'
                    to: 'yellow'
                }
                PauseAnimation {
                    duration: 100
                }
                PropertyAnimation {
                    target: co2;
                    property: "color"
                    from: 'yellow'
                    to: 'red'
                }
            }
            //Behavior on width{enabled: apps.enableFullAnimation;NumberAnimation{duration: 250;easing.type: Easing.InOutQuad}}
            Image {
                id: img2
                source: "./resources/imgs/signos/"+r.isMC+".svg"
                width: parent.width*0.65
                height: width
                anchors.centerIn: parent
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        sweg.objHousesCircle.currentHouse=sweg.objHousesCircle.currentHouse!==10?10:-1
                    }
                }
            }

            ColorOverlay {
                id: co2
                anchors.fill: img2
                source: img2
                color: 'red'
            }
            Text{
                text: 'MC '+app.signos[r.isMC]
                font.pixelSize: sweg.fs*0.5
                color: 'white'
                width: contentWidth
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.left
                anchors.rightMargin: sweg.fs*0.1
                Rectangle{
                    width: parent.contentWidth+3
                    height: parent.contentHeight+3
                    color: 'black'
                    border.width: 1
                    border.color: 'white'
                    radius: sweg.fs*0.1
                    z: parent.z-1
                    opacity: 0.5
                    antialiasing: true
                    anchors.centerIn: parent
                }
            }
            Text{
                text: '°'+r.gdegMC+' \''+r.mdegMC+''
                font.pixelSize: sweg.fs*0.5
                color: 'white'
                width: contentWidth// sweg.fs*0.5
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.right
                anchors.leftMargin: sweg.fs*0.1
                Rectangle{
                    width: parent.contentWidth+3
                    height: parent.contentHeight+3
                    color: 'black'
                    border.width: 1
                    border.color: 'white'
                    radius: sweg.fs*0.1
                    z: parent.z-1
                    opacity: 0.5
                    antialiasing: true
                    anchors.centerIn: parent
                }
            }
        }
    }
    function loadJson(jsonData) {
        let o1=jsonData.ph['h1']
        r.isAsc=o1.is
        r.gdegAsc=o1.rsgdeg
        r.mdegAsc=o1.mdeg
        app.uAscDegree=o1.rsgdeg

        let degs=(30*o1.is)+o1.rsgdeg
        o1=jsonData.ph['h10']
        r.isMC=o1.is
        r.gdegMC=o1.rsgdeg
        r.mdegMC=o1.mdeg
        app.uMcDegree=o1.rsgdeg
        ejeMC.rotation=degs-360-o1.gdeg
        xIconMC.rotation=0-ejeMC.rotation
    }
}
