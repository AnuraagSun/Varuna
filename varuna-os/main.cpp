// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║ FILE: main.cpp                                                             ║
// ║ LOCATION: varuna-os/main.cpp                                               ║
// ║ PURPOSE: Application entry point for VARUNA Embedded OS                    ║
// ║ FIXED: Using direct QRC URL loading instead of module loading             ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QUrl>
#include <QDebug>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QCoreApplication::setOrganizationName("CWC");
    QCoreApplication::setOrganizationDomain("cwc.gov.in");
    QCoreApplication::setApplicationName("VarunaOS");
    QCoreApplication::setApplicationVersion("1.0.3");

    QQuickStyle::setStyle("Basic");

    QQmlApplicationEngine engine;

    qDebug() << "";
    qDebug() << "═══════════════════════════════════════════════════════════";
    qDebug() << "  VARUNA Embedded OS - Starting";
    qDebug() << "═══════════════════════════════════════════════════════════";
    qDebug() << "  Version:" << QCoreApplication::applicationVersion();
    qDebug() << "  Qt:" << QT_VERSION_STR;
    qDebug() << "  Build:" << __DATE__ << __TIME__;
    qDebug() << "═══════════════════════════════════════════════════════════";
    qDebug() << "";

    const QUrl url(QStringLiteral("qrc:/qml/Main.qml"));

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl) {
                qCritical() << "[ERROR] Failed to load:" << objUrl;
                QCoreApplication::exit(-1);
            }
        },
        Qt::QueuedConnection
    );

    engine.load(url);

    if (engine.rootObjects().isEmpty()) {
        qCritical() << "[ERROR] No root objects created!";
        return -1;
    }

    qDebug() << "[OK] Application loaded successfully";
    qDebug() << "";

    return app.exec();
}

// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║ END OF FILE: main.cpp                                                      ║
// ╚═══════════════════════════════════════════════════════════════════════════╝
