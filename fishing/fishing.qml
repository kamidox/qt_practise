import QtQuick 2.3
import "content"

Item {
    id: root
    width: 320
    height: 480

    Background {view: view}

    Column {
        id: view
        width: 320
        y: -960

        GameOverScreen {}
        GaveOnScreen {}
        NewGameScreen {
            onStartButtonClicked: view.y = -480
        }

        Behavior on y {
            NumberAnimation { duration: 1000; easing.type: Easing.OutQuad }
        }
    }

}

