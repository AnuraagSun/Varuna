// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║ FILE: main.cpp                                                             ║
// ║ LOCATION: varuna-os/main.cpp                                               ║
// ║ PURPOSE: Application entry point with kiosk mode support                  ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QQuickWindow>
#include <QScreen>
#include <QUrl>
#include <QDebug>
#include <QCommandLineParser>
#include <QCommandLineOption>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QCoreApplication::setOrganizationName("CWC");
    QCoreApplication::setOrganizationDomain("cwc.gov.in");
    QCoreApplication::setApplicationName("VarunaOS");
    QCoreApplication::setApplicationVersion("1.0.3");

    // Command line parser
    QCommandLineParser parser;
    parser.setApplicationDescription("VARUNA Water Level Monitoring System");
    parser.addHelpOption();
    parser.addVersionOption();

    // Kiosk mode option
    QCommandLineOption kioskOption(
        QStringList() << "k" << "kiosk",
        "Start in kiosk mode (fullscreen, no cursor)"
    );
    parser.addOption(kioskOption);

    // Windowed mode option
    QCommandLineOption windowedOption(
        QStringList() << "w" << "windowed",
        "Start in windowed mode (for development)"
    );
    parser.addOption(windowedOption);

    // No cursor option
    QCommandLineOption noCursorOption(
        QStringList() << "no-cursor",
        "Hide mouse cursor"
    );
    parser.addOption(noCursorOption);

    parser.process(app);

    bool kioskMode = parser.isSet(kioskOption);
    bool windowedMode = parser.isSet(windowedOption);
    bool hideCursor = parser.isSet(noCursorOption) || kioskMode;

    // Set style
    QQuickStyle::setStyle("Basic");

    // Hide cursor if requested
    if (hideCursor) {
        app.setOverrideCursor(Qt::BlankCursor);
    }

    QQmlApplicationEngine engine;

    // Pass kiosk mode to QML
    engine.rootContext()->setContextProperty("kioskMode", kioskMode);
    engine.rootContext()->setContextProperty("windowedMode", windowedMode);

    qDebug() << "";
    qDebug() << "═══════════════════════════════════════════════════════════";
    qDebug() << "  VARUNA Embedded OS - Starting";
    qDebug() << "═══════════════════════════════════════════════════════════";
    qDebug() << "  Version:" << QCoreApplication::applicationVersion();
    qDebug() << "  Qt:" << QT_VERSION_STR;
    qDebug() << "  Mode:" << (kioskMode ? "KIOSK" : (windowedMode ? "WINDOWED" : "DEFAULT"));
    qDebug() << "  Cursor:" << (hideCursor ? "HIDDEN" : "VISIBLE");
    qDebug() << "═══════════════════════════════════════════════════════════";
    qDebug() << "";

    const QUrl url(QStringLiteral("qrc:/qml/Main.qml"));

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [url, kioskMode](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl) {
                qCritical() << "[ERROR] Failed to load:" << objUrl;
                QCoreApplication::exit(-1);
                return;
            }

            // Set fullscreen if kiosk mode
            if (kioskMode) {
                QQuickWindow *window = qobject_cast<QQuickWindow*>(obj);
                if (window) {
                    window->showFullScreen();
                    qDebug() << "[KIOSK] Fullscreen mode activated";
                }
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
