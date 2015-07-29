import QtQuick 2.0

Rectangle {
    id: root
    width: 400
    height: 400

    property bool showText: false
    property int col: 0

    Rectangle {
        id: coloredRect
        width: 100
        height: 100
        anchors.centerIn: parent

        color: "red"
        transitions: Transition {
            ColorAnimation {}
        }

        MouseArea {
            id: mouser
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                root.showText = !root.showText
                root.col ++
                if (root.col > 5) {
                    root.col = 0
                }
            }
        }

        states: State {
            name: "GreenState"
            when: mouser.containsMouse

            PropertyChanges {
                target: coloredRect
                color: "green"
            }
        }
    }
    onColChanged: { console.log("col=" + col) }

    Rectangle {
        id: box
        width: 50
        height: 50
        anchors.bottom: parent.bottom
        x: col * 10
        color: "green"
    }

    Text {
        id: text
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter

        visible: root.showText
        text: qsTr("TEXT depend on root.showText")
    }
}
