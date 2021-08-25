import QtQuick 2.7
import QtQuick.Controls 2.0
import Qt.labs.folderlistmodel 2.12
import "Funcs.js" as JS

Rectangle {
    id: r
    width: parent.width
    height: parent.height
    anchors.bottom: parent.bottom
    color: apps.backgroundColor
    border.width: 1
    border.color: apps.fontColor
    state: 'hide'
    property alias currentIndex: lv.currentIndex
    property int currentIndexSign: -1
    //Behavior on height{NumberAnimation{duration:app.msDesDuration;easing.type: Easing.InOutQuad}}
    onCurrentIndexChanged: {
        if(!r.enabled)return
        sweg.objHousesCircle.currentHouse=currentIndex
        swegz.sweg.objHousesCircle.currentHouse=currentIndex
    }
    states: [
        State {
            name: "show"
            PropertyChanges {
                target: r
                x:r.parent.width-r.width
            }
        },
        State {
            name: "hide"
            PropertyChanges {
                target: r
                x:r.parent.width
            }
        }
    ]
    Behavior on x{NumberAnimation{duration: app.msDesDuration}}
    onStateChanged: {
        if(state==='hide')return
        JS.raiseItem(r)
        //xApp.focus=true
    }
    onXChanged: {
        if(x===0){
            //txtDataSearch.selectAll()
            //txtDataSearch.focus=true
        }
    }
    Column{
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: app.fs*0.25
        Rectangle{
            width: lv.width
            height: app.fs
            color: apps.backgroundColor
            border.width: 2
            border.color: apps.fontColor
            XText {
                text: '<b>Zool v'+version+' by @nextsigner</b>'
                font.pixelSize: app.fs*0.5
                width: contentWidth
                anchors.centerIn: parent
            }
        }
        ListView{
            id: lv
            width: r.width-r.border.width*2
            height: r.height
            anchors.horizontalCenter: parent.horizontalCenter
            delegate: compItemList
            model: lm
            //currentIndex: app.currentPlanetIndex
            clip: true
            onCurrentIndexChanged: {
                //console.log('panelbodies currentIndex: '+currentIndex)
                //let item=lm.get(currentIndex)
                //app.uSon='_'+app.objSignsNames[item.is]+'_1'
                if(!r.enabled)return
                //r.currentIndexSign=lm.get(currentIndex).is
            }
        }
    }


    ListModel{
        id: lm
        function addItem(indexSign, indexHouse, grado, minuto, segundo, stringData){
            return {
                is: indexSign,
                ih: indexHouse,
                gdeg:grado,
                mdeg: minuto,
                sdeg: segundo,
                sd: stringData
            }
        }
    }
    Component{
        id: compItemList
        Rectangle{
            width: lv.width
            height: txtData.contentHeight+app.fs*0.1
            color: index===app.currentPlanetIndex?apps.fontColor:apps.backgroundColor
            border.width: index===app.currentPlanetIndex?2:0
            border.color: apps.fontColor
            XText {
                id: txtData
                text: sd
                font.pixelSize: app.fs*0.4
                width: parent.width-app.fs*0.2
                wrapMode: Text.WordWrap
                textFormat: Text.RichText
                color: index===app.currentPlanetIndex?apps.backgroundColor:apps.fontColor
                anchors.centerIn: parent
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    app.currentPlanetIndex=index
                }
                Rectangle{
                    anchors.fill: parent
                    color: 'red'
                    visible: false
                }
            }
        }
    }
    function loadJson(json){
        lm.clear()
        let jo
        let o
        var houseSun=-1
        for(var i=0;i<15;i++){
            jo=json.pc['c'+i]
            var s = jo.nom+ ' °' +jo.rsgdeg+ '\'' +jo.mdeg+ '\'\'' +jo.sdeg+ ' ' +app.signos[jo.is]+ '  - Casa ' +jo.ih
            //console.log('--->'+s)
            lm.append(lm.addItem(jo.is, jo.ih, jo.rsgdeg, jo.mdeg, jo.sdeg, s))
            if(i===0){
                houseSun=jo.ih
            }
        }

        //Fortuna
//        let joHouses=json.ph['h1']
//        let joSol=json.pc['c0']
//        let joLuna=json.pc['c1']
//        //objAs=r.children[15]
//        var gf
//        if(houseSun>=6){
//            //Fortuna en Carta Diurna
//            //Calculo para Fortuna Diurna Asc + Luna - Sol
//            gf=joHouses.gdec+joLuna.gdec - joSol.gdec
//            if(gf>=360)gf=gf-360
//            //objAs.rotation=signCircle.rot-gf
//        }else{
//            //Fortuna en Carta Nocturna
//            //Calculo para Fortuna Nocturna Asc + Sol - Luna
//            gf=joHouses.gdec+joSol.gdec - joLuna.gdec
//            if(gf>=360)gf=gf-360
//            //objAs.rotation=signCircle.rot-gf
//        }
//        //console.log('gf: '+JS.deg_to_dms(gf))
//        var arrayDMS=JS.deg_to_dms(gf)
//        let of={}
//        of.p=0
//        of.ns=objSignsNames.indexOf(0)
//        of.g=arrayDMS[0]
//        of.m=arrayDMS[1]
//        of.s=arrayDMS[2]
//        var rsDegSign=gf
//        var fortuneIndexSign=-1
//        for(var i2=1;i2<13;i2++){
//            if(i2*30<gf){
//                fortuneIndexSign=i2
//                rsDegSign-=30
//            }

//            if(json.ph['h'+i2].gdec<gf){
//                of.h=i2
//                of.ih=i2
//            }
//        }
//        of.is=fortuneIndexSign
//        of.rsg=rsDegSign
//        s = 'Fortuna °' +parseInt(of.rsg)+ '\'' +of.m+ '\'\'' +of.s+ ' ' +app.signos[of.is]+' - Casa '+parseInt(of.ih)
//        lm.append(lm.addItem(of.is, of.ih, of.rsg, of.m, of.s,  s))

        let o1=json.ph['h1']
        s = 'Ascendente °' +o1.rsgdeg+ '\'' +o1.mdeg+ '\'\'' +o1.sdeg+ ' ' +app.signos[o1.is]
        lm.append(lm.addItem(o1.is, 1, o1.rsgdeg, o1.mdeg, o1.sdeg,  s))
        o1=json.ph['h10']
        s = 'Medio Cielo °' +o1.rsgdeg+ '\'' +o1.mdeg+ '\'\'' +o1.sdeg+ ' ' +app.signos[o1.is]
        lm.append(lm.addItem(o1.is, 10, o1.rsgdeg, o1.mdeg, o1.sdeg, s))
        if(app.mod!=='rs'&&app.mod!=='pl')r.state='show'
    }
}
