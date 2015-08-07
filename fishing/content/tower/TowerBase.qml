import QtQuick 2.0

Item {
    id: towerBase
    width: 64
    height: 64
    x: col * width
    y: row * height

    property int col: 0
    property int row: 0
    property real lives: 3
    property int costs: 0
    property int income: 0
    property real range: 0
    property real damage: 0
    property int interval: 0
    property int fireCounter: 0

    function fire() {}
    function die() {
        flashAnim.start()
        destroy(1000)
    }
    function spawn() { } //After all game properties are set

    SequentialAnimation on opacity {
        id: flashAnim
        running: false
        loops: 2
        NumberAnimation { from: 1; to: 0; duration: 250 }
        NumberAnimation { from: 0; to: 1; duration: 250 }
    }
}

