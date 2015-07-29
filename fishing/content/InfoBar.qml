import QtQuick 2.0

Item {
    id: infoBar

    property int lives: 3
    property int score: 0
    property int coins: 100

    Row {
        id: lives
        anchors.left: parent.left
        anchors.leftMargin: 10
        spacing: 5

        Repeater {
            model: infoBar.lives
            delegate: Image { source: "gfx/lifes.png" }
        }
    }

    Row {
        id: coins
        anchors.right: parent.right
        anchors.rightMargin: 10
        spacing: 5

        Image { source: "gfx/points.png" }
        Text { text: infoBar.coins; font.bold: true; }
    }

    Row {
        id: score
        anchors.right: coins.left
        anchors.rightMargin: 20
        spacing: 5

        Image { source: "gfx/scores.png" }
        Text { text: infoBar.score; font.bold: true; }
    }
}

