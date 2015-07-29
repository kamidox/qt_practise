import QtQuick 2.0

Item {
    id: gameOnScreen
    width: 320
    height: 480

    Image {
        id: frontWave
        anchors.top: parent.top
        source: "gfx/wave.png"

        NumberAnimation on x { from: 0; to: -(frontWave.width) + 320; duration: 16000; loops: Animation.Infinite }
        SequentialAnimation on anchors.topMargin {
            loops: Animation.Infinite
            NumberAnimation { from: 30; to: 34; duration: 1500; easing.type: Easing.InOutQuad }
            NumberAnimation { from: 34; to: 30; duration: 1500; easing.type: Easing.InOutQuad }
        }
    }

    Image {
        id: backWave
        anchors.top: parent.top

        opacity: 0.5
        source: "gfx/wave.png"

        NumberAnimation on x { from: -(backWave.width) + 320; to: 0; duration: 35000; loops: Animation.Infinite }
        SequentialAnimation on anchors.topMargin {
            loops: Animation.Infinite
            NumberAnimation { from: 30; to: 25; duration: 1500; easing.type: Easing.InOutQuad }
            NumberAnimation { from: 25; to: 30; duration: 1500; easing.type: Easing.InOutQuad }
        }
    }

    Image {
        y: 0
        anchors.horizontalCenter: parent.horizontalCenter
        opacity: 0.04
        source: "gfx/sunlight.png"
        transformOrigin: Item.Top
        SequentialAnimation on rotation {
            loops: Animation.Infinite
            NumberAnimation { from: -10; to: 10; duration: 8000; easing.type: Easing.InOutSine }
            NumberAnimation { from: 10; to: -10; duration: 8000; easing.type: Easing.InOutSine }
        }
    }

    Image {
        y: 0
        anchors.horizontalCenter: parent.horizontalCenter
        opacity: 0.02
        source: "gfx/sunlight.png"
        transformOrigin: Item.Top
        SequentialAnimation on rotation {
            loops: Animation.Infinite
            NumberAnimation { from: 10; to: -10; duration: 8000; easing.type: Easing.InOutSine }
            NumberAnimation { from: -10; to: 10; duration: 8000; easing.type: Easing.InOutSine }
        }
    }

    Image {
        x: 0; y: 0;
        source: "gfx/grid.png"
        opacity: 0.5
    }

    InfoBar { width: parent.width; anchors.top: parent.top; anchors.topMargin: 50; }
}
