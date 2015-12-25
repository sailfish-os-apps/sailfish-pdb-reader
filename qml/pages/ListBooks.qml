import QtQuick 2.0
import QtQuick.LocalStorage 2.0
import Sailfish.Silica 1.0
import "../db.js" as DB

Page {
    id: bookspage
    property var books
    property string selectedbook

    SilicaFlickable {
        id: flickable
        anchors.fill: parent
        contentHeight: maincolumn.height

        Column {
            id: maincolumn
            width: parent.width

            PageHeader {
                id: header
                title: qsTr("Choose book")
            }

            ListModel {
                id: lmodel
            }

            Repeater {
                id: listview
                model: lmodel
                Button {
                    height: 70
                    width: parent.width
                    text: bookname
                    onClicked: {
                        console.log("clicked - "+bookname);
                        selectedbook = bookname;
                        pulldown.bookChoosen(bookname);
                        pageStack.pop();
                    }
                }
            }
        }
        Component.onCompleted: {
            for(var i in books) {
                lmodel.append({bookname: books[i]});
            }
        }
    }
}
