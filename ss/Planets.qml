import QtQuick 2.0
import QtCanvas3D 1.0

import "planets.js" as GLCode

Rectangle {
    id: mainview
    //anchors.fill: parent
    color: "transparent"
    property int canvas3dX: 0
    property int canvas3dY: 0
    property int canvas3dWidth: 400
    property int canvas3dHeight: 400

    property alias lm: planetModel
    property alias wb: winBorder
    property alias ds: distanceSlider
    property alias ss: scaleSlider

    property int focusedPlanet: 3
    property int oldPlanet: 0
    property real xLookAtOffset: 0
    property real yLookAtOffset: 0
    property real zLookAtOffset: 0
    property real xCameraOffset: 0
    property real yCameraOffset: 0
    property real zCameraOffset: 0
    property real cameraNear: 0
    property int sliderLength: (width < height) ? width / 2 : height / 2
    property real textSize: (sliderLength < 320) ? (sliderLength / 20) : 16
    property real planetButtonSize: (height < 768) ? (height / 11) : 70
    Behavior on opacity{NumberAnimation{duration: 500}}
    NumberAnimation {
        id: lookAtOffsetAnimation
        target: mainview
        properties: "xLookAtOffset, yLookAtOffset, zLookAtOffset"
        to: 0
        easing.type: Easing.InOutQuint
        duration: 1250
    }

    NumberAnimation {
        id: cameraOffsetAnimation
        target: mainview
        properties: "xCameraOffset, yCameraOffset, zCameraOffset"
        to: 0
        easing.type: Easing.InOutQuint
        duration: 2500
    }

    Behavior on cameraNear {
        PropertyAnimation {
            easing.type: Easing.InOutQuint
            duration: 2500
        }
    }
    //! [1]
    onFocusedPlanetChanged: {
        GLCode.prepareFocusedPlanetAnimation();

        lookAtOffsetAnimation.restart();
        cameraOffsetAnimation.restart();
    }
    //! [1]
    //! [0]
    Rectangle{
        id: winBorder
        anchors.fill: canvas3d
        border.width: 2
        border.color: 'white'
        color: 'transparent'
        z:canvas3d.z+1
        antialiasing: true
    }
    Canvas3D {
        id: canvas3d
        x: mainview.canvas3dX
        y: mainview.canvas3dY
        width: mainview.canvas3dWidth
        height: mainview.canvas3dHeight
        //! [4]
        onInitializeGL: {
            GLCode.initializeGL(canvas3d, eventSource, mainview);
        }
        //! [4]
        onPaintGL: {
            GLCode.paintGL(canvas3d);
        }

        onResizeGL: {
            GLCode.onResizeGL(canvas3d);
        }
        //! [3]
        ControlEventSource {
            anchors.fill: parent
            focus: true
            id: eventSource
        }
        //! [3]
    }
    //! [0]
    ListModel {
        id: planetModel
        function addPlanets(nom,s,num){
            return{
                name:nom,
                radius:"",
                temperature:"",
                orbitalPeriod: "",
                distance: "",
                planetImageSource:s,
                planetNumber:num
            }
        }
    }

    Component {
        id: planetButtonDelegate
        PlanetButton {
            source: planetImageSource
            text: name
            focusPlanet: planetNumber
            planetSelector: mainview
            buttonSize: planetButtonSize
            fontSize: textSize
        }
    }
    StyledSlider {
        id: speedSlider
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        width: sliderLength
        value: 0.05
        minimumValue: 0
        maximumValue: 1
        onValueChanged: GLCode.onSpeedChanged(value);
        visible: false
    }
    Text {
        anchors.right: speedSlider.left
        anchors.verticalCenter: speedSlider.verticalCenter
        anchors.rightMargin: 10
        font.family: "Helvetica"
        font.pixelSize: textSize
        font.weight: Font.Light
        color: "white"
        text: "Rotation Speed"
        visible: false
    }

    StyledSlider {
        id: scaleSlider
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        width: sliderLength
        value: 1200
        minimumValue: 1
        maximumValue: 2000
        onValueChanged: GLCode.setScale(value);
        visible: false
    }
    Text {
        anchors.right: scaleSlider.left
        anchors.verticalCenter: scaleSlider.verticalCenter
        anchors.rightMargin: 10
        font.family: "Helvetica"
        font.pixelSize: textSize
        font.weight: Font.Light
        color: "white"
        text: "Planet Size"
        visible: false
    }

    StyledSlider {
        id: distanceSlider
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        orientation: Qt.Vertical
        height: sliderLength
        value: -3
        minimumValue: -6
        maximumValue: 6
        //! [2]
        onValueChanged: GLCode.setCameraDistance(value);
        //! [2]
        visible: false
    }
    Text {
        y: distanceSlider.y + distanceSlider.height + width + 10
        x: distanceSlider.x + 30 - textSize
        transform: Rotation {
            origin.x: 0;
            origin.y: 0;
            angle: -90
        }
        font.family: "Helvetica"
        font.pixelSize: textSize
        font.weight: Font.Light
        color: "white"
        text: "Viewing Distance"
        visible: false
    }


    Text{
        id: txt
        font.pixelSize: 50
        color: 'red'
        text :'-><b>'+focusedPlanet+'</b>'
        visible: false
    }
    function add(nom, s, num){
        lm.append(lm.addPlanets(nom, s, num))
    }
    function setPlanet(n){
        var SUN = 0;
        var MERCURY = 1;
        var VENUS = 2;
        var EARTH = 3;
        var MARS = 4;
        var JUPITER = 5;
        var SATURN = 6;
        var URANUS = 7;
        var NEPTUNE = 8;
        var PLUTO = 10;
        var NUM_SELECTABLE_PLANETS = 10;
        var MOON = 9;
        var SOLAR_SYSTEM = 100;
        //planetasRes: ['sun', 'moon', 'mercury', 'venus', 'mars', 'jupiter', 'saturn', 'uranus', 'neptune', 'pluto', 'n', 's', 'hiron', 'selena', 'lilith']
        if(n===-1){
            focusedPlanet=EARTH
        }
        if(n===0){
            focusedPlanet=SUN
        }
        if(n===1){
            focusedPlanet=MOON
        }
        if(n===2){
            focusedPlanet=MERCURY
        }
        if(n===3){
            focusedPlanet=VENUS
        }
        if(n===4){
            focusedPlanet=MARS
        }
        if(n===5){
            focusedPlanet=JUPITER
        }
        if(n===6){
            focusedPlanet=SATURN
        }
        if(n===7){
            focusedPlanet=URANUS
        }
        if(n===8){
            focusedPlanet=NEPTUNE
        }
        if(n===9){
            focusedPlanet=PLUTO
        }
    }
}
