import QtQuick 2.0
import "../Model.js" as Model

TowerBase {
    id: towerStar

    costs: 20
    income: 5
    interval: 160

    function fire() {
        sprite.jumpTo("fire")
        coinLaunch.start()
    }

    function spawn() {
        coin.target = Model.gameState.mapToItem(towerStar, 240, -32)
    }

    SpriteSequence {
        id: sprite
        width: 64
        height: 64
        interpolate: false

        Sprite {
            name: "normal"
            source: "../gfx/factory-idle.png"
            frameCount: 4
            frameWidth: 64
            frameHeight: 64
            frameDuration: 200
            to: { "fire" : 0 }
        }

        Sprite {
            name: "fire"
            source: "../gfx/factory-action.png"
            frameCount: 4
            frameWidth: 64
            frameHeight: 64
            frameDuration: 100
            to: { "normal" : 1 }
        }
    }

    Image {
        id: coin
        property var target: {"x": 0, "y": 0 }
        source: "../gfx/currency.png"
        visible: false
    }

    SequentialAnimation {
        id: coinLaunch
        PropertyAction { target: coin; property: "visible"; value: true }
        ParallelAnimation {
            NumberAnimation { target: coin; property: "x"; from: 16; to: coin.target.x }
            NumberAnimation { target: coin; property: "y"; from: 16; to: coin.target.y }
        }
        PropertyAction { target: coin; property: "visible"; value: false }
    }
}

