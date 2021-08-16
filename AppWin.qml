import QtQuick 2.12
import QtQuick.Controls 2.12


ApplicationWindow {
    id: r
    property alias ip: itemXPlanets
    Item{
        id: itemXPlanets
        anchors.fill: parent
        //XPlanets{id: xPlanets}
        Component.onCompleted: {
            if(unik.objectName!=='unikpy'){
                let comp=Qt.createComponent("XPlanets.qml")
                let obj=comp.createObject(itemXPlanets)
                if(obj){
                    app.sspEnabled=true
                }

            }
        }        
    }

    Shortcut{
        sequence: 'Ctrl+Down'
        onActivated: {
            if(xSabianos.visible){
                xSabianos.ctrlDown()
                return
            }
            xBottomBar.state=xBottomBar.state==='show'?'hide':'show'
        }
    }
    Shortcut{
        sequence: 'Ctrl+Up'
        onActivated: {
            if(xSabianos.visible){
                xSabianos.ctrlUp()
                return
            }
            xDataBar.state=xDataBar.state==='show'?'hide':'show'
        }
    }
    Shortcut{
        sequence: 'Ctrl+Space'
        onActivated: {
            if(panelZonaMes.state==='show'){
                panelZonaMes.pause()
                return
            }
            sweg.nextState()
            //swegz.sweg.nextState()
        }
    }
    Shortcut{
        sequence: 'Ctrl+0'
        onActivated: {
            panelDataBodies.currentIndex=-1
            //app.lock=!app.lock
        }
    }
    Shortcut{
        sequence: 'Enter'
        onActivated: {
            if(panelNewVNA.state==='show'){
                panelNewVNA.enter()
                return
            }
            if(panelRsList.state==='show'){
                panelRsList.enter()
                return
            }
        }
    }
    Shortcut{
        sequence: 'Esc'
        onActivated: {
            if(xSabianos.visible){
                xSabianos.visible=false
                return
            }
            if(xInfoData.visible){
                xInfoData.visible=false
                return
            }
            if(xBottomBar.objPanelCmd.state==='show'){
                xBottomBar.objPanelCmd.state='hide'
                return
            }
            if(panelFileLoader.state==='show'){
                panelFileLoader.state='hide'
                return
            }
            if(panelDataBodies.state==='show'){
                panelDataBodies.state='hide'
                return
            }
            if(panelNewVNA.state==='show'){
                panelNewVNA.state='hide'
                return
            }
            if(panelControlsSign.state==='show'){
                panelControlsSign.state='hide'
                return
            }
            if(panelRsList.state==='show'){
                panelRsList.state='hide'
                return
            }
            Qt.quit()
        }
    }
    Shortcut{
        sequence: 'Up'
        onActivated: {
            if(xSabianos.visible){
                xSabianos.up()
                return
            }
            if(panelFileLoader.state==='show'){
                if(panelFileLoader.currentIndex>0){
                    panelFileLoader.currentIndex--
                }else{
                    panelFileLoader.currentIndex=panelFileLoader.listModel.count-1
                }
                return
            }
            if(panelControlsSign.state==='show'&&panelDataBodies.state==='hide'){
                if(currentSignIndex>0){
                    currentSignIndex--
                }else{
                    currentSignIndex=12
                }
                return
            }
            if(panelRsList.state==='show'){
                if(panelRsList.currentIndex>0){
                    panelRsList.currentIndex--
                }else{
                    panelRsList.currentIndex=panelRsList.listModel.count-1
                }
                return
            }
            if(currentPlanetIndex>-1){
                currentPlanetIndex--
            }else{
                currentPlanetIndex=17
            }
            //xAreaInteractiva.back()
        }
    }
    Shortcut{
        sequence: 'Down'
        onActivated: {
            if(xSabianos.visible){
                xSabianos.down()
                return
            }
            if(panelFileLoader.state==='show'){
                if(panelFileLoader.currentIndex<panelFileLoader.listModel.count){
                    panelFileLoader.currentIndex++
                }else{
                    panelFileLoader.currentIndex=0
                }
                return
            }
            if(panelControlsSign.state==='show'&&panelDataBodies.state==='hide'){
                if(currentSignIndex<12){
                    currentSignIndex++
                }else{
                    currentSignIndex=0
                }
                return
            }
            if(panelRsList.state==='show'){
                if(panelRsList.currentIndex<panelRsList.listModel.count-1){
                    panelRsList.currentIndex++
                }else{
                    panelRsList.currentIndex=0
                }
                return
            }
            if(currentPlanetIndex<17){
                currentPlanetIndex++
            }else{
                currentPlanetIndex=-1
            }
            //xAreaInteractiva.next()
        }
    }
    Shortcut{
        sequence: 'Left'
        onActivated: {
            if(xSabianos.visible){
                xSabianos.left()
                return
            }
        }
    }
    Shortcut{
        sequence: 'Right'
        onActivated: {
            if(xSabianos.visible){
                xSabianos.right()
                return
            }
        }
    }
    Shortcut{
        sequence: 'Ctrl+Shift+a'
        onActivated: {
            apps.lt=!apps.lt
        }
    }
    //Mostrar/Ocultar MenuBar
    Shortcut{
        sequence: 'Ctrl+m'
        onActivated: {
            apps.showMenuBar=!apps.showMenuBar
        }
    }
    //Mostrar / Ocultar Decanatos
    Shortcut{
        sequence: 'Ctrl+Shift+d'
        onActivated: {
            apps.showDec=!apps.showDec
            //swegz.sweg.objSignsCircle.showDec=!swegz.sweg.objSignsCircle.showDec
        }
    }
    //Mostrar Panel para Cargar Archivos
    Shortcut{
        sequence: 'Ctrl+f'
        onActivated: {
            panelFileLoader.state=panelFileLoader.state==='show'?'hide':'show'
        }
    }
    //Mostrar Panel PL Signos
    Shortcut{
        sequence: 'Ctrl+w'
        onActivated: {
            panelControlsSign.state=panelControlsSign.state==='show'?'hide':'show'
        }
    }
    //Mostrar Panel Editor de Pronósticos
    Shortcut{
        sequence: 'Ctrl+e'
        onActivated: {
            panelPronEdit.state=panelPronEdit.state==='show'?'hide':'show'
        }
    }
    //Mostrar Mostrar Reloj
    Shortcut{
        sequence: 'Ctrl+t'
        onActivated: {
            apps.showTimes=!apps.showTimes
        }
    }
    //Mostrar Panel para Lineas de Comando
    Shortcut{
        sequence: 'Ctrl+Shift+c'
        onActivated: {
            xBottomBar.objPanelCmd.state=xBottomBar.objPanelCmd.state==='show'?'hide':'show'
        }
    }
    //Mostrar Panel de Cuerpos
    Shortcut{
        sequence: 'Ctrl+i'
        onActivated: {
            panelDataBodies.state=panelDataBodies.state==='show'?'hide':'show'
        }
    }
    //Mostrar Panel para Crear Nuevo VN
    Shortcut{
        sequence: 'Ctrl+n'
        onActivated: {
            panelNewVNA.state=panelNewVNA.state==='show'?'hide':'show'
        }
    }
    //Mostrar Panel de Revoluciones Solares
    Shortcut{
        sequence: 'Ctrl+r'
        onActivated: {
            panelRsList.state=panelRsList.state==='show'?'hide':'show'
        }
    }
    Shortcut{
        sequence: 'Ctrl+Shift+p'
        onActivated: {
            panelZonaMes.state=panelZonaMes.state==='hide'?'show':'hide'
        }
    }
    Shortcut{
        sequence: 'Ctrl+s'
        onActivated: {
            //img.y+=4
            //showSABIANOS()
        }
    }
    Shortcut{
        sequence: 'Ctrl+Shift+Down'
        onActivated: {
            if(xSabianos.visible){
                xSabianos.zoomDown()
                return
            }
            //signCircle.subir()
            sweg.objSignsCircle.rotarSegundos(0)
        }
    }
    Shortcut{
        sequence: 'Ctrl+Shift+Up'
        onActivated: {
            if(xSabianos.visible){
                xSabianos.zoomUp()
                return
            }
            //signCircle.bajar()
            sweg.objSignsCircle.rotarSegundos(1)
        }
    }
    Shortcut{
        sequence: 'Ctrl++'
        onActivated: {
            sweg.width+=app.fs
        }
    }
    Shortcut{
        sequence: 'Ctrl+-'
        onActivated: {
            sweg.width-=app.fs
        }
    }
}
