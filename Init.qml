import QtQuick 2.0

Item {
    id: r
    property string longAppName: 'iconAppNameEmpty'
    property string folderName: 'folderAppNameEmpty'

    Component.onCompleted: {
        if(Qt.platform.os==='linux'){
            let s="#!/usr/bin/env xdg-open\n"
                +"[Desktop Entry]\n"
                +"Name="+r.longAppName+"\n"
                +"Comment=Aplicación para Visualizar simbolos de astrología.\n"
                //+"Exec=/usr/local/bin/unik -folder=/home/ns/nsp/uda/"+r.folderName+"\n"
                +"Exec=/usr/local/bin/zool\n"
                +"Icon="+unik.getPath(4)+"/img/icon.png\n"
                +"Terminal=false\nType=Application"
            let desktopPath=unik.getPath(6)
            let fn=desktopPath+'/'+r.folderName+'.desktop'
            console.log('Make desktop file: '+fn)
            unik.setFile(fn, s)
        }
    }
}
