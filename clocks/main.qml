import QtQuick 2.3
import "content" as Content

Rectangle {
    id: root
    width: 640; height: 320
    color: "#646464"

    ListView {
        id: clockView
        anchors.fill: parent
        focus: true
        orientation: ListView.Horizontal
        cacheBuffer: 2000
        highlightRangeMode: ListView.ApplyRange
        snapMode: ListView.SnapToItem

        delegate: Content.Clock { city: cityName; shift: timeShift; }
        model: ListModel {
            ListElement { cityName: "Beijing"; timeShift: 8 }
            ListElement { cityName: "London"; timeShift: 0 }
            ListElement { cityName: "Los Angeles"; timeShift: -8 }
            ListElement { cityName: "New York"; timeShift: -4 }
            ListElement { cityName: "Oslo"; timeShift: 1 }
            ListElement { cityName: "Mumbai"; timeShift: 5.5 }
            ListElement { cityName: "Brisbane"; timeShift: 10 }
        }

        Keys.onPressed: {
            if (event.key === Qt.Key_4 || event.key === Qt.Key_Up) {
                clockView.decrementCurrentIndex()
            } else if (event.key === Qt.Key_6 || event.key === Qt.Key_Down) {
                clockView.incrementCurrentIndex()
            }
            console.log("key: " + event.key + ". index: " + clockView.currentIndex)
        }
    }

    /* left arrow */
    Image {
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.margins: 10
        rotation: -90
        source: "content/arrow.png"
        opacity: clockView.atXBeginning ? 0 : 0.8
        Behavior on opacity { NumberAnimation { duration: 200 } }

        MouseArea {
            anchors.fill: parent
            onPressed: clockView.decrementCurrentIndex()
        }
    }
    /* right arrow */
    Image {
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 10
        rotation: 90
        source: "content/arrow.png"
        opacity: clockView.atXEnd ? 0 : 0.8
        Behavior on opacity { NumberAnimation { duration: 200 } }
        MouseArea {
            anchors.fill: parent
            onPressed: clockView.incrementCurrentIndex()
        }
    }
}
