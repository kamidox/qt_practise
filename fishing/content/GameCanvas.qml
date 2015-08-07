import QtQuick 2.0
import "Model.js" as Model
import "tower"

Item {
    id: canvas
    z: 1000
    width: cols * cellSize
    height: rows * cellSize

    // consts
    property int cellSize: 64
    property int rows: 6
    property int cols: 4

    // game states
    property int score: 0
    property int coins: 100
    property int lives: 3
    property bool gameOver: false
    property bool gameRunning: false

    property var towers
    property var fishs
    property int waveIndex: 0
    property int waveProgress: 0

    function fleshState() {
        coins = 100
        score = 0
        lives = 3
        gameOver = false
        gameRunning = false
        waveIndex = 0
        waveProgress = 0
        towerMenu.visible = false
        helpButton.visible = true
        helpMessage.visible = false
    }

    // tower builder menu
    Image {
        id: towerMenu
        x: -32
        z: 1100
        visible: false
        scale: 0.9
        opacity: 0.7
        source: "gfx/dialog.png"

        property int targetRow: 0
        property int targetCol: 0
        property bool targetCanBuild: true

        function open(x, y) {
            targetRow = Model.row(y)
            targetCol = Model.col(x)
            // y position of tower menu
            if (targetRow == 0) {
                towerMenu.y = cellSize - 10
            } else {
                towerMenu.y = (targetRow - 1) * cellSize - 10
            }
            targetCanBuild = (canvas.towers[Model.towerIdx(targetCol, targetRow)] == null)
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
                gameCanvas: canvas
                col: towerMenu.targetCol
                row: towerMenu.targetRow
                canBuild: towerMenu.targetCanBuild
                towerType: 0
                onClicked: towerMenu.close()
            }
            TowerBuilder {
                width: cellSize
                height: cellSize
                source: "gfx/dialog-shooter.png"
                gameCanvas: canvas
                col: towerMenu.targetCol
                row: towerMenu.targetRow
                canBuild: towerMenu.targetCanBuild
                towerType: 1
                onClicked: towerMenu.close()
            }
            TowerBuilder {
                width: cellSize
                height: cellSize
                source: "gfx/dialog-bomb.png"
                gameCanvas: canvas
                col: towerMenu.targetCol
                row: towerMenu.targetRow
                canBuild: towerMenu.targetCanBuild
                towerType: 2
                onClicked: towerMenu.close()
            }
            TowerBuilder {
                width: cellSize
                height: cellSize
                source: "gfx/dialog-factory.png"
                gameCanvas: canvas
                col: towerMenu.targetCol
                row: towerMenu.targetRow
                canBuild: towerMenu.targetCanBuild
                towerType: 3
                onClicked: towerMenu.close()
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
        z: 1500
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
        z: 1500
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

    Timer {
        interval: 16
        repeat: true
        running: true
        onTriggered: Model.tick()
    }
}

