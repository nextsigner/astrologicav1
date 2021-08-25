import QtQuick 2.7
import QtQuick.Controls 2.0
import Qt.labs.folderlistmodel 2.12
import "comps" as Comps
import "Funcs.js" as JS
Rectangle {
    id: r
    width: parent.width
    height: parent.height
    color: 'black'
    border.width: 2
    border.color: 'white'
    x:0-r.width
    property real lat:-100.00
    property real lon:-100.00

    property real ulat:-100.00
    property real ulon:-100.00

    property string uFileNameLoaded: ''

    state: 'hide'
    states: [
        State {
            name: "show"
            PropertyChanges {
                target: r
                x:0
            }
        },
        State {
            name: "hide"
            PropertyChanges {
                target: r
                x:0-r.width
            }
        }
    ]
    Behavior on x{enabled: apps.enableFullAnimation;NumberAnimation{duration: app.msDesDuration}}
    onStateChanged: {
        if(state==='show')tiNombre.t.focus=true
        //JS.raiseItem(r)
        //xApp.focus=true
    }
    onXChanged: {
        if(x===0){
            //txtDataSearch.selectAll()
            //txtDataSearch.focus=true
        }
    }
    Column{
        id: col
        anchors.centerIn: parent
        spacing: app.fs*0.25
        Text{
            text: '<b>Creando VNA</b>'
            font.pixelSize: app.fs
            color: 'white'
        }
        Item{width: 1;height: app.fs*0.5}
        Column{
            anchors.horizontalCenter: parent.horizontalCenter
            Comps.XText{
                text:'Nombre:'
                t.font.pixelSize: app.fs*0.35
                height: app.fs*0.8
            }
            Comps.XTextInput{
                id: tiNombre
                width: r.width-app.fs*0.5
                t.font.pixelSize: app.fs*0.65
                anchors.horizontalCenter: parent.horizontalCenter
                KeyNavigation.tab: tiFecha.t
                t.maximumLength: 30
            }
        }
        Row{
            spacing: app.fs*0.5
            anchors.horizontalCenter: parent.horizontalCenter
            Comps.XText{text:'Fecha:'; t.font.pixelSize: app.fs*0.35;height: app.fs*0.8}
            Comps.XTextInput{
                id: tiFecha;
                width: app.fs*4;
                t.font.pixelSize: app.fs*0.65;
                c: true
                KeyNavigation.tab: tiHora.t
                t.inputMask: "00/00/0000"
            }
        }
        Row{
            //spacing: app.fs*0.5
            anchors.horizontalCenter: parent.horizontalCenter
            Row{
                spacing: app.fs*0.2
                Comps.XText{text:'Hora:'; t.font.pixelSize: app.fs*0.35;height: app.fs*0.8}
                Comps.XTextInput{
                    id: tiHora;
                    width: app.fs*2;
                    t.font.pixelSize: app.fs*0.65;
                    c: true
                    KeyNavigation.tab: tiGMT.t
                    t.inputMask: "00:00"
                    t.color: valid?'white':'red'
                    property   bool valid: false
                    onTextChanged: {
                        let s=text.split(':')
                        if(s[0].length<2||s[1].length<2){
                            valid=false
                        }else{
                            valid=true
                        }
                    }
                }
            }
            Row{
                spacing: app.fs*0.1
                Comps.XText{text:'GMT:'; t.font.pixelSize: app.fs*0.35;height: app.fs*0.8}
                Comps.XTextInput{
                    id: tiGMT;
                    width: app.fs*2;
                    t.font.pixelSize: app.fs*0.65;
                    c: true
                    KeyNavigation.tab: tiCiudad.t
                    t.validator: IntValidator {
                        bottom: parseInt(-11)
                        top: parseInt(12)
                    }
                }
            }
        }
        Column{
            anchors.horizontalCenter: parent.horizontalCenter
            Comps.XText{text:'Lugar:'; t.font.pixelSize: app.fs*0.35;height: app.fs*0.8}
            Comps.XTextInput{
                id: tiCiudad
                width: tiNombre.width
                t.font.pixelSize: app.fs*0.65;
                KeyNavigation.tab: botCrear
                t.maximumLength: 50
                onTextChanged: {
                    //searchGeoLoc(false)
                    t.color='white'
                }
            }
        }
        Column{
            id: colLatLon
            anchors.horizontalCenter: parent.horizontalCenter
            visible: r.lat===r.ulat&&r.lon===r.ulon
            Text{
                text: 'Lat:'+r.lat
                font.pixelSize: app.fs*0.5
                color: 'white'
                opacity: r.lat!==-100.00?1.0:0.0
            }
            Text{
                text: 'Lon:'+r.lon
                font.pixelSize: app.fs*0.5
                color: 'white'
                opacity: r.lon!==-100.00?1.0:0.0
            }
        }
        Column{
            visible: !colLatLon.visible
            anchors.horizontalCenter: parent.horizontalCenter
            Text{
                text: 'Lat:'+r.ulat
                font.pixelSize: app.fs*0.5
                color: 'red'
                opacity: r.ulat!==-100.00?1.0:0.0
            }
            Text{
                text: 'Lon:'+r.ulon
                font.pixelSize: app.fs*0.5
                color: 'red'
                opacity: r.ulon!==-100.00?1.0:0.0
            }
        }

        Button{
            id: botCrear
            text: 'Crear'
            font.pixelSize: app.fs
            anchors.horizontalCenter: parent.horizontalCenter
            KeyNavigation.tab: tiNombre.t
            onClicked: {
                searchGeoLoc(true)
            }
            Timer{
                running: r.state==='show'
                repeat: true
                interval: 2000
                onTriggered: {
                    let nom=tiNombre.t.text.replace(/ /g, '_')
                    let fileName=apps.jsonsFolder+'/'+nom+'.json'
                    if(unik.fileExist(fileName)){
                        r.uFileNameLoaded=tiNombre.text
                        let jsonFileData=unik.getFile(fileName)
                        let j=JSON.parse(jsonFileData)
                        if(tiFecha.text.replace(/ /g, '')==='//'){
                            //unik.speak('set file')
                            let dia=''+j.params.d
                            if(parseInt(dia)<=9){
                                dia='0'+dia
                            }
                            let mes=''+j.params.m
                            if(parseInt(mes)<=9){
                                mes='0'+mes
                            }
                            tiFecha.text=dia+'/'+mes+'/'+j.params.a
                        }
                        if(tiHora.text.replace(/ /g, '')===':'){
                            //unik.speak('set file')
                            let hora=''+j.params.h
                            if(parseInt(hora)<=9){
                                hora='0'+hora
                            }
                            let minuto=''+j.params.min
                            if(parseInt(minuto)<=9){
                                minuto='0'+minuto
                            }
                            tiHora.text=hora+':'+minuto
                        }
                        if(tiGMT.text.replace(/ /g, '')===''){
                            tiGMT.text=j.params.gmt
                        }
                        if(tiCiudad.text.replace(/ /g, '')===''){
                            tiCiudad.text=j.params.ciudad
                        }
                        r.lat=j.params.lat
                        r.lon=j.params.lon
                        let m0=tiFecha.t.text.split('/')
                        if(m0.length!==3)return
                        let vd=parseInt(m0[0])
                        let vm=parseInt(m0[1])
                        let va=parseInt(m0[2])
                        m0=tiHora.t.text.split(':')
                        let vh=parseInt(m0[0])
                        let vmin=parseInt(m0[1])
                        let vgmt=tiGMT.t.text
                        let vCiudad=tiCiudad.t.text.replace(/_/g, ' ')
                        if(j.params.d!==vd||j.params.m!==vm||j.params.a!==va||j.params.h!==vh||j.params.min!==vmin||r.lat!==r.ulat||r.lon!==r.ulon){
                            botCrear.text='Modificar'
                        }else{
                            botCrear.text='[Crear]'
                        }
                    }else{
                        botCrear.text='Crear'
                    }
                }
            }
        }
    }
    Item{id: xuqp}
    function searchGeoLoc(crear){
        for(var i=0;i<xuqp.children.length;i++){
            xuqp.children[i].destroy(0)
        }
        let d = new Date(Date.now())
        let ms=d.getTime()
        let c='import QtQuick 2.0\n'
        c+='import unik.UnikQProcess 1.0\n'
        c+='UnikQProcess{\n'
        c+='    id: uqp'+ms+'\n'
        c+='    onLogDataChanged:{\n'
        c+='            console.log(logData)\n'
        c+='        let result=(\'\'+logData).replace(/\\n/g, \'\')\n'
        c+='        let json=JSON.parse(result)\n'
        c+='        if(json){\n'
        //c+='            console.log(JSON.stringify(json))\n'

        c+='                if(r.lat===-1&&r.lon===-1){\n'
        c+='                   tiCiudad.t.color="red"\n'
        c+='                }else{\n'
        c+='                   tiCiudad.t.color="white"\n'
        if(crear){
            c+='                r.lat=json.coords.lat\n'
            c+='                r.lon=json.coords.lon\n'
            c+='                    setNewJsonFileData()\n'
            c+='                    r.state=\'hide\'\n'
        }else{
            c+='                r.ulat=json.coords.lat\n'
            c+='                r.ulon=json.coords.lon\n'
        }
        c+='                }\n'
        c+='        }else{\n'
        c+='            console.log(\'No se encontraron las cordenadas.\')\n'
        c+='        }\n'
        c+='        uqp'+ms+'.destroy(0)\n'
        c+='    }\n'
        c+='    Component.onCompleted:{\n'
        //c+='        console.log(\''+app.pythonLocation+' '+app.mainLocation+'/py/astrologica_swe.py '+vd+' '+vm+' '+va+' '+vh+' '+vmin+' '+vgmt+' '+vlat+' '+vlon+'\')\n'
        c+='        run(\''+app.pythonLocation+' '+app.mainLocation+'/py/geoloc.py "'+tiCiudad.t.text+'"\')\n'
        c+='    }\n'
        c+='}\n'
        let comp=Qt.createQmlObject(c, xuqp, 'uqpcodenewvn')
    }
    function setNewJsonFileData(){
        console.log('setNewJsonFileData...')
        let unom=r.uFileNameLoaded.replace(/ /g, '_')
        let fileName=apps.jsonsFolder+'/'+unom+'.json'
        console.log('setNewJsonFileData() fileName: '+fileName)
        if(unik.fileExist(fileName)){
            unik.deleteFile(fileName)
        }
        let d = new Date(Date.now())
        let ms=d.getTime()
        let nom=tiNombre.t.text.replace(/ /g, '_')

        let m0=tiFecha.t.text.split('/')
        if(m0.length!==3)return
        let vd=parseInt(m0[0])
        let vm=parseInt(m0[1])
        let va=parseInt(m0[2])

        m0=tiHora.t.text.split(':')
        let vh=parseInt(m0[0])
        let vmin=parseInt(m0[1])

        let vgmt=tiGMT.t.text
        let vlon=r.lon
        let vlat=r.lat
        let vCiudad=tiCiudad.t.text.replace(/_/g, ' ')
        let j='{'
        j+='"params":{'
        j+='"tipo":"vn",'
        j+='"ms":'+ms+','
        j+='"n":"'+nom+'",'
        j+='"d":'+vd+','
        j+='"m":'+vm+','
        j+='"a":'+va+','
        j+='"h":'+vh+','
        j+='"min":'+vmin+','
        j+='"gmt":'+vgmt+','
        j+='"lat":'+vlat+','
        j+='"lon":'+vlon+','
        j+='"ciudad":"'+vCiudad+'"'
        j+='}'
        j+='}'
        app.currentData=j
        nom=tiNombre.t.text.replace(/ /g, '_')
        unik.setFile(apps.jsonsFolder+'/'+nom+'.json', app.currentData)
        //apps.url=app.mainLocation+'/jsons/'+nom+'.json'
        JS.loadJson(apps.jsonsFolder+'/'+nom+'.json')
        //runJsonTemp()
    }
    function enter(){
        if(botCrear.focus){
            searchGeoLoc(true)
        }
    }
}
