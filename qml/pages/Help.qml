import QtQuick 2.0
import QtQuick.LocalStorage 2.0
import Sailfish.Silica 1.0
import "../db.js" as DB

Page {
    id: page
    SilicaFlickable {
        id: flickable
        width: parent.width
        contentHeight: maincolumn.height
        Column {
            id: maincolumn
            width: parent.width
            PageHeader {
                title: qsTr("Help")
            }

            Label {
                textFormat: Text.RichText
                width: parent.width - Theme.paddingLarge * 2
                x: Theme.paddingLarge
                wrapMode: Text.Wrap
                text: qsTr("This app is a really simple reader of PDB books. All books should be placed in <b>Books</b> folder in your home folder (<b>/home/nemo</b>) - for this you can use any file browser on your Jolla or you can put the files there from your computer via USB cable. This app creates the folder on its first run. If you have any problems with this app, feel free to contact me at <a style='color:white;' href='mailto:dominik@chrastecky.cz'>dominik@chrastecky.cz</a> or on <a href='https://openrepos.net/content/rikudousennin/pdb-book-reader' style='color:white;'>OpenRepos</a>.")
            }
        }
    }
}
