import QtQuick 2.0

Rectangle {
    width: 400
    height: 400

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
}
