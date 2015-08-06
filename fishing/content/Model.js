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

//var waveBaseData = [300, 290, 280, 270, 220, 180, 160, 80, 80, 80, 30, 30, 30, 30]
var waveBaseData = [60, 60, 50, 50, 40, 40, 30, 30, 30, 20, 20, 20, 10, 10]
var waveData

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
    waveData = new Array()
    for (var i in waveBaseData) {
        waveData[i] = waveBaseData[i]
    }
    gameState.fleshState()
    for (var i = 0; i < gameState.cols; i ++) {
        for (var j = 0; j < gameState.rows; j ++) {
            if (gameState.towers[towerIdx(i, j)]) {
                gameState.towers[towerIdx(i, j)].destroy()
            }
            gameState.towers[towerIdx(i, j)] = null
        }
        gameState.fishs[i] = new Array()
    }
    gameState.gameOver = false
    gameState.gameRunning = true
}

function endGame() {
    gameState.gameRunning = false
    gameState.gameOver = true
    for (var i = 0; i < gameState.cols; i ++) {
        for (var j = 0; j < gameState.rows; j ++) {
            if (gameState.towers[towerIdx(i, j)]) {
                gameState.towers[towerIdx(i, j)].destroy()
                gameState.towers[towerIdx(i, j)] = null
            }
        }
        for (var j in gameState.fishs[i]) {
            gameState.fishs[i][j].destroy()
        }
        gameState.fishs[i].splice(0, gameState.fishs[i].length)
    }
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

function towerIdx(x, y) {
    return y + (x * gameState.rows)
}

function newFish(col) {
    var fish = fishComponent.createObject(gameState,
                { "col": col,
                  "speed": Math.min(2.0, 0.10 * (gameState.waveIndex + 1)),
                  "y": gameState.height });
    if (fish == null) {
        console.error("error to create fish")
        return
    }

    gameState.fishs[col].push(fish)
    return fish
}

function tick() {
    if (!gameState.gameRunning) {
        return;
    }

    // spawn new fish
    gameState.waveProgress += 1;
    var i = gameState.waveProgress;
    var j = 0;
    while (i > 0 && j < waveData.length) {
        i -= waveData[j];
        j ++;
    }
    if (i == 0) {
        newFish(Math.floor(Math.random() * gameState.cols))
    }
    if (j == waveData.length) {
        // next wave. Increase the spawn speed and fish speed
        gameState.waveIndex += 1;
        gameState.waveProgress = 0;
        var delta = 10;
        for (var k in waveData) {
            if (waveData[k] > delta) {
                waveData[k] -= delta;
            }
        }
    }

    // fish move
    for (var m = 0; m < gameState.cols; m ++) {
        for (var n = 0; n < gameState.fishs[m].length; n ++) {
            var fish = gameState.fishs[m][n]
            var newPos = fish.y - fish.speed
            if (newPos < 0) {
                gameState.lives -= 1
                killFish(m, fish)
                if (gameState.lives <= 0) {
                    endGame();
                    return
                }
                continue
            }

            fish.y = newPos
        }
    }
}
