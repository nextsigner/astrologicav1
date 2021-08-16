import QtQuick 2.7
import QtQuick.Controls 2.0
import Qt.labs.folderlistmodel 2.12
import "Funcs.js" as JS

Rectangle {
    id: r
    width: parent.width
    height: parent.height
    color: 'black'
    border.width: 2
    border.color: 'white'
    property alias currentIndex: lv.currentIndex
    property alias listModel: lm
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
    Behavior on x{enabled: app.enableAn;NumberAnimation{duration: app.msDesDuration}}
    onStateChanged: {
        if(state==='hide')txtDataSearch.focus=false
        //JS.raiseItem(r)
        xApp.focus=true
    }
    onXChanged: {
        if(x===0){
            txtDataSearch.selectAll()
            txtDataSearch.focus=true
        }
    }
    FolderListModel{
        id: flm
        //folder: 'file:./'+app.mainLocation+'/jsons'
        folder: 'file:'+apps.jsonsFolder
        showDirs: false
        showFiles: true
        showHidden: false
        nameFilters: [ "*.json" ]
        sortReversed: true
        sortField: FolderListModel.Time
        onCountChanged: {
            updateList()
        }
    }

    Column{
        anchors.horizontalCenter: parent.horizontalCenter
        Rectangle{
            id:xTit
            width: lv.width
            height: app.fs*1.5
            color: 'black'
            border.width: 2
            border.color: txtDataSearch.focus?'red':'white'
            anchors.horizontalCenter: parent.horizontalCenter
            TextInput {
                id: txtDataSearch
                text: 'Archivos'
                font.pixelSize: app.fs*0.5
                width: parent.width-app.fs
                wrapMode: Text.WordWrap
                color: 'white'
                focus: true
                anchors.centerIn: parent
                Keys.onReturnPressed: {
                    JS.loadJson(lm.get(lv.currentIndex).fileName)
                    r.state='hide'
                }
                Keys.onRightPressed: {
                    JS.loadJsonNow(lm.get(lv.currentIndex).fileName)
                    r.state='hide'
                }
                Keys.onDownPressed: {
                    //Qt.quit()
                    //focus=false
                    //xApp.focus=true
                }
                onTextChanged: {
                    updateList()
                }
                onFocusChanged: {
                    if(focus)selectAll()
                }
                Rectangle{
                    width: parent.width+app.fs
                    height: parent.height+app.fs
                    color: 'transparent'
                    border.width: 2
                    border.color: 'white'
                    z: parent.z-1
                    anchors.centerIn: parent
                }
            }
        }
        ListView{
            id: lv
            width: r.width
            height: r.height-xTit.height
            anchors.horizontalCenter: parent.horizontalCenter
            delegate: compItemList
            model: lm
            clip: true
        }
    }


    ListModel{
        id: lm
        function addItem(vFileName, vData){
            return {
                fileName: vFileName,
                dato: vData
            }
        }
    }
    Component{
        id: compItemList
        Rectangle{
            width: lv.width
            height: txtData.contentHeight+app.fs
            color: index===lv.currentIndex?'white':'black'
            border.width: index===lv.currentIndex?4:2
            border.color: 'white'
            Text {
                id: txtData
                text: dato
                font.pixelSize: app.fs*0.5
                width: parent.width-app.fs
                wrapMode: Text.WordWrap
                textFormat: Text.RichText
                color: index===lv.currentIndex?'black':'white'
                anchors.centerIn: parent
            }
            MouseArea{
                anchors.fill: parent
                onClicked: lv.currentIndex=index
                onDoubleClicked: {
                    JS.loadJson(fileName)
                    r.state='hide'
                }
            }
            Rectangle{
                width: txtDelete.contentWidth+app.fs*0.25
                height: width
                radius: app.fs*0.3
                anchors.right: parent.right
                anchors.rightMargin: app.fs*0.3
                anchors.top: parent.top
                anchors.topMargin: app.fs*0.3
                Text {
                    id: txtDelete
                    text: 'X'
                    font.pixelSize: app.fs*0.25
                    anchors.centerIn: parent
                }
                MouseArea{
                    anchors.fill: parent
                    onDoubleClicked: deleteVnData(fileName)
                }
            }
        }
    }

    function deleteVnData(fileName){
        unik.deleteFile(fileName)
        let fn=fileName.replace('cap_', '').replace('.png', '')
        let jsonFileName=fn+'.json'
        unik.deleteFile(jsonFileName)
        updateList()
    }
    function getEdad(dateString) {
        let hoy = new Date()
        let fechaNacimiento = new Date(dateString)
        let edad = hoy.getFullYear() - fechaNacimiento.getFullYear()
        let diferenciaMeses = hoy.getMonth() - fechaNacimiento.getMonth()
        if (
                diferenciaMeses < 0 ||
                (diferenciaMeses === 0 && hoy.getDate() < fechaNacimiento.getDate())
                ) {
            edad--
        }
        return edad
    }
    function updateList(){
        lm.clear()
        for(var i=0;i<flm.count;i++){
            //let file='/home/ns/nsp/uda/astrologica/jsons/'+flm.get(i, 'fileName')
            //let file=app.mainLocation+'/jsons/'+flm.get(i, 'fileName')
            let file=apps.jsonsFolder+'/'+flm.get(i, 'fileName')
            let fn=file//.replace('cap_', '').replace('.png', '')
            let jsonFileName=fn
            //console.log('FileName: '+jsonFileName)

            let jsonFileData=unik.getFile(jsonFileName)
            //console.log(jsonFileData)
            let jsonData=JSON.parse(jsonFileData)
            let nom=''+jsonData.params.n.replace(/_/g, ' ')
            if(nom.toLowerCase().indexOf(txtDataSearch.text.toLowerCase())>=0){
                if(jsonData.asp){
                    //console.log('Aspectos: '+JSON.stringify(jsonData.asp))
                }
                let vd=jsonData.params.d
                let vm=jsonData.params.m
                let va=jsonData.params.a
                let vh=jsonData.params.h
                let vmin=jsonData.params.min
                let vgmt=jsonData.params.gmt
                let vlon=jsonData.params.lon
                let vlat=jsonData.params.lat
                let vCiudad=jsonData.params.ciudad.replace(/_/g, ' ')
                let edad=' <b>Edad:</b> '+getEdad(""+va+"/"+vm+"/"+vd+" "+vh+":"+vmin+":00")
                let stringEdad=edad.indexOf('NaN')<0?edad:''
                let textData=''
                    +'<b>'+nom+'</b>'
                    +'<p style="font-size:20px;">'+vd+'/'+vm+'/'+va+' '+vh+':'+vmin+'hs GMT '+vgmt+stringEdad+'</p>'
                    +'<p style="font-size:20px;"><b> '+vCiudad+'</b></p>'
                    +'<p style="font-size:20px;"> <b>long:</b> '+vlon+' <b>lat:</b> '+vlat+'</p>'
                //xNombre.nom=textData
                lm.append(lm.addItem(file,textData))
            }
            txtDataSearch.focus=true
            //txtDataSearch.selectAll()
        }
    }
}
