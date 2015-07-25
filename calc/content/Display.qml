import QtQuick 2.0
import QtQuick.Window 2.0
import QtQml.Models 2.2

Item {
    id: display

    property real fontSize: Math.floor(Screen.pixelDensity * 5.0)
    property bool enteringDigits: false
    property int maxDigits: (width / fontSize) + 1
    property string displayedOperand
    property string errorString: qsTr("ERROR")
    property bool isError: displayedOperand === errorString

    function displayOperator(op) {
        listView.model.append( {"operator": op, "operand": ""} );
        enteringDigits = true
        listView.positionViewAtEnd()
    }

    function newLine(operator, operand) {
        displayedOperand = displayNumber(operand)
        listView.model.append( {"operator": operator, "operand": displayedOperand} )
        enteringDigits = false
        listView.positionViewAtEnd()
    }

    function appendDigit(digit) {
        if (!enteringDigits) {
            listView.model.append( {"operator": "", "operand": ""} )
        }
        var i = listView.count - 1
        listView.model.get(i).operand = listView.model.get(i).operand + digit
        enteringDigits = true
        listView.positionViewAtEnd()
    }

    function setDigit(digit) {
        var i = listView.model.count - 1
        listView.model.get(i).operand = digit
        listView.positionViewAtEnd()
    }

    function clear() {
        var displayError = isError

        displayedOperand = ""
        enteringDigits = false
        listView.model.clear()

        if (displayError) {
            listView.model.append( {"operator": "", "operand": errorString} )
        }
    }

    // Returns a string representation of a number that fits in
    // display.maxDigits characters, trying to keep as much precision
    // as possible. If the number cannot be displayed, returns an
    // error string.
    function displayNumber(num) {
        if (typeof(num) != "number")
            return errorString;

        var intNum = parseInt(num);
        var intLen = intNum.toString().length;

        // Do not count the minus sign as a digit
        var maxLen = num < 0 ? maxDigits + 1 : maxDigits;

        if (num.toString().length <= maxLen) {
            if (isFinite(num))
                return num.toString();
            return errorString;
        }

        // Integer part of the number is too long - try
        // an exponential notation
        if (intNum == num || intLen > maxLen - 3) {
            var expVal = num.toExponential(maxDigits - 6).toString();
            if (expVal.length <= maxLen)
                return expVal;
        }

        // Try a float presentation with fixed number of digits
        var floatStr = parseFloat(num).toFixed(maxDigits - intLen - 1).toString();
        if (floatStr.length <= maxLen)
            return floatStr;

        return errorString;
    }

    Item {
        id: displayArea
        width: parent.width + 32    // plus the width of paper edge
        height: parent.height

        Rectangle {
            id: rect
            x: 16
            color: "white"
            height: parent.height
            width: display.width - 16
        }

        Image {
            anchors.right: rect.left
            height: parent.height
            source: "images/paper-edge-left.png"
            fillMode: Image.TileVertically
        }

        Image {
            anchors.left: rect.right
            height: parent.height
            source: "images/paper-edge-right.png"
            fillMode: Image.TileVertically
        }

        Image {
            id: grip
            source: "images/paper-grip.png"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20
        }

        ListView {
            id: listView
            x: 16; y: 10
            width: display.width
            height: display.height - y - 50 // minus height of grip
            delegate: Item {
                width: parent.width
                height: display.fontSize * 1.1
                Text {
                    id: operator
                    x: 6
                    font.pixelSize: display.fontSize
                    color: "#6da43d"
                    text: model.operator
                }
                Text {
                    id: operand
                    font.pixelSize: display.fontSize
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    text: model.operand
                }
            }
            model: ListModel {}
        }
    }
}
