import QtQuick 2.0
import "Model.js" as Model

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
        id: towerMenu
        x: -32
        z: 1010
        visible: false
        source: "gfx/dialog.png"

        property int targetRow: 0
        property int targetCol: 0

        function open(x, y) {
            targetRow = Model.row(y)
            targetCol = Model.col(x)
            // y position of tower menu
            if (targetRow == 0) {
                towerMenu.y = cellSize
            } else {
                towerMenu.y = (targetRow - 1) * cellSize
            }
            towerMenu.visible = true
        }

        function close() {
            towerMenu.visible = false
        }

        Row {
            id: towerRow
            anchors.centerIn: parent
            y: 1010
            spacing: 8
            TowerBuilder {
                width: cellSize
                height: cellSize
                source: "gfx/dialog-melee.png"
                cost: "20"
            }
            TowerBuilder {
                width: cellSize
                height: cellSize
                source: "gfx/dialog-shooter.png"
                cost: "50"
            }
            TowerBuilder {
                width: cellSize
                height: cellSize
                source: "gfx/dialog-bomb.png"
                cost: "75"
            }
            TowerBuilder {
                width: cellSize
                height: cellSize
                source: "gfx/dialog-factory.png"
                cost: "25"
            }
        }

        Image {
            id: towerPointBottom
            anchors.top: towerRow.bottom
            anchors.topMargin: 4
            x: towerMenu.targetCol * canvas.cellSize
            z: 1009
            visible: towerMenu.targetRow != 0
            source: "gfx/dialog-pointer.png"
        }

        Image {
            id: towerPointTop
            anchors.bottom: towerRow.top
            anchors.bottomMargin: 4
            x: towerMenu.targetCol * canvas.cellSize
            z: 1009
            visible: towerMenu.targetRow == 0
            rotation: 180
            transformOrigin: Item.Center
            source: "gfx/dialog-pointer.png"
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            if (towerMenu.visible) {
                towerMenu.close();
            } else {
                towerMenu.open(mouse.x, mouse.y)
            }
        }
    }

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

