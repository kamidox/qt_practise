.pragma library
.import QtQuick 2.0 as QQ

// share the instance of GameCanvas, pleas refer to GameCanvas.qml
var gameState;

function getGameState() {
    return gameState;
}

function newGameState(canvas) {
    gameState = canvas;
    return gameState;
}

function row(x) {
    return Math.floor(x / gameState.cellSize);
}

function col(y) {
    return Math.floor(y / gameState.cellSize);
}
