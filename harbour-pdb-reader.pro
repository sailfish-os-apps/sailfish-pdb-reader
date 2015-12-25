# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-pdb-reader

CONFIG += sailfishapp

SOURCES += src/harbour-pdb-reader.cpp

OTHER_FILES += qml/harbour-pdb-reader.qml \
    qml/cover/CoverPage.qml \
    rpm/harbour-pdb-reader.changes.in \
    rpm/harbour-pdb-reader.spec \
    rpm/harbour-pdb-reader.yaml \
    translations/*.ts \
    harbour-pdb-reader.desktop

SAILFISHAPP_ICONS = 86x86 108x108 128x128 256x256

CONFIG += sailfishapp_i18n
TRANSLATIONS += translations/harbour-pdb-reader-cs_CZ.ts

HEADERS += \
    exec.h \
    cppthings.h

DISTFILES += \
    qml/pages/MainPage.qml \
    qml/db.js

