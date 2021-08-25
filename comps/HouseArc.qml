import QtQuick 2.0
import "../"

Item {
    id: r
    width: housesCircle.currentHouse!==n?xArcs.width:xArcs.width+extraWidth
    height: width
    anchors.centerIn: parent
    property real wg: 0.0
    property int wb: 3
    property int gr: 0
    property int n: -1
    property int w: housesCircle.currentHouse!==n?housesCircle.w*0.5:sweg.fs*6.5
    property int c: 0
    property var colors: ['red', '#FBE103', '#09F4E2', '#0D9FD6','red', '#FBE103', '#09F4E2', '#0D9FD6','red', '#FBE103', '#09F4E2', '#0D9FD6']
    property bool showBorder: false
    property bool selected: housesCircle.currentHouse===n
    property  real op: 100.0
    property int opacitySpeed: 100
    property int extraWidth: 0
    property alias showEjeCentro: ejeCentro.visible

    //Behavior on w{enabled: apps.enableFullAnimation;NumberAnimation{duration: 500}}
    //Behavior on width{enabled: apps.enableFullAnimation;NumberAnimation{duration:500}}
    state: sweg.state
    states: [
        State {
            name: sweg.aStates[0]
            PropertyChanges {
                target: ejeV
                width:  r.width+sweg.fs*2//.5
            }
            PropertyChanges {
                target: canvas2
                opacity:  0.0
            }
            PropertyChanges {
                target: r
                colors: ['#685E05', '#4B450A', '#685E05', '#4B450A', '#685E05', '#4B450A', '#685E05', '#4B450A', '#685E05', '#4B450A', '#685E05', '#4B450A']
                extraWidth: 0
                w: (sweg.width-sweg.objAspsCircle.width)/2//housesCircle.parent.objectName==='sweg'?(!r.selected?sweg.fs*2.5:sweg.fs*6):(!r.selected?sweg.fs*3:sweg.fs*7)
            }
        },
        State {
            name: sweg.aStates[1]
            PropertyChanges {
                target: ejeV
                width:  r.width+sweg.fs*2.5
            }
            PropertyChanges {
                target: canvas2
                opacity:  1.0
            }
            PropertyChanges {
                target: r
                colors: ['red', '#FBE103', '#09F4E2', '#0D9FD6','red', '#FBE103', '#09F4E2', '#0D9FD6','red', '#FBE103', '#09F4E2', '#0D9FD6']
                extraWidth: sweg.fs*2.5
                w: (sweg.width-sweg.objAspsCircle.width)/2
                //w: housesCircle.parent.objectName==='sweg'?(!r.selected?sweg.fs*2.5:sweg.fs*6):(!r.selected?sweg.fs*2.5:sweg.fs*8)
            }
        },
        State {
            name: sweg.aStates[2]
            PropertyChanges {
                target: ejeV
                width: r.width+sweg.fs*2
            }
            PropertyChanges {
                target: canvas2
                opacity:  0.0
            }
            PropertyChanges {
                target: r
                colors: ['#685E05', '#4B450A', '#685E05', '#4B450A', '#685E05', '#4B450A', '#685E05', '#4B450A', '#685E05', '#4B450A', '#685E05', '#4B450A']
                extraWidth: 0
                //w: housesCircle.parent.objectName==='sweg'?(sweg.fs*2):(sweg.fs*4)
                w: (sweg.width-sweg.objAspsCircle.width)/2
            }
        }
    ]

    onWidthChanged: {
        canvas.anchors.centerIn= r
        canvas2.anchors.centerIn= r
        canvas.requestPaint()
        canvas2.requestPaint()
    }
    onWChanged: {
        canvas.requestPaint()
        canvas2.requestPaint()
    }
    onOpChanged: {
        if(op===0.0){
            opacitySpeed=50
            r.opacity=0.0
        }
        if(op===1.0){
            opacitySpeed=500
            r.opacity=1.0
        }
    }
    onOpacityChanged:{
        if(opacity===0.0){
            r.op=1.0
        }
        tOp.restart()
    }
    Timer{
        id: tOp
        running: false
        repeat: true
        interval: 500
        onTriggered: r.opacity=1.0
    }
    Behavior on opacity{enabled: apps.enableFullAnimation;
        NumberAnimation{duration: r.opacitySpeed}
    }
    onRotationChanged: {
        canvas.clear_canvas()
        canvas.requestPaint()
        canvas2.clear_canvas()
        canvas2.requestPaint()
    }
    Rectangle{
        anchors.fill: r
        color: 'transparent'
        border.width: 2
        border.color: 'red'
        radius: width*0.5
        visible: r.showBorder
        antialiasing: true
    }
    Canvas {
        id:canvas
        width: r.width//-sweg.fs
        height: width
        opacity: 0.65
        antialiasing: true
        onPaint:{
            var ctx = canvas.getContext('2d');
            ctx.reset();
            var x = canvas.width*0.5;
            var y = canvas.height*0.5;
            //var radius = canvas.width*0.5-r.w*0.5;
            var rad=parseInt(canvas.width*0.5-r.w*0.5)

            //console.log('Rad: '+rad)
            var radius = rad>0?rad:r.width;
            ctx.beginPath();
            ctx.arc(x, y, radius, ((2 * Math.PI) / 360 * 180)-(2 * Math.PI) / 360 * r.wg, (2 * Math.PI) / 360 * 180);
            ctx.lineWidth = r.w;
            ctx.strokeStyle = r.colors[r.c];
            ctx.stroke();
        }
        function clear_canvas() {
            canvas.requestPaint();
        }
    }
    Canvas {
        id:canvas2
        width: r.width
        height: width
        opacity: canvas.opacity
        antialiasing: true
        onPaint:{
            var ctx = canvas2.getContext('2d')
            ctx.reset();
            var x = canvas2.width*0.5+r.wb;
            var y = canvas2.height*0.5
            var rad=parseInt(canvas.width*0.5)
            var radius = rad>0?rad:r.width;

            ctx.beginPath();
            ctx.arc(x, y, radius, ((2 * Math.PI) / 360 * 180)-(2 * Math.PI) / 360 * r.wg, (2 * Math.PI) / 360 * 180);
            ctx.lineWidth = r.wb;
            ctx.strokeStyle = r.colors[r.c];
            ctx.stroke();
        }
        function clear_canvas() {
            canvas2.requestPaint();
        }
    }
    Rectangle{
        id: ejeV
        height: r.wb
        color: 'transparent'
        anchors.centerIn: r
        antialiasing: true
        Rectangle{
            visible: false//Depurando
            width: parent.width*3
            height: r.wb
            color: 'yellow'
            antialiasing: true
        }
        Row{
            anchors.left: circleBot.right
            //visible: false
            Rectangle{
                id: lineaEje
                width: ((ejeV.width-r.width)*0.5-circleBot.width)
                height: r.wb
                color: apps.enableBackgroundColor?apps.fontColor:'white'//r.selected?r.colors[r.c]:'white'
                antialiasing: true
            }
            Rectangle{
                id: lineaEje2
                width: r.w
                height: r.wb
                color: apps.enableBackgroundColor?apps.fontColor:'white'//'red'//r.colors[r.c]
                antialiasing: true
                y:c!==6?0-height*0.5:height*0.5
                //anchors.verticalCenter: parent.top
            }
        }
        Rectangle{
            id: circleBot
            width: sweg.fs*0.75+r.wb*2
            height: width
            radius: width*0.5
            color: apps.enableBackgroundColor?apps.fontColor:'white'
            border.width: r.wb
            border.color: apps.enableBackgroundColor?apps.fontColor:'white'//lineaEje.color
            anchors.verticalCenter: parent.verticalCenter
            antialiasing: true
            state: sweg.state
            states: [
                State {
                    name: sweg.aStates[0]
                    PropertyChanges {
                        target: circleBot
                        width: sweg.fs*0.75
                        border.width: 1
                        border.color: apps.enableBackgroundColor?apps.fontColor:'white'//'white'
                    }
                },
                State {
                    name: sweg.aStates[1]
                    PropertyChanges {
                        target: circleBot
                        width: sweg.fs*0.75+r.wb*2
                        border.width: r.wb
                        border.color: lineaEje.color
                    }
                },
                State {
                    name: sweg.aStates[2]
                    PropertyChanges {
                        target: circleBot
                        width: sweg.fs*0.75
                        border.width: 1
                        border.color: apps.fontColor//'white'
                    }
                }
            ]
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    sweg.state=sweg.aStates[1]
                    swegz.sweg.state=sweg.aStates[1]
                    let ni=sweg.objHousesCircle.currentHouse!==r.n?r.n:-1
                    sweg.objHousesCircle.currentHouse=ni
                    swegz.sweg.objHousesCircle.currentHouse=ni
                }
            }
            XText{
                text: '<b>'+r.n+'</b>'
                font.pixelSize: parent.width*0.6
                width: contentWidth
                height: contentHeight
                horizontalAlignment: Text.AlignHCenter
                color: apps.enableBackgroundColor?apps.backgroundColor:'black'
                //color: circleBot.border.color
                anchors.centerIn: parent
                rotation: 0-r.rotation-parent.rotation
            }
        }
    }
    Rectangle{
        id: ejeCentro
        width: canvas.width
        height: 4
        color: 'blue'//'transparent'
        anchors.centerIn: r
        rotation: 0-r.wg/2
        visible:false
        Rectangle{
            width: sweg.fs
            height: width
            //x:(r.w-width)/2
            border.width: 2
            border.color: 'white'
            radius: width*0.5
            color: 'red'//r.colors[r.c]
            anchors.verticalCenter: parent.verticalCenter
            rotation: 90-r.rotation-parent.rotation
            antialiasing: true
            XText {
                text: '<b>'+parseFloat(r.wg).toFixed(2)+'</b>'
                font.pixelSize: parent.width*0.3
                anchors.centerIn: parent
                color: 'white'
                rotation: 270+ejeCentro.rotation
            }
        }
    }
    Timer{
        id: tc
        running: r.selected
        repeat: true
        interval: 350
        onTriggered: {
            canvas.opacity=canvas.opacity===1.0?0.65:1.0
        }
    }
    function refresh(){
        canvas.clear_canvas()
        canvas.requestPaint()
        canvas.update()

        canvas2.clear_canvas()
        canvas2.requestPaint()
        canvas2.update()
    }
}
