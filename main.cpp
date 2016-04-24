#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtQml>
#include "HKManager.h"
int main(int argc, char *argv[])
{
    qmlRegisterType<HKManager>("HKManager", 1, 0, "HKManager");
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
