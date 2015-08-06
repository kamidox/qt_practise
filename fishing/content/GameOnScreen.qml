import QtQuick 2.0
import "Model.js" as Model

Item {
    id: gameOnScreen
    width: 320
    height: 480

    property int countdown: 10
    property var gameState

    function startGame() {
        gameOnScreen.countdown = 0
        Model.startGame()
    }

    // waves
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

    // sun lights
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

    // grid
    Image {
        x: 0; y: 0;
        source: "gfx/grid.png"
        opacity: 0.5
    }

    // info bar
    InfoBar { width: parent.width; anchors.top: parent.top; anchors.topMargin: 50; }

    GameCanvas {
        id: canvas
        anchors.left: parent.left
        anchors.leftMargin: 32
        anchors.top: parent.top
        anchors.topMargin: 84

        focus: true
    }

    // 3..2..1..GO
    Timer {
        id: countDownTimer
        interval: 1000
        repeat: true
        running: gameOnScreen.countdown < 5
        onTriggered: {
            console.info("GameOnScreen: countdown=" + gameOnScreen.countdown);
            gameOnScreen.countdown ++;
        }
    }
    Repeater {
        model: ["gfx/text-blank.png", "gfx/text-3.png", "gfx/text-2.png", "gfx/text-1.png", "gfx/text-go.png"]
        delegate: Image {
            visible: gameOnScreen.countdown == index
            opacity: gameOnScreen.countdown == index ? 0.5 : 0.1
            scale: gameOnScreen.countdown == index ? 1.0 : 0.0
            source: modelData
            Behavior on opacity { NumberAnimation {} }
            Behavior on scale { NumberAnimation {} }
        }
    }

    Component.onCompleted: gameState = Model.newGameState(canvas)
}
