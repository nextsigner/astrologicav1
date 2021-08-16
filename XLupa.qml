import QtQuick 2.7
import QtGraphicalEffects 1.0
Item {
    id: r
    width: app.fs*4
    height: width
    y: parent.height*0.5-r.width*0.5
    x: parent.width*0.5-r.height*0.5
    property real zoom: 2.0
    property alias image:img
    property alias centroLupa: centro
    property int mod: 2
    clip: true
    onModChanged: {
        if(mod===0){
            swegz.state='hide'
        }
        if(mod===1){
            swegz.state='show'
        }
        if(mod===2){
            swegz.state='show'
        }
    }
    onXChanged: an.running=true
    Behavior on x{enabled: app.enableAn;NumberAnimation{duration: 1000;easing.type: Easing.OutQuad}}
    Behavior on y{enabled: app.enableAn;NumberAnimation{duration: 1000;easing.type: Easing.OutQuad}}
    MouseArea{
        anchors.fill: r
        drag.axis: Drag.XAndYAxis
        drag.target: r
        onClicked: {
            if(mod===0){
                mod=1
                return
            }
            if(mod===1){
                mod=2
                return
            }
            if(mod===2){
                mod=0
                return
            }
        }
    }
    Rectangle{
        id: bg
        anchors.fill: r
        color: 'black'
        visible: img.visible
    }
    Image {
        id: img
        x:0-r.x*r.zoom+xApp.width*(r.zoom*0.25)-r.width*0.5
        y: 0-r.y*r.zoom+xApp.height*(r.zoom*0.25)-r.width*0.5
        width: xApp.width
        height: xApp.height
        scale: r.zoom
        visible: r.mod!==2
    }
    Rectangle {
        id: mask
        width: 100
        height: 50
        //radius: width*0.5
        visible: false
    }
    Rectangle{
        id: borde
        anchors.fill: r
        radius: r.mod===2?width*0.5:0
        color: 'transparent'
        border.width: 3
        border.color: xLayerTouch.visible?'white':'red'
        visible: !xLayerTouch.visible
    }
    Timer{
        id: tScreenShot
        running: img.visible
        repeat: true
        interval: 1
        onTriggered: {
            tScreenShot.stop()
            xApp.grabToImage(function(result) {
                //console.log('Url: '+result.url)
                img.source=result.url
                tScreenShot.restart()
            });
        }
    }
    Timer{
        id: tCentro
        running: false
        repeat: false
        interval: 3000
        onTriggered: an.running=false
    }
    Rectangle{
        id: centro
        width: app.fs*0.5
        height: width
        radius: width*0.5
        color: 'transparent'
        border.width: 1
        border.color: borde.border.color
        anchors.centerIn: parent
        visible: an.running
        Rectangle{
            id: bgc1
            anchors.fill: parent
            radius: parent.radius
            opacity: 0.0
        }
        Rectangle{
            id: bgc2
            anchors.fill: parent
            radius: parent.radius
            opacity: 0.0
        }        
    }
    Rectangle{
        color: 'yellow'
        width: 20
        height: width
        radius: width*0.5
        anchors.centerIn: parent
        visible: false
    }
    SequentialAnimation{
        id: an
        running: false
        onRunningChanged: tCentro.restart()
        loops: Animation.Infinite
        PropertyAnimation{
            target: centro
            property: "opacity"
            from:1.0
            to:0.0
        }

        PauseAnimation {
            duration: 100
        }
        PropertyAnimation{
            target: centro
            property: "opacity"
            from:0.0
            to:1.0
        }
    }
    SequentialAnimation{
        running: an.running
        loops: Animation.Infinite

        PropertyAnimation {
            target: bgc1; property: "opacity";from:0.0;to:0.5 }
        PropertyAnimation {
            target: bgc1; property: "opacity";from:0.5;to:0.0 }
        PropertyAnimation {
            target: bgc2; property: "opacity";from:0.0;to:0.5 }
        PropertyAnimation {
            target: bgc2; property: "opacity";from:0.5;to:0.0 }
    }
}
