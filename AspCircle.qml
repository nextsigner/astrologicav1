import QtQuick 2.0

Rectangle {
    id: r
    height: width
    radius: width*0.5
    color: 'transparent'
    border.width: 2
    border.color: 'white'
    anchors.centerIn: parent
    antialiasing: true
    //visible: sweg.state===sweg.aStates[0] || sweg.state===sweg.aStates[2]
    property int currentAspSelected: -1
    property int widthNodosAspSelected: 8
    state: sweg.state
    states: [
        State {
            name: sweg.aStates[0]
            PropertyChanges {
                target: r
                width: planetsCircle.width-((planetsCircle.totalPosX*planetsCircle.planetSize)*2)-sweg.fs
                opacity: 0.0
            }
        },
        State {
            name: sweg.aStates[1]
            PropertyChanges {
                target: r
                width: sweg.fs*4//Está invisible, no sirve de nada que le ponga una medida acá. XD
                //opacity: 0.0
            }
        },
        State {
            name: sweg.aStates[2]
            PropertyChanges {
                target: r
                width: planetsCircle.width-((planetsCircle.totalPosX*planetsCircle.planetSize)*2)-sweg.fs
                opacity: 1.0
            }
        }
    ]
    onCurrentAspSelectedChanged: setPosCurrentAsp(currentAspSelected)
    onWidthChanged: {
        currentAspSelected=-1
        clear_canvas()
        clear_canvasBg()
    }
    Behavior on width {
        NumberAnimation{
            duration: sweg.speedRotation
            easing.type: Easing.InOutQuad
        }
    }
    Behavior on opacity {
        NumberAnimation{
            duration: sweg.speedRotation
            easing.type: Easing.InOutQuad
        }
    }
    Behavior on rotation {
        NumberAnimation{
            duration: sweg.speedRotation
            easing.type: Easing.InOutQuad
        }
    }
    Timer{
        running: currentAspSelected!==-1
        repeat: true
        interval: 500
        onTriggered: canvasBg.visible=!canvasBg.visible
    }
    Rectangle{
        width: r.width
        height: width
        color: 'black'
        radius: width*0.5
        anchors.centerIn: r
    }
    Canvas {
        id:canvasBg
        width: canvas.width
        height: width
        visible: false
        property int px1: -1
        property int py1: -1
        property int px2: -1
        property int py2: -1
        onPy2Changed: requestPaint()
        onPaint:{
            var ctx = canvasBg.getContext('2d');
            ctx.reset();
            var x = canvasBg.width*0.5;
            var y = canvasBg.height*0.5;
            var radius=canvasBg.width*0.5-2
            drawLine(ctx, px1, py1+2, px2, py2+2, 'white', 7)
            //drawPoint(ctx, px1, py1, 8, 'white')
            //drawPoint(ctx, px2, py2, 8, 'white')
        }
    }
    Canvas {
        id:canvas
        width: r.width//-sweg.fs
        height: width
        anchors.centerIn: r
        property var json
        onJsonChanged: requestPaint()
        onPaint:{
            var ctx = canvas.getContext('2d');
            ctx.reset();
            var x = canvas.width*0.5;
            var y = canvas.height*0.5;
            var radius=canvas.width*0.5
            var cx=canvas.width*0.5
            var cy=canvas.height*0.5

            //Dibujo punto inicio en Aries
            //drawLine(ctx, radius-3, 0, px3+cx, py3+cy)

            if(json&&json.asps){
                let asp=json.asps
                for(var i=0;i<Object.keys(asp).length;i++){
                    if(asp['asp'+parseInt(i +1)]){
                        let a=asp['asp'+parseInt(i +1)]
                        let colorAsp='black'
                        //# -1 = no hay aspectos. 0 = oposición. 1 = cuadratura. 2 = trígono
                        if(a.ia===0){
                            colorAsp='red'
                        }
                        if(a.ia===1){
                            colorAsp='#ff8833'
                        }
                        if(a.ia===2){
                            colorAsp='green'
                        }
                        if(a.ia===3){
                            colorAsp='blue'
                        }
                        drawAsp(ctx, cx, cy, a.gdeg1, a.gdeg2, colorAsp)
                    }
                }
            }
        }
    }
    Item{
        id: punto
        width: 1
        height: width
        visible: canvasBg.visible
        Rectangle{
            width: widthNodosAspSelected
            height: width
            radius: width*0.5
            color: 'white'
            anchors.centerIn: parent
        }
    }
    Item{
        id: punto2
        width: 1
        height: width
        visible: canvasBg.visible
        Rectangle{
            width: widthNodosAspSelected
            height: width
            radius: width*0.5
            color: 'white'
            anchors.centerIn: parent
        }
    }
    Rectangle {
        id: borde
        anchors.fill: r
        color: 'transparent'
        radius: width*0.5
        border.width: 1
        border.color: 'white'
    }
    function drawPoint(ctx, x, y, r, c){
        ctx.beginPath();
        ctx.arc(x, y, r, 0, 2 * Math.PI);
        ctx.lineWidth = 2
        ctx.strokeStyle = c;
        ctx.stroke();
    }
    function drawAsp(ctx, cx, cy, gdeg1, gdeg2, c){
        var angulo= gdeg1
        var coords=gCoords(radius, angulo)
        var px1 = coords[0]
        var py1 = coords[1]
        angulo= gdeg2
        coords=gCoords(radius, angulo)
        var px2 = coords[0]
        var py2 = coords[1]
        drawLine(ctx, px1+cx, py1+cy, px2+cx, py2+cy, c, 2)
    }
    function drawLine(ctx, px1, py1, px2, py2, c, w){
        ctx.beginPath();
        ctx.moveTo(px1, py1);
        ctx.lineTo(px2, py2);
        ctx.lineWidth = w
        ctx.strokeStyle = c;
        ctx.stroke();
    }
    function gCoords(radius, angle) {
        var d = Math.PI/180 //to convert deg to rads
        var deg
        var x
        var y
        deg = (360 - angle - 90) * d
        x = radius * Math.cos(deg)
        y = radius * Math.sin(deg)
        return [ x, y ];
    }
    function clear_canvas() {
        var ctx = canvas.getContext("2d");
        if(ctx)ctx.reset();
        canvas.requestPaint();
    }
    function clear_canvasBg() {
        var ctx = canvasBg.getContext("2d");
        if(ctx)ctx.reset();
        canvasBg.requestPaint();
    }
    function load(jsonData){
        canvas.json=jsonData
    }
    function setPosCurrentAsp(ci){
        clear_canvasBg()
        let asp=canvas.json.asps
        //for(var i=0;i<Object.keys(asp).length;i++){
        if(asp['asp'+parseInt(r.currentAspSelected +1)]){
            let a=asp['asp'+parseInt(r.currentAspSelected +1)]
            let colorAsp='black'
            //# -1 = no hay aspectos. 0 = oposición. 1 = cuadratura. 2 = trígono
            if(a.ia===0){
                colorAsp='red'
            }
            if(a.ia===1){
                colorAsp='#ff8833'
            }
            if(a.ia===2){
                colorAsp='green'
            }
            if(a.ia===3){
                colorAsp='blue'
            }
            var cx=canvas.width*0.5
            var cy=canvas.height*0.5
            var radius=canvas.width*0.5
            var coords=gCoords(radius, a.gdeg1)
            var coords2=gCoords(radius, a.gdeg2)
            punto.x=cx+coords[0]
            punto.y=cy+coords[1]
            punto2.x=cx+coords2[0]
            punto2.y=cy+coords2[1]
            clear_canvasBg()
            canvasBg.px1=cx+coords[0]
            canvasBg.py1=cx+coords[1]
            canvasBg.px2=cx+coords2[0]
            canvasBg.py2=cx+coords2[1]
            canvasBg.requestPaint()
            //canvas.visible=false
        }
    }
}
