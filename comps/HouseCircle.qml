import QtQuick 2.0

Item {
    id: r
    property int currentHouse: -1
    property int w: sweg.fs*3
    property int wb: 1//sweg.fs*0.15
    property int f: 0
    property bool v: false
    property var arrayWg: []
    property string extraObjectName: ''
    property var swegParent//: value
    property int widthAspCircle: 10
    state: r.parent.state
    states: [
        State {
            name: r.parent.aStates[0]
            PropertyChanges {
                target: r
                //width: housesCircle.parent.objectName==='sweg'?(r.parent.width-sweg.fs-sweg.fs):(r.parent.width-sweg.fs)
                width: r.parent.width-sweg.fs-sweg.fs
            }
        },
        State {
            name: r.parent.aStates[1]
            PropertyChanges {
                target: r
                //width: housesCircle.parent.objectName==='sweg'?(r.parent.width-sweg.fs*5-sweg.fs):(r.parent.width-sweg.fs*2.5-sweg.fs*0.5)
                width: r.parent.width-sweg.fs*5-sweg.fs
            }
        },
        State {
            name: r.parent.aStates[2]
            PropertyChanges {
                target: r
                //width: housesCircle.parent.objectName==='sweg'?(r.parent.width-sweg.fs-sweg.fs):(r.parent.width)
                width: r.parent.width-sweg.fs-sweg.fs
            }
        }
    ]
//    Behavior on rotation{
//        enabled: apps.enableFullAnimation;
//        NumberAnimation{duration:2000;easing.type: Easing.InOutQuad}
//    }
    Item{
        id: xHomeArcs
        anchors.fill: r
        Item{
            id:xArcs
            anchors.fill: parent
            Repeater{
                model: 12
                HouseArc{
                    objectName: 'HomeArc'+index+'_'+r.extraObjectName
                    n: index+1
                    c: index
                }
            }
        }
    }
    Text{
        text: 'RHC:'+r.rotation
        font.pixelSize: 40
        color: 'blue'
        //x: 300
        visible: false
    }
    function loadHouses(jsonData) {
        r.arrayWg=[]
        xArcs.rotation=360-jsonData.ph.h1.gdec
        let resta=0.000000
        let nh=0
        let o1
        let o2
        let indexSign1
        let p1
        let indexSign2
        let p2
        let gp=[]
        for(var i=0;i<12;i++){
            if(i===0){
                app.uAscDegreeTotal=jsonData.ph.h1.gdec
            }
            nh=i
            let h=xArcs.children[i]
            h.op=0.0
            let sh1=''
            let sh2=''
            if(i===11){
                sh1='h'+parseInt(nh + 1)
                sh2='h1'
                //console.log('Ob1: '+sh1+ ' '+sh2)
                o1=jsonData.ph[sh1]
                o2=jsonData.ph[sh2]
            }else{
                sh1='h'+parseInt(nh + 1)
                sh2='h'+parseInt(nh + 2)
                o1=jsonData.ph[sh1]
                o2=jsonData.ph[sh2]
            }
            indexSign1=o1.is
            p1=indexSign1*30+o1.rsgdeg
            indexSign2=o2.is//app.objSignsNames.indexOf(o2.s)
            p2=0.0000+indexSign2*30+o2.rsgdeg+(o2.mdeg/60)
            let wgf=parseInt(p2)-parseInt(p1)//+(o1.mdeg/60)
            if(wgf<0){
                h.wg=360+p2-p1//+(o1.mdeg/60)
            }else{
                h.wg=p2-p1//+(o1.mdeg/60)
            }
            //h.wg=1
            if(i===0){
                h.rotation=0
            }else{
                if(i===1){
                    h.rotation=360-gp[i-1]
                }
                if(i===2){
                    h.rotation=360-(gp[i-1]+gp[i-2])
                }
                if(i===3){
                    h.rotation=360-(gp[i-1]+gp[i-2]+gp[i-3])
                }
                if(i===4){
                    h.rotation=360-(gp[i-1]+gp[i-2]+gp[i-3]+gp[i-4])
                }
                if(i===5){
                    h.rotation=360-(gp[i-1]+gp[i-2]+gp[i-3]+gp[i-4]+gp[i-5])
                }
                if(i===6){
                    h.rotation=h.rotation=360-(gp[i-1]+gp[i-2]+gp[i-3]+gp[i-4]+gp[i-5]+gp[i-6])
                }
                if(i===7){
                    h.rotation=h.rotation=360-(gp[i-1]+gp[i-2]+gp[i-3]+gp[i-4]+gp[i-5]+gp[i-6]+gp[i-7])
                }
                if(i===8){
                    h.rotation=h.rotation=360-(gp[i-1]+gp[i-2]+gp[i-3]+gp[i-4]+gp[i-5]+gp[i-6]+gp[i-7]+gp[i-8])
                }
                if(i===9){
                    h.rotation=h.rotation=360-(gp[i-1]+gp[i-2]+gp[i-3]+gp[i-4]+gp[i-5]+gp[i-6]+gp[i-7]+gp[i-8]+gp[i-9])
                }
                if(i===10){
                    h.rotation=h.rotation=360-(gp[i-1]+gp[i-2]+gp[i-3]+gp[i-4]+gp[i-5]+gp[i-6]+gp[i-7]+gp[i-8]+gp[i-9]+gp[i-10])
                }
                if(i===11){
                    h.rotation=h.rotation=360-(gp[i-1]+gp[i-2]+gp[i-3]+gp[i-4]+gp[i-5]+gp[i-6]+gp[i-7]+gp[i-8]+gp[i-9]+gp[i-10]+gp[i-11])
                }
                if(i!==0&&i!==6&&Qt.platform.os==='windows'){
                    h.rotation+=1
                }

            }
            gp.push(wgf)
            resta+=xArcs.children[nh].wg-(o1.mdeg/60)-(o2.mdeg/60)
            r.arrayWg.push(h.wg)
        }
    }
}
