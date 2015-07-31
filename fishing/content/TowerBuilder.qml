import QtQuick 2.0

Item {
    id: towerBuilder

    property alias source: towerImage.source
    property alias cost: towerCost.text

    Image {
        id: towerImage
        anchors.horizontalCenter: parent.horizontalCenter
        y: -10
    }

    Text {
        id: towerCost
        anchors.top: towerImage.bottom
        anchors.topMargin: -8
        anchors.horizontalCenter: parent.horizontalCenter

        font.pointSize: 14
        font.bold: true
        color: "white"
    }
}

