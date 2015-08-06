import QtQuick 2.0
import QtQuick.Particles 2.0
import "Model.js" as Model

Item {
    id: gameOverScreen
    width: 320
    height: 480

    property var gameCanvas
    signal startButtonClicked()

    Image {
        id: img
        source: "gfx/text-gameover.png"
        anchors.centerIn: parent
    }

    ParticleSystem {
        anchors.fill: parent
        ImageParticle {
            id: cloud
            source: "gfx/cloud.png"
            alphaVariation: 0.25
            opacity: 0.25
        }

        Wander {
            xVariance: 100;
            pace: 1;
        }

        Emitter {
            id: cloudLeft
            width: 160
            height: 160
            anchors.right: parent.left
            emitRate: 0.5
            lifeSpan: 12000
            velocity: PointDirection{ x: 64; xVariation: 2; yVariation: 2 }
            size: 120
            sizeVariation: 40
        }

        Emitter {
            id: cloudRight
            width: 160
            height: 160
            anchors.left: parent.right
            emitRate: 0.5
            lifeSpan: 12000
            velocity: PointDirection{ x: -64; xVariation: 2; yVariation: 2 }
            size: 120
            sizeVariation: 40
        }
    }


    Text {
        visible: gameCanvas != undefined
        text: "You saved " + gameCanvas.score + " fishes!"
        anchors.top: img.bottom
        anchors.topMargin: 12
        anchors.horizontalCenter: parent.horizontalCenter
        font.bold: true
        color: "#000000"
        opacity: 0.5
    }

    Image {
        source: "gfx/button-play.png"
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        MouseArea {
            anchors.fill: parent
            onClicked: gameOverScreen.startButtonClicked()
        }
    }
}
