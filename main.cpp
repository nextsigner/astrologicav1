#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QDir>
#include <QDebug>
#include <QIcon>
#include "unikqprocess.h"
#include "unik.h"

#define VERSION "0.1"


int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);
    app.setApplicationDisplayName("AstroLogica");
    app.setApplicationName("AstroLogica");
    app.setApplicationVersion("0.1");

    Unik u;

#ifdef Q_OS_LINUX
    if(argc==2 && argv[1]==QByteArray("-install")){
        //Esta operación se realiza en la carpeta donde está el AppImage (antes de ir con CD a la carpeta del executable interno del AppImage)
        qDebug()<<"Installing astrologica...";
        QByteArray cf;
        cf.append(u.getPath(4).toUtf8());
        cf.append("/img");
        qInfo()<<"Unik Image Folder: "<<cf;
        QDir configFolder(cf);
        if(!configFolder.exists()){
            qInfo()<<"Making Unik Image Folder...";
            u.mkdir(cf);
        }
        QFile icon2(cf+"/icon.png");
        if(!icon2.exists()){
            QByteArray cf2;
            cf2.append(qApp->applicationDirPath());
            cf2.append("/icon.png");
            QFile icon(cf2);
            icon.copy(cf+"/icon.png");
            qInfo()<<"Copyng unik icon file: "<<cf2<<" to "<<cf+"/icon.png";
        }
        QByteArray iconData;
        iconData.append("[Desktop Entry]\n");
        iconData.append("Categories=Development;Qt;Settings;\n");
        iconData.append("Type=Application\n");
        iconData.append("Name=Astrologica");
        iconData.append(VERSION);
        iconData.append("\n");
        iconData.append("Exec=");
        //iconData.append(QDir::currentPath()+"/unik_v");
        //iconData.append(nv);
        //iconData.append("-x86_64.AppImage");
        iconData.append("astrologica");
        iconData.append("\n");
        iconData.append("Icon=");
        iconData.append(cf+"/icon.png\n");
        iconData.append("Comment=AstroLogica by @nextsigner\n");
        iconData.append("Terminal=false\n");
        u.setFile("/usr/share/applications/astrologica.desktop", iconData);
        if(!u.fileExist("/usr/share/applications/astrologica.desktop")){
            qInfo()<<"Error when install Unik. Run Unik whit sudo permission for install this app into GNU/Linux";
        }else{
            qInfo()<<"Unik installed in category Development.";
        }
        if(u.fileExist("/usr/local/bin/astrologica")){
            u.deleteFile("/usr/local/bin/astrologica");
        }
        QByteArray cmdLN;
        cmdLN.append("sudo ln ");
        //cmdLN.append(QDir::currentPath().toUtf8()+"/astrologica_v");
        cmdLN.append(QDir::currentPath().toUtf8()+"/astrologica_v");
        cmdLN.append(VERSION);
        cmdLN.append("-x86_64.AppImage");
        cmdLN.append(" /usr/local/bin/astrologica");
        u.ejecutarLineaDeComandoAparte(cmdLN);
        qInfo()<<"Unik Current Path: "<<QDir::currentPath();
        return 0;
    }
#endif
    QByteArray mainFolder;
    mainFolder.append(qApp->applicationDirPath().toUtf8());
    qDebug()<<"Argv 1: "<<argv[1];
    if(QString(argv[1]).contains("-folder=")){
        QStringList sl1=QString(argv[1]).split("-folder=");
        QDir::setCurrent(sl1.at(1));
        qDebug()<<"Set current folder from -folder: "<<sl1.at(1);
        mainFolder="";
        mainFolder.append(sl1.at(1).toUtf8());
    }else{
        QDir::setCurrent(qApp->applicationDirPath());
    }
    qDebug()<<"Current folder: "<<QDir::currentPath();

    QString iconPath=qApp->applicationDirPath();
    iconPath.append("/resources/imgs/logo.png");
    app.setWindowIcon(QIcon(iconPath));
    qDebug()<<"icon path: "<<iconPath;



    QByteArray mainPath;
#ifdef Q_OS_WIN
    mainPath.append("file:///");
#endif
    mainPath.append(mainFolder);
    mainPath.append("/main.qml");
    QQmlApplicationEngine engine;
    //const QUrl url(QStringLiteral(mainPath));
    const QUrl url(mainPath);

    //const QUrl url(QStringLiteral("qr.cfgc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    qmlRegisterType<UnikQProcess>("unik.UnikQProcess", 1, 0, "UnikQProcess");
    engine.rootContext()->setContextProperty("unik", &u);
    engine.load(url);

    return app.exec();
}
