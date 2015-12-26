import QtQuick 2.0
import QtQuick.LocalStorage 2.0
import Sailfish.Silica 1.0
import "../db.js" as DB

Page {
    id: encodingpage
    SilicaFlickable {
        id: flickable
        anchors.fill: parent
        contentHeight: maincolumn.height

        Column {
            id: maincolumn
            width: parent.width

            PageHeader {
                id: header
                title: qsTr("Choose book encoding")
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
                    text: encodingname
                    onClicked: {
                        book2.encodingChosen(encodingname);
                        pageStack.pop();
                    }
                }
            }

            Component.onCompleted: {
                var encodings = DB.listEncodings();
                console.log(encodings);
                for(var i in encodings) {
                    lmodel.append({encodingname: encodings[i]});
                }
                listview.height = encodings.length*(70+10);
                console.log(listview.height);
            }

        }
    }
}
