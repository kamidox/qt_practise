import QtQuick 2.0
import "../Model.js" as Model

TowerBase {
    id: towerBomb

    costs: 75
    lives: 10
    damage: 10
    range: 0.4
    interval: 10

    function fire() {
        sprite.jumpTo("fire")
    }

    function finishFire() {
        var sCol = Math.max(0, col - 1)
        var eCol = Math.min(Model.gameState.cols - 1, col + 1)
        var killList = new Array()
        for (var i = sCol; i <= eCol; i ++) {
            for (var j = 0; j < Model.gameState.fishs[i].length; j ++) {
                if (Math.abs(Model.gameState.fishs[i][j].y - towerBomb.y ) < Model.gameState.cellSize * 2.5) {
                    killList.push(Model.gameState.fishs[i][j])
                }
            }
            while (killList.length > 0) {
                Model.killFish(i, killList.pop())
            }
        }
        Model.killTower(row, col)
    }

    function die() {
        destroy()       // no blink for bomb
    }

    Timer {
        id: animDelay
        running: false
        interval: fireState.frameCount * fireState.frameDuration
        onTriggered: finishFire()
    }

    SpriteSequence {
        id: sprite
        width: 64
        height: 64
        interpolate: false

        Sprite {
            name: "normal"
            source: "../gfx/bomb-idle.png"
            frameCount: 4
            frameWidth: 64
            frameHeight: 64
            frameDuration: 800
            to: { "fire": 0 }
        }

        Sprite {
            id: fireState
            name: "fire"
            source: "../gfx/bomb-action.png"
            frameCount: 6
            frameWidth: 64
            frameHeight: 64
            frameDuration: 155
            to: { "dying": 1 }
        }

        Sprite {
            name: "dying"
            source: "../gfx/bomb-action.png"
            frameCount: 1
            frameX: 64 * 5
            frameWidth: 64
            frameHeight: 64
            frameDuration: 155
            to: { "normal": 1 }
        }
    }

    SequentialAnimation on x {
        loops: Animation.Infinite
        NumberAnimation { from: x - 4; to: x; duration: 900; easing.type: Easing.InOutQuad }
        NumberAnimation { from: x; to: x - 4; duration: 900; easing.type: Easing.InOutQuad }
    }
    SequentialAnimation on y {
        loops: Animation.Infinite
        NumberAnimation { from: y - 4; to: y; duration: 900; easing.type: Easing.InOutQuad }
        NumberAnimation { from: y; to: y - 4; duration: 900; easing.type: Easing.InOutQuad }
    }
}

