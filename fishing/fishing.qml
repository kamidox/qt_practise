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

        GameOverScreen {
            gameCanvas: gameOnScreen.gameState
            onStartButtonClicked: {
                // start the game
                gameOnScreen.startGame()
            }
        }
        GameOnScreen { id: gameOnScreen }
        NewGameScreen {
            onStartButtonClicked: {
                // start the game
                gameOnScreen.startGame()
            }
        }

        Behavior on y {
            NumberAnimation { duration: 1000; easing.type: Easing.OutQuad }
        }
    }

    states: [
        State {
            name: "gameOn"
            when: gameOnScreen.gameState.gameOver == false && gameOnScreen.gameState.gameRunning
            PropertyChanges {target: view; y: -480}
        },
        State {
            name: "gameOver"
            when: gameOnScreen.gameState.gameOver
            PropertyChanges {target: view; y: 0}
        }
    ]
}

