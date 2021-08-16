import QtQuick 2.7
import QtQuick.Window 2.0
import QtQuick.Controls 2.0
import Qt.labs.settings 1.1

Rectangle {
    id: r
    visible: false
    color: 'white'
    anchors.fill: parent
    property real fz: 1.0
    property string htmlFolder: ''
    property var signos: ['Aries', 'Tauro', 'Géminis', 'Cáncer', 'Leo', 'Virgo', 'Libra', 'Escorpio', 'Sagitario', 'Capricornio', 'Acuario', 'Piscis']
    property int numSign: 0
    property int numDegree: 0
    property int fs: width*0.025
    property real factorZoomByRes: 1.5
    property int currentInterpreter: 0

    MouseArea{
        anchors.fill: parent
    }

    Row{
        id: rowTit
        spacing: r.fs*0.25
        anchors.horizontalCenter: parent.horizontalCenter
        Text {
            id: currentSign
            text: '<b>Simbología de los Sabianos</b> - <b>'+r.signos[r.numSign]+'</b>'
            font.pixelSize: r.fs*2
            anchors.verticalCenter: parent.verticalCenter
        }
        Item {
            id: xSigno
            width: app.fs*1.8
            height: width
            Rectangle{
                anchors.fill: xSigno
                radius: app.fs*0.25
                color: 'white'
                border.width: 2
                border.color: 'black'
                Image {
                    id: sign
                    source: "./resources/imgs/signos/"+r.numSign+".svg"
                    width: xSigno.width*0.8
                    fillMode: Image.PreserveAspectFit
                    anchors.centerIn: parent
                }
            }
        }
    }
    Text{
        id: data
        width: r.width-app.fs*0.25
        anchors.horizontalCenter: r.horizontalCenter
        anchors.top: rowTit.bottom
        anchors.topMargin: app.fs*0.5
        text: '<h1>Los Sabianos</h1>'
        font.pixelSize: r.fs
        wrapMode: Text.WordWrap
        textFormat: Text.RichText
    }
    Rectangle{
        id: xZoom
        width: app.fs*4
        height: r.height
        x:r.width-width
        color: 'transparent'
        Column{
            anchors.centerIn: parent
            Rectangle{
                width: xZoom.width
                height: xZoom.height/2
                color: 'transparent'
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        zoomUp()
                    }
                }
            }
            Rectangle{
                width: xZoom.width
                height: xZoom.height/2
                color: 'transparent'
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        zoomDown()
                    }
                }
            }
        }
    }
    Text {
        id: currentDegree
        property string sd: '?'
        text: '<b>'+sd+'</b>'//+' ci:'+r.currentInterpreter+' ad:'+r.numDegree+' cs:'+r.numSign
        font.pixelSize: r.fs*2
        //color: 'white'
        anchors.bottom: parent.bottom
        visible: false
    }
    Component.onCompleted: {
        if(Screen.width===1280&&Screen.height===720)r.factorZoomByRes=2.0
        if(Screen.width===1920&&Screen.height===1080)r.factorZoomByRes=1.5
    }
    function ctrlDown(){
        if(r.numSign<11){
            r.numSign++
        }else{
            r.numSign=0
            r.currentInterpreter=0
        }
        loadData()
    }
    function ctrlUp(){
        if(r.numSign>0){
            r.numSign--
        }else{
            r.numSign=11
            r.currentInterpreter=0
        }
        loadData()
    }
    function down(){
        if(r.numDegree<30){
            r.numDegree++
        }else{
            r.numDegree=0
            r.currentInterpreter=0
        }
        loadData()
    }
    function up(){
        if(r.numDegree>0){
            r.numDegree--
        }else{
            r.numDegree=30
            r.currentInterpreter=0
        }
        loadData()
    }
    function left(){
        if(r.currentInterpreter>0){
            r.currentInterpreter--
        }else{
            r.currentInterpreter=2
            if(r.numDegree>0){
                r.numDegree--
            }else{
                r.numDegree=29
                r.currentInterpreter=2
                if(r.numSign>0){
                    r.numSign--
                }else{
                    r.numSign=11
                }
            }
        }
        loadData()
    }
    function right(){
        if(r.currentInterpreter<2){
            r.currentInterpreter++
        }else{
            r.currentInterpreter=0
            if(r.numDegree<29){
                r.numDegree++
            }else{
                r.numDegree=0
                r.currentInterpreter=0
                if(r.numSign<11){
                    r.numSign++
                }else{
                    r.numSign=0
                }
            }
        }
        loadData()
    }
    function loadData(){
        let gz=getJsonZoom(r.numSign, r.numDegree, r.currentInterpreter)
        let zoom=parseFloat(gz).toFixed(1)
        if(zoom<0.1){
            zoom=0.1
            setJsonZoom(r.numSign, r.numDegree, r.currentInterpreter, zoom)
        }
        //setJsonZoom(r.numSign, r.numDegree, r.currentInterpreter, zoom)
        r.fz=parseFloat(zoom).toFixed(1)
        if(r.fz<0.5){
            r.fz=0.5
        }
        data.font.pixelSize=r.fs*r.factorZoomByRes*r.fz
        let fileData=''+unik.getFile('./360.html')
        let dataSign=fileData.split('---')
        let stringSplit=''
        if(r.numDegree<=8){
            stringSplit='0'+parseInt(r.numDegree+1)+'°:'
        }else{
            stringSplit=''+parseInt(r.numDegree+1)+'°:'
        }
        let signData=''+dataSign[r.numSign+1]
        //console.log('\n\n\nAries---->>'+signData+'\n\n\n')
        let dataDegree=signData.split('<p ')
        let htmlPrevio=''
        let cp=0
        currentDegree.sd=stringSplit
        for(var i=0;i<dataDegree.length;i++){
            //console.log('\n\n\n\n'+stringSplit+'----------->>'+dataDegree[i])
            if(dataDegree[i].indexOf(stringSplit)>0){
                htmlPrevio+='<p '+dataDegree[i]
                cp++
                //console.log('\n\n----------->>'+htmlPrevio)
            }
        }
        console.log('Cantidad '+cp)
        let mapHtmlDegree=htmlPrevio.split('<p ')
        let dataFinal='<p '+mapHtmlDegree[r.currentInterpreter + 1]


        if(dataFinal.indexOf('<p class="entry-excerpt" style="text-align: justify;"><strong><span style="color: rgb(255, 0, 0);">'>=0)){
            dataFinal=dataFinal.replace('<p class="entry-excerpt" style="text-align: justify;"><strong>','<p class="entry-excerpt" style="text-align: justify;color:red"><strong>')
        }else{
            dataFinal=dataFinal.replace('<p class="entry-excerpt" style="text-align: justify;"><strong>','<p class="entry-excerpt" style="text-align: justify;color:green"><strong>')
        }
        data.text=dataFinal
        //console.log('DATA:::'+dataFinal)
    }
    function getHtmlData(s, g, item){
        let fileData=''+unik.getFile('360.html')
        let dataSign=fileData.split('---')
        let stringSplit=''
        if(g<=8){
            stringSplit='0'+parseInt(g+1)+'°:'
        }else{
            stringSplit=''+parseInt(g+1)+'°:'
        }
        let signData=''+dataSign[s+1]
        //console.log('\n\n\nAries---->>'+signData+'\n\n\n')
        let dataDegree=signData.split('<p ')
        let htmlPrevio=''
        let cp=0
        currentDegree.sd=stringSplit
        for(var i=0;i<dataDegree.length;i++){
            //console.log('\n\n\n\n'+stringSplit+'----------->>'+dataDegree[i])
            if(dataDegree[i].indexOf(stringSplit)>0){
                htmlPrevio+='<p '+dataDegree[i]
                cp++
                //console.log('\n\n----------->>'+htmlPrevio)
            }
        }
        let mapHtmlDegree=htmlPrevio.split('<p ')
        let dataFinal=item===0?'<h3> Grado °'+parseInt(g + 1)+' de '+r.signos[s]+'</h3>\n':''
        dataFinal+='<p '+mapHtmlDegree[item + 1]
        if(rs.bgColor!=='#ffffff'){
            if(dataFinal.indexOf('<p class="entry-excerpt" style="text-align: left;"><strong><span style="color:')<0&&dataFinal.indexOf('<p class="entry-excerpt" style="text-align: left;"><span>strong style="color:')<0){
                dataFinal=dataFinal.replace('<p class="entry-excerpt" style="text-align: left;"><strong>','<p class="entry-excerpt" style="text-align: left;color:#ffffff"><strong>')
                dataFinal=dataFinal.replace('<p class="entry-excerpt" style="text-align: left;"><span ','<p class="entry-excerpt" style="text-align: left;color:#ffffff"><span ')
                dataFinal=dataFinal.replace('style="color: rgb(0, 0, 255);','style="color: rgb(255, 255, 255);')
            }else{
                if(dataFinal.indexOf('<p class="entry-excerpt" style="text-align: left;"><strong><span style="color: rgb(255, 0, 0);">'>=0)){
                    dataFinal=dataFinal.replace('<p class="entry-excerpt" style="text-align: left;"><strong>','<p class="entry-excerpt" style="text-align: left;color:red"><strong>')
                }else{
                    dataFinal=dataFinal.replace('<p class="entry-excerpt" style="text-align: left;"><strong>','<p class="entry-excerpt" style="text-align: left;color:green"><strong>')
                }
            }
        }
        return dataFinal.replace(/style=\"text-align: justify;\"/g,'').replace(/&nbsp; /g, ' ')
    }
    function setHtml(html, nom){
        let htmlFinal='<DOCTYPE html>
<html>
<head>
    <title>'+nom+'</title>
</head>
    <body style="background-color:#ffffff;">
        <h1>Ajustando hora de nacimiento de '+nom+'</h1>
        <p>En esta página hay 3 grupos con 3 textos. Tenés que avisar cuál de todos estos grupos te parece que tiene más que ver con tu vida o tu forma de ser.</p>
        <p>Los textos que vas a leer a continuación, son como descripciones de imágenes que simbolizan una escena de algo que se puede presentar en tu vida de algn modo parecido o similar.</p>
        <p><b>Aviso: </b>Los textos en color rojo son algo negativos. Tantos los textos azules o rojos puede ser que aún no se hayan producido.</p>
        <br/>
        <h2>¿Cuál de los siguientes grupos de textos pensas que hablan de cosas más parecidas a tu vida o forma de ser?</h2>
        <br/>\n'
+html+
'<br />
         <br />
    </body>
</html>'
        unik.setFile('/home/ns/nsp/uda/nextsigner.github.io/sabianos/'+nom+'.html', htmlFinal)
    }
    function setJsonZoom(numSign, numDegree, numItem, zoom){
        let jsonFile='./sabianosJsonZoom.json'
        let existe=unik.fileExist(jsonFile)
        let jsonString=''
        let newJsonString=''
        if(existe){
            jsonString=unik.getFile(jsonFile)
        }
        let arrayLines=jsonString.split('\n')
        let nomItem='pos_'+numSign+'_'+numDegree+'_'+numItem
        let e=false
        for(var i=0;i<arrayLines.length;i++){
            if(arrayLines[i].indexOf(nomItem)<0&&arrayLines[i].indexOf('pos_')>=0){
                newJsonString+=arrayLines[i]+'\n'
            }
        }
        //if(!e){
        newJsonString+=nomItem+'='+zoom+'\n'
        //}
        unik.setFile(jsonFile, newJsonString)
    }
    function getJsonZoom(numSign, numDegree, numItem){
        let jsonFile='./sabianosJsonZoom.json'
        let existe=unik.fileExist(jsonFile)
        let jsonString=''
        if(existe){
            jsonString=unik.getFile(jsonFile)
        }
        let arrayLines=jsonString.split('\n')
        let nomItem='pos_'+numSign+'_'+numDegree+'_'+numItem
        let zoom="1.0"
        for(var i=0;i<arrayLines.length;i++){
            if(arrayLines[i].indexOf(nomItem)>=0){
                zoom=""+arrayLines[i].split('=')[1]
                break
            }
        }
        return zoom
    }
    function zoomDown(){
        let gz=getJsonZoom(r.numSign, r.numDegree, r.currentInterpreter)
        console.log('gz baja:'+gz)
        let zoom=parseFloat(gz).toFixed(1)
        console.log('Z1:'+zoom)
        if(zoom==='NaN'){
            console.log('NaN! :'+zoom)
            return
        }
        r.fz-=0.1
        if(r.fz<0.01){
            r.fz=0.01
        }
        zoom=parseFloat(r.fz).toFixed(1)
        //unik.speak('Sube '+zoom)


        data.font.pixelSize=r.fs*2*r.fz
        console.log('SETZOOM:'+zoom)
        setJsonZoom(r.numSign, r.numDegree, r.currentInterpreter, zoom)
        r.loadData()
    }
    function zoomUp(){
        let gz=getJsonZoom(r.numSign, r.numDegree, r.currentInterpreter)
        console.log('gz sube:'+gz)
        let zoom=parseFloat(gz).toFixed(1)
        console.log('Z1:'+zoom)
        if(zoom==='NaN'){
            console.log('NaN! :'+zoom)
            return
        }
        r.fz+=0.1
        zoom=parseFloat(r.fz).toFixed(1)
        //unik.speak('Baja '+zoom)
        /*if(zoom<1.0){
                zoom=parseFloat(1).toFixed(1)
            }*/
        data.font.pixelSize=r.fs*2*r.fz
        console.log('SETZOOM:'+zoom)
        setJsonZoom(r.numSign, r.numDegree, r.currentInterpreter, zoom)
        r.loadData()
    }
}

