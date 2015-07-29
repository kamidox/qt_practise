import QtQuick 2.0

Item {
    id: newGameScreen
    width: 320
    height: 480

    signal startButtonClicked()

    // logo
    Image {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 60

        source: "gfx/logo.png"
    }

    // logo-fish
    Image{
        anchors.top: parent.top

        source: "gfx/logo-fish.png"

        SequentialAnimation on x {
            loops: Animation.Infinite
            NumberAnimation { from: x + 148; to: x + 25; duration: 2000; easing.type: Easing.InOutQuad  }
            NumberAnimation { from: x + 25; to: x + 148; duration: 1600; easing.type: Easing.InOutQuad  }
        }

        SequentialAnimation on anchors.topMargin {
            loops: Animation.Infinite
            NumberAnimation { from: 100; to: 60; duration: 1600; easing.type: Easing.InOutQuad  }
            NumberAnimation { from: 60; to: 100; duration: 2000; easing.type: Easing.InOutQuad  }
        }
    }

    // logo-bubble
    Image{
        anchors.top: parent.top

        source: "gfx/logo-bubble.png"

        SequentialAnimation on x {
            loops: Animation.Infinite
            NumberAnimation { from: x + 148; to: x + 25; duration: 2000; easing.type: Easing.InOutQuad }
            NumberAnimation { from: x + 25; to: x + 148; duration: 1600; easing.type: Easing.InOutQuad  }
        }

        SequentialAnimation on anchors.topMargin {
            loops: Animation.Infinite
            NumberAnimation { from: 100; to: 60; duration: 1600; easing.type: Easing.InOutQuad  }
            NumberAnimation { from: 60; to: 100; duration: 2000; easing.type: Easing.InOutQuad  }
        }

        SequentialAnimation on width {
            loops: Animation.Infinite
            NumberAnimation { from: 140; to: 160; duration: 1000; easing.type: Easing.InOutQuad  }
            NumberAnimation { from: 160; to: 140; duration: 800; easing.type: Easing.InOutQuad  }
        }

        SequentialAnimation on height {
            loops: Animation.Infinite
            NumberAnimation { from: 140; to: 150; duration: 800; easing.type: Easing.InOutQuad  }
            NumberAnimation { from: 150; to: 140; duration: 1000; easing.type: Easing.InOutQuad  }
        }
    }

    // start game button
    Image {
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 60
        anchors.horizontalCenter: parent.horizontalCenter

        source: "gfx/button-play.png"

        MouseArea {
            anchors.fill: parent
            onClicked: {
                console.info("startButtonClicked");
                newGameScreen.startButtonClicked();
            }
        }
    }
}
