import QtQuick 2.7
import "./comps" as Comps

Item {
    id: r
    height: parent.height
    opacity: 0.0
    anchors.centerIn: parent
    anchors.verticalCenterOffset: verticalOffSet
    property int  verticalOffSet: xDataBar.state==='show'?sweg.fs*1.25:0
    property int fs: r.objectName==='sweg'?app.fs:app.fs*2
    property int w: fs
    property bool v: false
    property alias expand: planetsCircle.expand
    property alias objAspsCircle: aspsCircle
    property alias objPlanetsCircle: planetsCircle
    property alias objHousesCircle: housesCircle
    property alias objSignsCircle: signCircle
    property alias objAscMcCircle: ascMcCircle
    property alias objEclipseCircle: eclipseCircle
    property int speedRotation: 1000
    property var aStates: ['ps', 'pc', 'pa']
    property color backgroundColor: enableBackgroundColor?apps.backgroundColor:'transparent'
    property bool enableBackgroundColor: apps.enableBackgroundColor
    state: aStates[0]
    states: [
        State {//PS
            name: aStates[0]
            PropertyChanges {
                target: r
                width: r.fs*(12 +10)
            }
            PropertyChanges {
                target: signCircle
                width: sweg.width-sweg.fs*2
            }
            PropertyChanges {
                target: planetsCircle
                width: signCircle.width-signCircle.w
            }
        },
        State {//PC
            name: aStates[1]
            PropertyChanges {
                target: r
                width: r.fs*(15 +10)
            }
            PropertyChanges {
                target: signCircle
                width: sweg.width-sweg.fs*6
            }
            PropertyChanges {
                target: planetsCircle
                width: signCircle.width-signCircle.w
            }
        },
        State {//PA
            name: aStates[2]
            PropertyChanges {
                target: r
                width: r.fs*(12 +10)
            }
            PropertyChanges {
                target: signCircle
                width: sweg.width-sweg.fs*2
            }
            PropertyChanges {
                target: planetsCircle
                width: signCircle.width-signCircle.w
            }
        }
    ]
    onStateChanged: swegz.sweg.state=state
    Behavior on opacity{NumberAnimation{duration: 1500}}
    Behavior on verticalOffSet{NumberAnimation{duration: app.msDesDuration}}
    Item{id: xuqp}
    Rectangle{
        id: bg
        width: parent.width*10
        height: width
        color: backgroundColor
        visible: signCircle.v
    }
    AxisCircle{id: axisCircle}
    PanelAspects{
        id: panelAspects
        anchors.bottom: parent.bottom
        anchors.bottomMargin: verticalOffSet
        anchors.left: parent.left
        anchors.leftMargin: 0-((xApp.width-r.width)/2)+swegz.width
        visible: r.objectName==='sweg'
        //Rectangle{anchors.fill: parent; color: 'red';border.width: 1;border.color: 'white'}
    }
    Comps.HouseCircle{rotation: signCircle.rot;//z:signCircle.z+1;
        id:housesCircle
        height: width
        anchors.centerIn: signCircle
        w: r.fs*6
        widthAspCircle: aspsCircle.width
        visible: r.v
    }
    Comps.SignCircle{
        id:signCircle
        //width: planetsCircle.expand?r.width-r.fs*6+r.fs*2:r.width-r.fs*6
        anchors.centerIn: parent
        showBorder: true
        v:r.v
        w: r.w
        //onShowDecChanged: Qt.quit()
    }
    AspCircle{
        id: aspsCircle
        rotation: signCircle.rot - 90
        //opacity: panelDataBodies.currentIndex<0?1.0:0.0
    }
    PlanetsCircle{
        id:planetsCircle
        height: width
        anchors.centerIn: parent
        //showBorder: true
        //v:r.v
    }
    AscMcCircle{id: ascMcCircle}
    EclipseCircle{
        id: eclipseCircle
        width: housesCircle.width
        height: width
    }
    Rectangle{
        //Este esta en el centro
        visible: false
        opacity: 0.5
        width: r.fs*2//planetsCircle.children[0].fs*0.85+4
        height: width
        color: 'red'
        radius: width*0.5
        border.width: 2
        border.color: 'white'
        anchors.centerIn: parent
    }
    Timer{
        id: tFirtShow
        running: false
        repeat: false
        interval: 2000
        onTriggered: r.opacity=1.0
    }
    function loadSign(j){
        console.log('Ejecutando SweGraphic.loadSign()...')
        //unik.speak('load sign')
        for(var i=0;i<xuqp.children.length;i++){
            xuqp.children[i].destroy(3000)
        }
        let vd=j.params.d
        let vm=j.params.m
        let va=j.params.a
        let vh=j.params.h
        let vmin=j.params.min
        let vgmt=j.params.gmt
        let vlon=j.params.lon
        let vlat=j.params.lat
        let d = new Date(Date.now())
        let ms=d.getTime()
         let c='import QtQuick 2.0\n'
        c+='import unik.UnikQProcess 1.0\n'
        c+='UnikQProcess{\n'
        c+='    id: uqp'+ms+'\n'
        c+='    onLogDataChanged:{\n'
        c+='        let json=(\'\'+logData).replace(/\\n/g, \'\')\n'
        c+='        app.currentJsonSignData=JSON.parse(json)\n'
        c+='        panelControlsSign.loadJson(app.currentJsonSignData)\n'
        c+='        app.mod="pl"\n'
        //c+='        if(panelZonaMes.state===\'show\')panelZonaMes.play()\n'
        c+='        uqp'+ms+'.destroy(0)\n'
        c+='    }\n'
        c+='    Component.onCompleted:{\n'
        c+='        //console.log(\'python3 /home/ns/nsp/uda/astrologica/py/astrologica_swe.py '+vd+' '+vm+' '+va+' '+vh+' '+vmin+' '+vgmt+' '+vlat+' '+vlon+'\')\n'
        c+='        run(\''+app.pythonLocation+' '+app.mainLocation+'/py/astrologica_swe_search_asc_aries.py '+vd+' '+vm+' '+va+' '+vh+' '+vmin+' '+vgmt+' '+vlat+' '+vlon+'\')\n'
        c+='    }\n'
        c+='}\n'
        let comp=Qt.createQmlObject(c, xuqp, 'uqpcodesign')
    }
    function load(j){
        //console.log('Ejecutando SweGraphic.load()...')
        for(var i=0;i<xuqp.children.length;i++){
            xuqp.children[i].destroy(0)
        }
        let vd=j.params.d
        let vm=j.params.m
        let va=j.params.a
        let vh=j.params.h
        let vmin=j.params.min
        let vgmt=j.params.gmt
        let vlon=j.params.lon
        let vlat=j.params.lat
        let d = new Date(Date.now())
        let ms=d.getTime()
        let c='import QtQuick 2.0\n'
        c+='import unik.UnikQProcess 1.0\n'
        c+='UnikQProcess{\n'
        c+='    id: uqp'+ms+'\n'
        c+='    onLogDataChanged:{\n'
        c+='        let json=(\'\'+logData)\n'
        c+='        //console.log(\'JSON: \'+json)\n'
        c+='        loadSweJson(json)\n'
        c+='        swegz.sweg.loadSweJson(json)\n'
        c+='        uqp'+ms+'.destroy(3000)\n'
        c+='    }\n'
        c+='    Component.onCompleted:{\n'
        //c+='        console.log(\'sweg.load() python3 /home/ns/nsp/uda/astrologica/py/astrologica_swe.py '+vd+' '+vm+' '+va+' '+vh+' '+vmin+' '+vgmt+' '+vlat+' '+vlon+'\')\n'
        c+='        run(\''+app.pythonLocation+' '+app.mainLocation+'/py/astrologica_swe.py '+vd+' '+vm+' '+va+' '+vh+' '+vmin+' '+vgmt+' '+vlat+' '+vlon+'\')\n'
        c+='    }\n'
        c+='}\n'
        let comp=Qt.createQmlObject(c, xuqp, 'uqpcode')
    }
    function loadSweJson(json){
        //console.log('JSON::: '+json)
        sweg.objHousesCircle.currentHouse=-1
        swegz.sweg.objHousesCircle.currentHouse=-1
        app.currentPlanetIndex=-1
        let scorrJson=json.replace(/\n/g, '')
        //console.log('json: '+json)
        let j=JSON.parse(scorrJson)
        signCircle.rot=j.ph.h1.gdec
        ascMcCircle.loadJson(j)
        housesCircle.loadHouses(j)
        planetsCircle.loadJson(j)
        panelAspects.load(j)
        panelDataBodies.loadJson(j)
        aspsCircle.load(j)
        eclipseCircle.arrayWg=housesCircle.arrayWg
        eclipseCircle.isEclipse=-1
        //if(app.mod!=='rs'&&app.mod!=='pl'&&panelZonaMes.state!=='show')panelRsList.setRsList(61)
        r.v=true
        apps.enableFullAnimation=true
        tFirtShow.start()
        //tReload.restart()
    }
    function nextState(){
        let currentIndexState=r.aStates.indexOf(r.state)
        if(currentIndexState<r.aStates.length-1){
            currentIndexState++
        }else{
            currentIndexState=0
        }
        r.state=r.aStates[currentIndexState]
        swegz.sweg.state=r.state
    }
}
