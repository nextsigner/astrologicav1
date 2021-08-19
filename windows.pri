message(windows.pri is loaded)

#Windows Deploy
#E:/Qt/Qt5.12.3/5.12.3/msvc2017_64/bin/windeployqt.exe E:/astrologicav1/build_win/astrologica.exe E:/astrologicav1

TARGET=zool

#FILE_VERSION_NAME=version
#QT += webengine
DD1=$$replace(PWD, /astrologicav1,/astrologicav1/build_win)
DESTDIR= $$DD1

#RC_FILE = unik.rc
#Building Quazip from Windows 8.1
INCLUDEPATH += $$PWD/quazip
DEFINES+=QUAZIP_STATIC
HEADERS += $$PWD/quazip/*.h
SOURCES += $$PWD/quazip/*.cpp
SOURCES += $$PWD/quazip/*.c
