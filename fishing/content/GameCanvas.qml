import QtQuick 2.0
import "Model.js" as Model
import "tower"

Item {
    id: canvas
    width: rows * cellSize
    height: cols * cellSize

    // consts
    property int cellSize: 64
    property int rows: 4
    property int cols: 6

    // game states
    property int score: 0
    property int coins: 100
    property int lives: 3

    Image {
        id: towerMenu
        x: -32
        visible: false
        scale: 0.9
        opacity: 0.7
        source: "gfx/dialog.png"

        property int targetRow: 0
        property int targetCol: 0

        function open(x, y) {
            targetRow = Model.row(y)
            targetCol = Model.col(x)
            // y position of tower menu
            if (targetRow == 0) {
                towerMenu.y = cellSize - 10
            } else {
                towerMenu.y = (targetRow - 1) * cellSize - 10
            }
            towerMenu.visible = true
        }

        function close() {
            towerMenu.visible = false
        }

        states: State {
            name: "shown"; when: towerMenu.visible
            PropertyChanges { target: towerMenu; scale: 1.0; opacity: 1.0 }
        }

        transitions: Transition {
            NumberAnimation { properties: "scale, opacity"; duration: 500; easing.type: Easing.OutElastic }
        }

        Row {
            id: towerRow
            anchors.centerIn: parent
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
            anchors.topMargin: 6
            opacity: 0.9
            x: 32 + towerMenu.targetCol * (towerRow.width / 4)
            visible: towerMenu.targetRow != 0
            source: "gfx/dialog-pointer.png"
        }

        Image {
            id: towerPointTop
            anchors.bottom: towerRow.top
            anchors.bottomMargin: 6
            opacity: 0.9
            x: 32 + towerMenu.targetCol * (towerRow.width / 4)
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
                helpButton.visible = false
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
                helpMessage.visible = false;
            }
        }
        Behavior on scale { NumberAnimation { duration: 100; easing.type: Easing.OutQuad} }
    }

    Fish { row: 0; col: 0 }
    TowerMelee { row: 0; col: 1 }
    TowerShooter { row: 0; col: 2 }
    TowerBomb { row: 1; col: 3 }
    TowerStar { row: 1; col: 1 }
}

