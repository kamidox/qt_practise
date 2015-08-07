import QtQuick 2.0
import "Model.js" as Model

Item {
    id: towerBuilder

    property alias source: towerImage.source
    property alias cost: towerCost.text

    property bool canBuild: true
    property var gameCanvas
    property int col: 0
    property int row: 0
    property int towerType: 0

    signal clicked()

    Image {
        id: towerImage
        anchors.horizontalCenter: parent.horizontalCenter
        y: -10
        opacity: (canBuild && (gameCanvas.coins >= Model.towerData[towerType].cost)) ? 1.0 : 0.4
    }

    Text {
        id: towerCost
        anchors.top: towerImage.bottom
        anchors.topMargin: -8
        anchors.horizontalCenter: parent.horizontalCenter

        font.pointSize: 14
        font.bold: true
        color: "white"
        text: Model.towerData[towerType].cost
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            Model.buildTower(towerType, col, row)
            towerBuilder.clicked()
        }
    }
}

