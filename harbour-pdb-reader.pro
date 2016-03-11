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
TRANSLATIONS += translations/harbour-pdb-reader-sv.ts
TRANSLATIONS += translations/harbour-pdb-reader-de.ts

HEADERS += \
    exec.h \
    cppthings.h

DISTFILES += \
    qml/pages/MainPage.qml \
    qml/db.js \
    qml/pages/ListBooks.qml \
    qml/pages/ListEncoding.qml \
    qml/pages/About.qml \
    qml/pages/Help.qml

