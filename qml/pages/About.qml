import QtQuick 2.0
import QtQuick.LocalStorage 2.0
import Sailfish.Silica 1.0
import "../db.js" as DB

Page {
    property string version: "0.9.1b"
    id: aboutpage
    SilicaFlickable {
        id: flickable
        width: parent.width
        contentHeight: maincolumn.height
        Column {
            id: maincolumn
            width: parent.width
            PageHeader {
                title: qsTr("About")
            }
            Label {
                width: parent.width - Theme.paddingLarge * 2
                wrapMode: Text.Wrap
                x: Theme.paddingLarge
                text: qsTr("Author: ")+"Rikudou_Sennin"
            }
            Label {
                width: parent.width - Theme.paddingLarge * 2
                wrapMode: Text.Wrap
                x: Theme.paddingLarge
                text: qsTr("PDB book reader, version: ")+version
            }
            Label {
                width: parent.width - Theme.paddingLarge * 2
                wrapMode: Text.Wrap
                x: Theme.paddingLarge
                text: qsTr("License: ")+"WTFPL"
            }

            Item {
                width: parent.width
                height: 50
            }

            Button {
                text: qsTr("Clear books database")
                x: screen.width / 2 - width / 2
                onClicked: {
                    DB.clearDatabase();
                }
            }
            Label {
                width: parent.width - Theme.paddingLarge * 2
                wrapMode: Text.Wrap
                x: Theme.paddingLarge
                font.pixelSize: Theme.fontSizeExtraSmall
                text: qsTr("Use it if you have problem with books. It will delete the whole books database, so you will have to start reading all books from beginning.")
            }
            PageHeader {
                title: qsTr("Translators")
            }

            Label {
                width: parent.width - Theme.paddingLarge * 2
                wrapMode: Text.Wrap
                x: Theme.paddingLarge
                text: qsTr("Swedish")+": eson\n"+qsTr("Czech")+": Rikudou_Sennin"
            }
        }
    }
}
