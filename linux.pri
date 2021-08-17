#Linux Deploy
#Deploy Command Line Example

#1) Situarse en la carpeta principal. cd ~

#2) Edit default.desktop

#3)  ~/linuxdeployqt-continuous-x86_64.AppImage /media/ns/ZONA-A1/astrologicav1/build_linux/astrologica -qmldir=/media/ns/ZONA-A1/astrologicav1 -qmake=/home/ns/Qt/5.15.2/gcc_64/bin/qmake -verbose=3


#4 optional) Copy full plugins and qml folder for full qtquick support.
#Copy <QT-INSTALL>/gcc_64/qml and <QT-INSTALL>/gcc_64/plugins folders manualy to the executable folder location.
#cp -r ~/Qt/5.15.2/gcc_64/qml /media/ns/ZONA-A1/astrologicav1/build_linux
#cp -r ~/Qt/5.15.2/gcc_64/plugins /media/ns/ZONA-A1/astrologicav1/build_linux

#Make Unik AppImage (The AppImage version is maked automatically from ./build_linux/default.desktop file)
#5) ~/linuxdeployqt-continuous-x86_64.AppImage /media/ns/ZONA-A1/astrologicav1/build_linux/astrologica -qmldir=/media/ns/ZONA-A1/astrologicav1 -qmake=/home/ns/Qt/5.15.2/gcc_64/bin/qmake -verbose=3 -bundle-non-qt-libs -no-plugins -appimage

message(linux.pri is loaded......)

DD1=$$replace(PWD, /astrologicav1,/astrologicav1/build_linux)
DESTDIR= $$DD1

EXTRA_BINFILES += $$PWD/*.js
EXTRA_BINFILES += $$PWD/*.qml
EXTRA_BINFILES += $$PWD/*.py
EXTRA_BINFILES += $$PWD/swe
EXTRA_BINFILES += $$PWD/comps
EXTRA_BINFILES += $$PWD/resources
EXTRA_BINFILES += $$PWD/py
EXTRA_BINFILES_WIN = $${EXTRA_BINFILES}
for(FILE,EXTRA_BINFILES_WIN){
        QMAKE_POST_LINK +=$$quote(cp -r $${FILE} $${DESTDIR}$$escape_expand(\n\t))
}

INCLUDEPATH += $$PWD/quazip
LIBS += -lz
INCLUDEPATH+=/usr/local/zlib/include
HEADERS += $$PWD/quazip/*.h
SOURCES += $$PWD/quazip/*.cpp
SOURCES += $$PWD/quazip/*.c
