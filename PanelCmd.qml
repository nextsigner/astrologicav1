import QtQuick 2.7
import QtQuick.Controls 2.0
import Qt.labs.folderlistmodel 2.12
import "comps" as Comps
import "Funcs.js" as JS

Rectangle {
    id: r
    width: parent.width
    height: app.fs
    border.width: 2
    border.color: 'white'
    color: 'black'
    //y:r.parent.height
    property real lat
    property real lon

    property string uCmd: ''

    state: 'hide'
    states: [
        State {
            name: "show"
            PropertyChanges {
                target: r
                y:0//r.parent.height-r.height
                //z:1000
            }
        },
        State {
            name: "hide"
            PropertyChanges {
                target: r
                y:r.height
            }
        }
    ]
    Behavior on y{enabled: app.enableAn;NumberAnimation{duration: app.msDesDuration}}
    onStateChanged: {
        if(state==='show')tiCmd.t.focus=true
        JS.raiseItem(r)
    }
    onXChanged: {
        if(x===0){
            //txtDataSearch.selectAll()
            //txtDataSearch.focus=true
        }
    }
    Comps.XTextInput{
        id: tiCmd
        width: r.width
        height: r.height
        t.font.pixelSize: app.fs*0.65
        //bw.width: 0
        //anchors.verticalCenter: parent.verticalCenter
        anchors.centerIn: parent
        Keys.onReturnPressed: {
            runCmd(text)
        }
        //KeyNavigation.tab: tiFecha.t
        //t.maximumLength: 30
    }
    Item{id: xuqp}
    function runCmd(cmd){
        for(var i=0;i<xuqp.children.length;i++){
            xuqp.children[i].destroy(0)
        }
        let d = new Date(Date.now())
        let ms=d.getTime()
        let finalCmd=''
        let c=''
        let comando=cmd.split(' ')
        if(comando.length<1)return
        if(comando[0]==='setzmt'){
            if(comando.length<4){
                console.log('Error al setear el panelZonaMes: Faltan argumentos. setCurrentTime(q,m,y)')
                return
            }
            panelZonaMes.setCurrentTime(comando[1], comando[2], comando[3])
            return
        }

        if(comando[0]==='eclipse'){
            if(comando.length<5)return
            c='let json=JSON.parse(logData)
r.state="hide"
sweg.objEclipseCircle.setEclipse(json.gdec, json.rsgdeg, json.gdeg, json.mdeg, json.is)
sweg.objEclipseCircle.typeEclipse='+comando[4]+''
            sweg.objHousesCircle.currentHouse=-1

            finalCmd=''
                    +app.pythonLocation+' '+app.pythonLocation+'/py/astrologica_swe_search_eclipses.py '+comando[1]+' '+comando[2]+' '+comando[3]+' '+comando[4]+' '+comando[5]+''
        }
        if(comando[0]==='rs'){
            if(comando.length<1)return
            let cd=app.currentDate
            cd = cd.setFullYear(parseInt(comando[1]))
            let cd2=new Date(cd)
            cd2 = cd2.setDate(cd2.getDate() - 1)
            let cd3=new Date(cd2)
            finalCmd=''
                    +app.pythonLocation+' '+app.mainLocation+'/py/astrologica_swe_search_revsol.py '+cd3.getDate()+' '+parseInt(cd3.getMonth() +1)+' '+cd3.getFullYear()+' '+cd3.getHours()+' '+cd3.getMinutes()+' '+app.currentGmt+' '+app.currentLat+' '+app.currentLon+' '+app.currentGradoSolar+' '+app.currentMinutoSolar+' '+app.currentSegundoSolar+''
            //console.log('finalCmd: '+finalCmd)
            c=''
            c+=''
                    +'  let s=""+logData\n'
                    +'  //console.log("RS: "+s)\n'
                    +'  r.state="hide"\n'
                    +'  app.mod="rs"\n'
                    +'  sweg.loadSweJson(s)\n'
                    +'  swegz.sweg.loadSweJson(s)\n'
                    +'  let j=JSON.parse(s)\n'
                    +'  let o=j.params\n'
                    +'  let m0=o.sdgmt.split(" ")\n'
                    +'  let m1=m0[0].split("/")\n'
                    +'  let m2=m0[1].split(":")\n'
                    +'  JS.setTitleData("Revolución Solar '+comando[1]+' de '+app.currentNom+'",  m1[0],m1[1], m1[2], m2[0], m2[1], '+app.currentGmt+', "'+app.currentLugar+'", '+app.currentLat+','+app.currentLon+', 1)\n'
        }
        if(comando[0]==='rsl'){
            if(cmd===r.uCmd){
                panelRsList.state=panelRsList.state==='show'?'hide':'show'
                return
            }
            if(comando.length<1)return
            if(parseInt(comando[1])>=1){
                panelRsList.setRsList(parseInt(comando[1])+ 1)
                panelRsList.state='show'
            }
        }

        //Set app.uson and Show IW
        if(comando[0]==='info'){
            if(comando.length<1)return
            app.uSon=comando[1]
            JS.showIW()
            return
        }


        mkCmd(finalCmd, c)
        r.uCmd=cmd
    }
    function mkCmd(finalCmd, code){
        for(var i=0;i<xuqp.children.length;i++){
            xuqp.children[i].destroy(0)
        }
        let d = new Date(Date.now())
        let ms=d.getTime()
        let c='import QtQuick 2.0\n'
        c+='import unik.UnikQProcess 1.0\n'
        c+='import "Funcs.js" as JS\n'
        c+='UnikQProcess{\n'
        c+='    id: uqp'+ms+'\n'
        c+='    onLogDataChanged:{\n'
        c+='        '+code+'\n'
        c+='        uqp'+ms+'.destroy(0)\n'
        c+='    }\n'
        c+='    Component.onCompleted:{\n'
        c+='        run(\''+finalCmd+'\')\n'
        c+='    }\n'
        c+='}\n'
        let comp=Qt.createQmlObject(c, xuqp, 'uqpcodecmd')
    }
    function enter(){
        runCmd(tiCmd.text)
    }
    function makeRS(date){
        let cd=date
        cd = cd.setFullYear(date.getFullYear())
        let cd2=new Date(cd)
        cd2 = cd2.setDate(cd2.getDate() - 1)
        let cd3=new Date(cd2)
        let finalCmd=''
            +app.pythonLocation+' '+app.mainLocation+'/py/astrologica_swe_search_revsol.py '+cd3.getDate()+' '+parseInt(cd3.getMonth() +1)+' '+cd3.getFullYear()+' '+cd3.getHours()+' '+cd3.getMinutes()+' '+app.currentGmt+' '+app.currentLat+' '+app.currentLon+' '+app.currentGradoSolar+' '+app.currentMinutoSolar+' '+app.currentSegundoSolar+''
        //console.log('finalCmd: '+finalCmd)
        let c=''
        c+=''
                +'  if(logData.length<=3||logData==="")return\n'
                +'  let j\n'
                +'try {\n'
                +'      let s=""+logData\n'
                +'      //console.log("RS: "+s)\n'
                +'      r.state="hide"\n'
                +'      app.mod="rs"\n'
                +'      sweg.loadSweJson(s)\n'
                +'      swegz.sweg.loadSweJson(s)\n'
                +'      let j=JSON.parse(s)\n'
                +'      let o=j.params\n'
                +'      let m0=o.sdgmt.split(" ")\n'
                +'      let m1=m0[0].split("/")\n'
                +'      let m2=m0[1].split(":")\n'
                +'      JS.setTitleData("Revolución Solar '+date.getFullYear()+' de '+app.currentNom+'",  m1[0],m1[1], m1[2], m2[0], m2[1], '+app.currentGmt+', "'+app.currentLugar+'", '+app.currentLat+','+app.currentLon+', 1)\n'
                +'      logData=""\n'
                +'} catch(e) {\n'
                +'  console.log("Error makeRS Code: "+e+" "+logData);\n'
                +'  //unik.speak("error");\n'
                +'}\n'

        mkCmd(finalCmd, c)
    }
}
