import QtQuick 2.3
import QtQuick.Particles 2.0

Image {
    id: backgroud
    anchors.bottom: view.bottom
    source: "gfx/background.png"

    property var view

    ParticleSystem {
        id: bubbleParticle
        anchors.fill: parent

        ImageParticle {
            id: bubble
            source: "gfx/catch.png"
            opacity: 0.25
        }

        Emitter {
            width: parent.width
            height: 150
            anchors.bottom: parent.bottom

            startTime: 15000
            emitRate: 2
            lifeSpan: 15000

            acceleration: PointDirection {y: -6; xVariation: 2; yVariation: 2}

            size: 24
            sizeVariation: 16
        }
    }
}

