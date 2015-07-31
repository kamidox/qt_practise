import QtQuick 2.0

Item {
    id: canvas
    width: rows * cellSize
    height: cols * cellSize

    // consts
    property int cellSize: 64
    property int rows: 4
    property int cols: 6

    // game params
    property int score: 0
    property int coins: 100
    property int lives: 3

    Image {
        id: helpButton
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom

        source: "gfx/button-help.png"

        MouseArea {
            anchors.fill: parent
            onClicked: {
                helpButton.visible = false;
                helpMessage.visible = true;
            }
        }
    }


    Image {
        id: helpMessage
        source: "gfx/help.png"
        anchors.fill: parent
        visible: false
        scale: visible ? 1 : 0.1

        MouseArea {
            anchors.fill: parent
            onClicked: {
                helpButton.visible = true;
                helpMessage.visible = false;
            }
        }
        Behavior on scale { NumberAnimation { duration: 100; easing.type: Easing.OutQuad} }
    }
}

