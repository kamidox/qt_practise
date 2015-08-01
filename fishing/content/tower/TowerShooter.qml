import QtQuick 2.0

TowerBase {
    id: towerShooter

    costs: 50
    lives: 2
    damage: 1
    range: 6
    interval: 40    // 40 x 16 ms, interval between two fire

    SpriteSequence {
        id: sprite
        width: 64
        height: 64
        interpolate: false

        Sprite {
            name: "normal"
            source: "../gfx/shooter-idle.png"
            frameCount: 4
            frameWidth: 64
            frameHeight: 64
            frameDuration: 250
            to: { "fire" : 0 }
        }

        Sprite {
            name: "fire"
            source: "../gfx/shooter-action.png"
            frameCount: 5
            frameWidth: 64
            frameHeight: 64
            frameDuration: 100
            to: { "normal" : 1 }
        }
    }

    SequentialAnimation on x {
        loops: Animation.Infinite
        NumberAnimation { from: x - 5; to: x; duration: 900; easing.type: Easing.InOutQuad }
        NumberAnimation { from: x; to: x - 5; duration: 900; easing.type: Easing.InOutQuad }
    }
}

