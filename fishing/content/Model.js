.pragma library
.import QtQuick 2.0 as QQ

// share the instance of GameCanvas, pleas refer to GameCanvas.qml
var gameState

var towerData = [
    { "name": "TowerMelee", "cost": 20 },
    { "name": "TowerShooter", "cost": 50 },
    { "name": "TowerBomb", "cost": 75 },
    { "name": "TowerStar", "cost": 25 },
]
var towerComponents
var fishComponent

function getGameState() {
    return gameState
}

function newGameState(canvas) {
    towerComponents = new Array(towerData.length)
    for (var i = 0; i < towerData.length; i ++) {
        towerComponents[i] = Qt.createComponent("tower/" + towerData[i].name + ".qml")
        if (towerComponents[i].status == QQ.Component.Error) {
            console.error("Failed to create component " + towerData[i].name + "\n" + (towerComponents[i].errorString()))
            return
        }
    }
    fishComponent = Qt.createComponent("Fish.qml")
    if (fishComponent.status == QQ.Component.Error) {
        console.error("Failed to create component Fish\n" + (fishComponent.errorString()))
        return
    }

    gameState = canvas
    gameState.fleshState()
    gameState.towers = new Array(gameState.cols * gameState.rows)
    gameState.fishs = new Array(gameState.cols)
    return gameState
}

function startGame() {
    gameState.fleshState()
    for (var i = 0; i < gameState.rows; i ++) {
        for (var j = 0; j < gameState.cols; j ++) {
            gameState.towers[towerIdx(i, j)] = null
        }
        gameState.fishs[i] = new Array()
    }
    gameState.gameOver = false
    gameState.gameRunning = true
}

function killFish(col, fish) {
    if (!fish) {
        return
    }
    var idx = gameState.fishs[col].indexOf(fish)
    if (idx < 0 || fish.lives <= 0) {
        return
    }
    fish.lives = 0
    fish.die()
    gameState.fishs[col].splice(idx, 1)
}

function row(x) {
    return Math.floor(x / gameState.cellSize);
}

function col(y) {
    return Math.floor(y / gameState.cellSize);
}

function towerIdx(row, col) {
    return col + (row * gameState.rows)
}

function newFish(col) {
    var fish = fishComponent.createObject(gameState)
}
