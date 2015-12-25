import QtQuick 2.0
import QtQuick.LocalStorage 2.0
import Sailfish.Silica 1.0
import "../db.js" as DB

Page {
    id: page
    property bool run: false
    property bool firstrun
    property string firstruntext: qsTr("Hello, Sailor! It looks like it's your first time using this app. The usage is pretty simple - put all your books in Books directory and then use pull down menu to choose your book. Then enjoy reading! :)")
    property string welcometext: qsTr("Hello, Sailor! Choose your book from pull down menu!")
    readonly property string dir: qsTr("Books")
    readonly property string path: "/home/nemo/"+dir

    SilicaFlickable {
        anchors.fill: parent

        PullDownMenu {
            id: pulldown
            visible: false
            signal bookChoosen(string bookname)
            onBookChoosen: {
                console.log(bookname);
            }

            MenuItem {
                text: qsTr("Choose book")
                onClicked: {
                    var files = ct.listbooks(dir);
                    var book = pageStack.push(Qt.createComponent("ListBooks.qml"),{books: files});
                    //console.log(book.selectedbook)
                }
            }
        }

        contentHeight: column.height

        Timer {
            id: maintimer
            interval: 500
            running: true
            onTriggered: {
                if(run) {
                    console.log(path);
                    pulldown.visible = true;
                    maintimer.running = false;
                    textarea.horizontalAlignment = Text.AlignLeft;
                    if(firstrun) {
                        textarea.text = firstruntext;
                    } else {
                        textarea.text = welcometext;
                    }
                }
            }
        }

        Column {
            id: column

            width: page.width
            spacing: Theme.paddingLarge
            PageHeader {
                title: qsTr("PDB book reader")
            }
            Label {
                id: textarea
                x: Theme.paddingLarge
                text: qsTr("Loading...")
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeMedium
                width: screen.width - Theme.paddingLarge
                wrapMode: Text.Wrap
                horizontalAlignment: Text.AlignHCenter
            }
            Component.onCompleted: {
                ct.mkFakeBooks();
                DB.open().transaction(function(tx) {
                    tx.executeSql("DROP TABLE IF EXISTS firstrun"); // drop table so it's first run all the time
                    tx.executeSql("DROP TABLE IF EXISTS books");

                    tx.executeSql("CREATE TABLE IF NOT EXISTS firstrun (firstrun INT)");
                    // original_name - name of the PDB file, txt_path - path to converted txt file, position - position in the book
                    tx.executeSql("CREATE TABLE IF NOT EXISTS books (original_name TEXT, txt_path TEXT, position INT)");

                    var res = tx.executeSql("SELECT firstrun FROM firstrun");
                    if(!res.rows.length) {
                        console.log("firstrun");
                        tx.executeSql("INSERT INTO firstrun (firstrun) VALUES (1)");
                        DB.firstrun();
                        firstrun = true;
                        run = true;
                    } else {
                        console.log("notfirstrun");
                        firstrun = false;
                        run = true;
                    }
                });
            }
        }
    }
}


