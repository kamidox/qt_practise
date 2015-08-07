import QtQuick 2.0
import "../Model.js" as Model

TowerBase {
    id: towerShooter

    costs: 50
    lives: 2
    damage: 0       // by realDamage when hit
    range: 6
    interval: 40    // 40 x 16 ms, interval between two fire

    property var targetFish
    property real realDamage: 1

    function fire() {
        ball.x = 32 - ball.with / 2
        ball.y = 0
        targetFish = Model.gameState.fishs[towerShooter.col][0]
        ballAnim.to = targetFish.y - towerShooter.y - 10
        ballAnim.start()
        sprite.jumpTo("fire")
    }

    Image {
        id: ball
        y: 1000
        SequentialAnimation on y {
            id: ballAnim
            running: false

            property real to: 1000

            SmoothedAnimation {
                to: ballAnim.to
                velocity: 400
            }

            ScriptAction {
                script: {
                    if (towerShooter.targetFish && towerShooter.targetFish.hit) {
                        towerShooter.targetFish.hit(towerShooter.realDamage)
                        owerShooter.targetFish.inked()
                    }
                }
            }

            PropertyAction { value: 1000 }
        }

        source: "../gfx/projectile.png"
    }

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

