from PySide2.QtCore import Property, QCoreApplication, QObject, Signal, Slot
import subprocess

class UnikQProcess(QObject):
    logDataChanged = Signal()
    def __init__(self, parent=None):
        super().__init__(parent)
        self._logData = ''


    @Property(str)
    def logData(self):
            return self._logData
    @Signal
    def logDataChanged(self):
        print('Signal lodData!')

    @Slot(result=str)
    def getLogData(self):
        return str(self._logData)
    @Slot(str)
    def setLogData(self, ld):
        self._logData=str(ld)
        #print('--->:::-->'+str(logData))
        self.logDataChanged.emit()

    @Slot(str)
    def run(self, cmd):
        listaCmd=cmd.split(sep=' ')
        command = subprocess.run(listaCmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, encoding='UTF-8')
        out=str(command.stdout)
        #print(out)
        self.setLogData(out)

    logData = Property(str, getLogData, setLogData, notify=logDataChanged)

