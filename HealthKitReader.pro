TEMPLATE = app

QT += qml quick charts
CONFIG += c++11

SOURCES += main.cpp
RESOURCES += qml.qrc

QMAKE_LFLAGS += -F/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/System/Library/Frameworks/
LIBS += -framework HealthKit

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    hkmanager.h

OBJECTIVE_SOURCES += \
    hkmanager.mm

ios {
    QMAKE_INFO_PLIST = Info.plist
}

DISTFILES += \
    Info.plist
