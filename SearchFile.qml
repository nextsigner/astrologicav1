import QtQuick 2.0

Item{
    id: r
    width: parent.width-app.fs
    height: col.height+app.fs
    signal nameSeted(string name)
    Column{
        id: col
        anchors.centerIn: r
        spacing: app.fs
        Row{
            spacing: app.fs*0.5
            XText {
                id: l1
                text: '<b>Archivo:</b>'
                font.pixelSize: app.fs*0.5
                color: 'white'
                anchors.verticalCenter: parent.verticalCenter
            }
            Rectangle{
                width: r.width-l1.contentWidth-app.fs
                height: app.fs*1.5
                border.width: 1
                border.color: 'white'
                color: 'black'
                radius: app.fs*0.25
                anchors.verticalCenter: parent.verticalCenter
                clip: true
                TextInput {
                    id: ti1
                    width: parent.width-app.fs*0.25
                    height: parent.height-app.fs*0.5
                    font.pixelSize: app.fs*0.5
                    color: 'white'
                    anchors.centerIn: parent
                    Keys.onReturnPressed: {
                        let s1=ti1.text.replace(/ /g, '_')
                        nameSeted(s)
                    }
                }
            }
        }
    }
    XLoadingCoords{id: xLoadingCoords}
    function getCoords(text){
        xLoadingCoords.ciudad=text
        xLoadingCoords.visible=true
        let md=["Seleccionar Ciudad"]
        r.lon=''
        r.lat=''
        let c=''
            +'import QtQuick 2.0'+'\n'
            +'UGeoLocCoordsSearch{'+'\n'
            +'  url: \'https://www.google.com/maps?q='+text.replace(/ /g, '%20')+'\''+'\n'
            +'  onCoordsLoaded: {'+'\n'
        //+'      console.log(\'Url final: \'+url)'+'\n'
        //+'      console.log(\'lon: \'+longitude+\' lat: \'+latitude+\' alt: \'+altitude)'+'\n'
            +'          r.lon=parseFloat(longitude)'+'\n'
            +'          r.lat=parseFloat(latitude)'+'\n'
        //+'          if(r.autoLaunch){'+'\n'
            +'                runAutoLaunch(r.lon, r.lat)'+'\n'
        //+'                return'+'\n'
        //+'           }'+'\n'
        //+'          statusLugar.text=\'Coordenadas: lon: \'+r.lon+\' lat: \'+r.lat'+'\n'
        //+'          r.opacity=0.5\n'
            +'          //botCopyCoords.coords=\'lon: \'+r.lon+\' lat:\'+r.lat\n'
            +'          //botCopyCoords.visible=true\n'
            +'          xLoadingCoords.visible=false'+'\n'
            +'  }'+'\n'
            +'}'+'\n'
        let comp=Qt.createQmlObject(c, r, 'getCoords')
    }
    function runAutoLaunch(lon, lat){
        let mFecha=r.alFecha.split('/')
        let mHora=r.alHora.split(':')
        let d=new Date(Date.now())
        let ms=d.getTime()
        let cmd2='wine /home/ns/zodiacserver/bin/zodiac_server.exe '+r.alNom.replace(/ /g, '_')+' '+mFecha[2]+' '+mFecha[1]+' '+mFecha[0]+' '+mHora[0]+' '+mHora[1]+' '+r.alGMT+' '+lat+' '+lon+' '+r.alLugar.replace(/ /g, '_')+' /home/ns/temp-screenshots/'+r.alNom.replace(/ /g, '_')+'.json '+ms+' 3 "/home/ns/temp-screenshots/cap_'+r.alNom.replace(/ /g, '_')+'.png" 2560x1440 2560x1440'
        unik.run(cmd2)
        //Qt.quit()
    }
}
