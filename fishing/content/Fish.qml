import QtQuick 2.0
import "Model.js" as Model

Item {
    id: fish
    width: 64
    height: 64
    x: col * 64

    property int col: 0
    property real lives: 3
    property real damage: 1
    property real speed: 0.25
    property int interval: 30   // in ticks
    property int fireCounter: 0
    property bool dying: false

    function fire() {}

    function die() {
        if (dying) {
            return
        }
        dying = true
        bubbleSprite.jumpTo("burst")
        if (fishSprite.currentSprite == "front") {
            fishSprite.jumpTo(Math.random() > 0.5 ? "left" : "right")
        }
        Model.gameState.score += 1
        destroy(500)
    }

    function hit(dmg) {
        lives -= dmg
        if (lives < 0) {
            Model.killFish(col, fish)
        }
    }

    function ink() {
        if (lives > 0) {
            ink.jumpTo("dirty")
        }
    }

    // fish sprite
    SpriteSequence {
        id: fishSprite
        width: 64
        height: 64
        interpolate: false

        Sprite {
            name: "right"
            source: "gfx/mob-idle.png"
            frameWidth: 64
            frameHeight: 64
            frameCount: 1
            frameDuration: 800
            frameDurationVariation: 400
            to: { "front": 1 }
        }

        Sprite {
            name: "front"
            source: "gfx/mob-idle.png"
            frameX: 64
            frameY: 0
            frameWidth: 64
            frameHeight: 64
            frameCount: 1
            frameDuration: 800
            frameDurationVariation: 400
            to: { "left": 1, "right": 1 }
        }

        Sprite {
            name: "left"
            source: "gfx/mob-idle.png"
            frameX: 128
            frameY: 0
            frameWidth: 64
            frameHeight: 64
            frameCount: 1
            frameDuration: 800
            frameDurationVariation: 400
            to: { "front": 1 }
        }
    }

    // bubble sprite
    SpriteSequence {
        id: bubbleSprite
        width: 64
        height: 64
        scale: 0.4 + (0.2 * lives)
        interpolate: false

        Sprite {
            name: "normal"
            source: "gfx/catch.png"
            frameWidth: 64
            frameHeight: 64
            frameCount: 1
            to: { "burst": 0 }
        }

        Sprite {
            name: "burst"
            source: "gfx/catch-action.png"
            frameWidth: 64
            frameHeight: 64
            frameCount: 3
            frameDuration: 200
        }

        SequentialAnimation on width {
            loops: Animation.Infinite
            NumberAnimation { from: width; to: width * 1.1; duration: 800; easing.type: Easing.InOutQuad }
            NumberAnimation { from: width * 1.1; to: width; duration: 1000; easing.type: Easing.InOutQuad }
        }
        SequentialAnimation on height {
            loops: Animation.Infinite
            NumberAnimation { from: height; to: height * 1.15; duration: 1200; easing.type: Easing.InOutQuad }
            NumberAnimation { from: height * 1.15; to: height; duration: 1000; easing.type: Easing.InOutQuad }
        }
    }

    // ink sprite
    SpriteSequence {
        id: ink
        width: 64
        height: 64
        scale: bubbleSprite.scale

        Sprite {
            name: "clean"
            source: "gfx/projectile-action.png"
            frameCount: 1
            frameWidth: 64
            frameHeight: 64
            to: { "dirty": 0 }
        }

        Sprite {
            name: "dirty"
            source: "gfx/projectile-action.png"
            frameCount: 3
            frameWidth: 64
            frameHeight: 64
            frameX: 64
            frameDuration: 150
            to: { "clean": 1 }
        }
        SequentialAnimation on width {
            loops: Animation.Infinite
            NumberAnimation { from: width; to: width * 1.1; duration: 800; easing.type: Easing.InOutQuad }
            NumberAnimation { from: width * 1.1; to: width; duration: 1000; easing.type: Easing.InOutQuad }
        }
        SequentialAnimation on height {
            loops: Animation.Infinite
            NumberAnimation { from: height; to: height * 1.15; duration: 1200; easing.type: Easing.InOutQuad }
            NumberAnimation { from: height * 1.15; to: height; duration: 1000; easing.type: Easing.InOutQuad }
        }
    }

    Behavior on x {
        NumberAnimation { from: x; to: x - 5; duration: 800; easing.type: Easing.InOutQuad }
        NumberAnimation { from: x - 5; to: x; duration: 800; easing.type: Easing.InOutQuad }
    }
}

