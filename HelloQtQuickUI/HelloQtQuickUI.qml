import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2

ApplicationWindow {
    title: qsTr("Hello QtQuick UI")
    width: 640
    height: 480

    menuBar: MenuBar {
        Menu {
            title: qsTr("&File")
            MenuItem {
                text: qsTr("&Open")
                onTriggered: messageDialog.show(qsTr("Open action triggered"));
            }
            MenuItem {
                text: qsTr("E&xit")
                onTriggered: Qt.quit();
            }
        }
    }

    MainForm {
        anchors.fill: parent
        button1.onClicked: messageDialog.show(qsTr("Button 1 pressed"))
        button2.onClicked: messageDialog.show(qsTr("Button 2 pressed"))
        button3.onClicked: messageDialog.show(qsTr("Button 3 pressed"))
        CounterAnimation { width: 100; height: 100; color: "red" }

        Item {
            x: 0
            y: 150
            width: 300
            height: 200

            Rectangle {
                color: "#272822"
                width: parent.width
                height: parent.height
            }

            // This element displays a rectangle with a gradient and a border
            Rectangle {
                x: 160
                y: 20
                width: 100
                height: 100
                radius: 8 // This gives rounded corners to the Rectangle
                gradient: Gradient { // This sets a vertical gradient fill
                    GradientStop { position: 0.0; color: "aqua" }
                    GradientStop { position: 1.0; color: "teal" }
                }
                border { width: 3; color: "white" } // This sets a 3px wide black border to be drawn
            }

            // This rectangle is a plain color with no border
            Rectangle {
                x: 40
                y: 20
                width: 100
                height: 100
                color: "red"
            }
        }

    }

    MessageDialog {
        id: messageDialog
        title: qsTr("Hello QtQuick UI")

        function show(caption) {
            messageDialog.text = caption;
            messageDialog.open();
        }
    }
}
