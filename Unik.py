from PySide2.QtCore import QObject, Signal, Slot
from pathlib import Path

class Unik(QObject):
    def __init__(self):
        # Initialize the PunchingBag as a QObject
        QObject.__init__(self)

    @Slot(str, result=str)
    def getFile(self, f):
        file = open(f, "r")
        datos=file.read()
        #print(datos)
        return datos

    @Slot(str, str, result=bool)
    def setFile(self, f, d):
        f = open(f, "a")
        f.write(d)
        f.close()


    @Slot(int, result=str)
    def getPath(self, num):
        path=''
        if num == 0:
            path = Path(Path(__dir__).resolve())

        return path
