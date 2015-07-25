import QtQuick 2.0

Item {
    id: clock
    width: {
        if (ListView.view && ListView.view.width >= 200) {
            return ListView.view.width / Math.floor(ListView.view.width / 200.0);
        } else {
            return 200;
        }
    }
    height: {
        if (ListView.view && ListView.view.height >= 240) {
            return ListView.view.height;
        } else {
            return 240;
        }
    }

    property alias city: cityName.text
    property int shift
    property bool internationalTime: true

    property int hours
    property int minutes
    property int seconds
    property bool night: false

    function timeChanged() {
        var date = new Date;
        hours = clock.internationalTime
                    ? date.getUTCHours() + Math.floor(clock.shift)
                    : date.getHours() + Math.floor(clock.shift);
        night = (hours < 7 || hours > 19)
        minutes = clock.internationalTime
                    ? date.getUTCMinutes() + (shift % 1) * 60
                    : date.getMinutes() + (shift % 1) * 60
        seconds = clock.internationalTime ? date.getUTCSeconds() : date.getSeconds()
    }

    Timer {
        interval: 1000; repeat: true; running: true; triggeredOnStart: true;
        onTriggered: timeChanged()
    }

    Item {
        anchors.centerIn: parent
        width: 200; height: 240

        Image { id: background; source: "clock.png"; visible: clock.night == false }
        Image { source: "clock-night.png"; visible: clock.night == true }

        /* hour */
        Image {
            x: 92.5; y: 27
            source: "hour.png"
            transform: Rotation {
                id: hourRotation
                origin.x: 7.5; origin.y: 73;
                angle: (clock.hours * 30) + (clock.minutes * 0.5)
                Behavior on angle {
                    SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
                }
            }
        }

        /* minutes */
        Image {
            x: 93.5; y: 17
            source: "minute.png"
            transform: Rotation {
                id: minuteRotation
                origin.x: 6.5; origin.y: 83;
                angle: clock.minutes * 6
                Behavior on angle {
                    SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
                }
            }
        }

        /* seconds */
        Image {
            x: 97.5; y: 20
            source: "second.png"
            transform: Rotation {
                id: secondRotation
                origin.x: 2.5; origin.y: 80;
                angle: clock.seconds * 6
                Behavior on angle {
                    SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
                }
            }
        }

        /* center point */
        Image {
            anchors.centerIn: background; source: "center.png"
        }

        Text {
            id: cityName
            y: 210
            anchors.horizontalCenter: parent.horizontalCenter
            color: "white"
        }
    }
}

