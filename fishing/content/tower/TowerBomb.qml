import QtQuick 2.0

TowerBase {
    id: towerBomb

    costs: 75
    lives: 1
    damage: 10
    range: 1
    interval: 10

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

