from PySide2.QtCore import QObject, Signal, Slot

class Console(QObject):

    def __init__(self):
        # Initialize the PunchingBag as a QObject
        QObject.__init__(self)

    @Slot(str)
    def log(self, string):
        print(string)
