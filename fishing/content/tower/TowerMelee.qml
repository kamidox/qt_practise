import QtQuick 2.0

TowerBase {
    id: towerMelee

    costs: 20
    lives: 4
    damage: 1
    range: 0
    interval: 30    // 30 x 16 ms, interval between two fire

    SpriteSequence {
        id: sprite
        width: 64
        height: 64
        interpolate: false

        Sprite {
            name: "normal"
            source: "../gfx/melee-idle.png"
            frameCount: 8
            frameWidth: 64
            frameHeight: 64
            frameDuration: 250
            to: { "fire": 0 }
        }

        Sprite {
            name: "fire"
            source: "../gfx/melee-action.png"
            frameCount: 2
            frameWidth: 64
            frameHeight: 64
            frameDuration: 200
            to: { "normal": 1 }
        }
    }

    function fire() {
        sprite.jumpTo("fire")
    }
}

