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
    property string current_book
    property string current_whole_text
    property string current_visible_text
    property int step: 1000
    property int position: 0
    property bool book_opened: false

    SilicaFlickable {
        id: flickable
        anchors.fill: parent

        /*onMovementEnded: {
            var pos = flickable.visibleArea.yPosition + flickable.visibleArea.heightRatio;
            if(pos >= 0.999 && book_opened) {
                position = position + step;
                current_visible_text = current_whole_text.substr(position,step);
                textarea.text = current_visible_text;
                flickable.contentY = 0;
            }
        }*/

        PullDownMenu {
            id: pulldown
            visible: false
            signal bookChoosen(string bookname)
            onBookChoosen: {
                current_book = bookname;
                textarea.horizontalAlignment = Text.AlignHCenter;
                textarea.text = qsTr("Accessing file...");
                ct.makeTxt(current_book,dir);
                textarea.text = qsTr("Detecting encoding...");
                var encoding = ct.getEncoding(current_book+".txt");
                textarea.text = qsTr("Detecting encoding...")+" "+encoding;
                DB.open().transaction(function(tx) {
                    var res = tx.executeSql("SELECT original_name,position FROM books WHERE original_name='"+current_book+"'");
                    if(!res.rows.length) {
                        DB.initBook(current_book,encoding);
                    } else {
                        position = res.rows.item(0).position;
                        console.log(position);
                    }

                    textarea.text = qsTr("Reencoding...");
                    ct.reencode(current_book,encoding);
                    textarea.text = qsTr("Reading book content...");
                    current_whole_text = ct.getBookContents(current_book);
                    current_visible_text = current_whole_text.substr(position,step);
                    pageheader.title = bookname;
                    book_opened = true;
                    textarea.horizontalAlignment = Text.AlignLeft;
                    textarea.text = current_visible_text;
                    DB.changeMode("book");
                });
            }

            MenuItem {
                id: base1
                text: qsTr("Choose book")
                onClicked: {
                    var files = ct.listbooks(dir);
                    pageStack.push(Qt.createComponent("ListBooks.qml"),{books: files});
                }
            }

            MenuItem {
                visible: false
                id: book3
                text: qsTr("Reset book")
                onClicked: {
                    DB.open().transaction(function(tx){
                        tx.executeSql("UPDATE books SET position=0 WHERE original_name='"+current_book+"'");
                        position = 0;
                        current_visible_text = current_whole_text.substr(position,step);
                        textarea.text = current_visible_text;
                        flickable.contentY = 0;
                    });
                }
            }

            MenuItem {
                visible: false
                id: book2
                text: qsTr("Change encoding")
            }

            MenuItem {
                visible: false
                id: book1
                text: qsTr("Close book")
                onClicked: {
                    DB.changeMode("base");
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
                id: pageheader
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

            Button {
                id: nextbutton
                visible: book_opened
                text: qsTr("Next")
                x: screen.width / 2 - nextbutton.width / 2
                onClicked: {
                    position = position+step;
                    current_visible_text = current_whole_text.substr(position,step);
                    textarea.text = current_visible_text;
                    flickable.contentY = 0;
                    DB.open().transaction(function(tx) {
                        tx.executeSql("UPDATE books SET position='"+position+"' WHERE original_name='"+current_book+"'");
                    });
                }
            }

            Button {
                id: prevbutton
                visible: book_opened
                text: qsTr("Prev")
                x: screen.width / 2 - prevbutton.width / 2
                onClicked: {
                    position = position-step;
                    if(position < 0) {
                        position = 0;
                    }

                    current_visible_text = current_whole_text.substr(position,step);
                    textarea.text = current_visible_text;
                    flickable.contentY = 0;
                }
            }

            Component.onCompleted: {
                DB.open().transaction(function(tx) {
                    //tx.executeSql("DROP TABLE IF EXISTS firstrun"); // drop table so it's first run all the time
                    //tx.executeSql("DROP TABLE IF EXISTS books");

                    tx.executeSql("CREATE TABLE IF NOT EXISTS firstrun (firstrun INT)");
                    // original_name - name of the PDB file, position - position in the book
                    tx.executeSql("CREATE TABLE IF NOT EXISTS books (original_name TEXT, position INT, encoding TEXT)");

                    var res = tx.executeSql("SELECT firstrun FROM firstrun");
                    if(!res.rows.length) {
                        console.log("firstrun");
                        tx.executeSql("INSERT INTO firstrun (firstrun) VALUES (1)");
                        DB.firstrun();
                        firstrun = true;
                        run = true;
                    } else {
                        ct.rmFakeBooks();
                        console.log("notfirstrun");
                        firstrun = false;
                        run = true;
                    }
                });
            }
        }
    }
}


