import QtQuick 2.0

TowerBase {
    id: towerStar

    costs: 20
    income: 5
    interval: 160

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
            to: { "fire" : 1 }
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
}

