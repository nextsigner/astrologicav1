message(windows.pri is loaded)

#FILE_VERSION_NAME=version
#QT += webengine
DD1=$$replace(PWD, /astrologica2,/astrologica2)
DESTDIR= $$DD1

#RC_FILE = unik.rc
#Building Quazip from Windows 8.1
INCLUDEPATH += $$PWD/quazip
DEFINES+=QUAZIP_STATIC
HEADERS += $$PWD/quazip/*.h
SOURCES += $$PWD/quazip/*.cpp
SOURCES += $$PWD/quazip/*.c
