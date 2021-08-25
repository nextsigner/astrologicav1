import QtQuick 2.0

Item {
    id: r
    height: width
    anchors.centerIn: parent
    Rectangle{
        id: ejeCard1
        width: ascMcCircle.ejeAscendente.width+sweg.fs*0.5
        height: 1
        color: 'red'
        anchors.centerIn: r
        anchors.horizontalCenterOffset: 0-sweg.fs
        state: sweg.state
        states: [
            State {
                name: sweg.aStates[0]
                PropertyChanges {
                    target: ejeCard1
                    width: ascMcCircle.ejeAscendente.width+sweg.fs*0.5
                }
            },
            State {
                name: sweg.aStates[1]
                PropertyChanges {
                    target: ejeCard1
                    width: ascMcCircle.ejeAscendente.width-sweg.fs
                }
            },
            State {
                name: sweg.aStates[2]
                PropertyChanges {
                    target: ejeCard1
                    width: ascMcCircle.ejeAscendente.width-sweg.fs*0.5
                }
            }
        ]
        Behavior on opacity{enabled: apps.enableFullAnimation;NumberAnimation{duration: 500}}
        Canvas {
            id:canvas
            width: sweg.fs*0.5
            height: width
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            antialiasing: true
            onPaint:{
                var ctx = canvas.getContext('2d');
                ctx.beginPath();
                ctx.moveTo(0, canvas.width*0.5);
                ctx.lineTo(canvas.width, 0);
                ctx.lineTo(canvas.width, canvas.width);
                ctx.lineTo(0, canvas.width*0.5);                               ctx.strokeStyle = canvas.parent.color
                ctx.lineWidth = canvas.parent.height;
                ctx.fillStyle = canvas.parent.color
                ctx.fill();
                ctx.stroke();

            }
        }
    }
}
