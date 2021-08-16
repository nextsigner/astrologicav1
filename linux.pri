#Linux Deploy
#Deploy Command Line Example

#1) Situarse en la carpeta principal. cd ~

#2) Edit default.desktop

#3)  ~/linuxdeployqt-continuous-x86_64.AppImage /home/ns/nsp/uda/astrologica/build_linux/astrologica -qmldir=/home/ns/nsp/uda/astrologica -qmake=/home/ns/Qt/5.15.2/gcc_64/bin/qmake -verbose=3


#4 optional) Copy full plugins and qml folder for full qtquick support.
#Copy <QT-INSTALL>/gcc_64/qml and <QT-INSTALL>/gcc_64/plugins folders manualy to the executable folder location.
#cp -r ~/Qt/5.15.2/gcc_64/qml ~/unik/build_linux/
#cp -r ~/Qt/5.15.2/gcc_64/plugins ~/unik/build_linux/

#Make Unik AppImage (The AppImage version is maked automatically from ./build_linux/default.desktop file)
#5) ~/linuxdeployqt-continuous-x86_64.AppImage /home/ns/nsp/uda/astrologica/build_linux/astrologica -qmldir=/home/ns/nsp/uda/astrologica -qmake=/home/ns/Qt/5.15.2/gcc_64/bin/qmake -verbose=3 -bundle-non-qt-libs -no-plugins -appimage

message(linux.pri is loaded......)

DD1=$$replace(PWD, /astrologica,/astrologica)
DESTDIR= $$DD1
