import QtQuick 2.2
import QtQuick.Dialogs 1.0
//import "comps" as Comps

ColorDialog {
    id: colorDialog
    title: "Seleccionar Color"

    property string c: ''
    property color uColor
    onVisibilityChanged: {
        if(visible){
            if(c==='fontColor'){
                currentColor=apps.fontColor
            }
            if(c==='backgroundColor'){
                currentColor=apps.backgroundColor
            }
            uColor=currentColor
        }
    }
    onCurrentColorChanged: {
        if(c==='fontColor'){
            apps.fontColor=currentColor
        }
        if(c==='backgroundColor'){
            apps.backgroundColor=currentColor
        }
    }
    onAccepted: {
        if(c==='fontColor'){
            apps.fontColor=colorDialog.color
            colorDialog.visible=false
            return
        }
        if(c==='backgroundColor'){
            apps.backgroundColor=colorDialog.color
            colorDialog.visible=false
            return
        }
        console.log("You chose: " + colorDialog.color)
    }
    onRejected: {
        console.log("Canceled")
        colorDialog.visible=false
        if(c==='fontColor'){
            apps.fontColor=uColor
        }
        if(c==='backgroundColor'){
            apps.backgroundColor=uColor
        }
    }
}
