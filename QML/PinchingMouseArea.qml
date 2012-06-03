import QtQuick 1.1

Rectangle {
    color: "#11262B"
    width: 480
    height: 848

    Text {
        id: log
        anchors.fill: parent
        anchors.margins: 10
        font.pixelSize: 14
        color: "snow"
    }

    // PinchArea inside MouseArea will disable the MouseArea completely
    // But the opposite way the work nicely

/*
MouseArea onEntered
MouseArea onPressed
MouseArea onPositionChanged
PinchArea onPinchStarted
MouseArea onCanceled
PinchArea onPinchUpdated
..
PinchArea onPinchUpdated
PinchArea onPinchFinished
*/


    PinchArea {
        anchors.fill: parent
        onPinchFinished: {
            log.text += "PinchArea onPinchFinished" + "\n"
        }
        onPinchStarted: {
            log.text += "PinchArea onPinchStarted" + "\n"
        }
        onPinchUpdated: {
            log.text += "PinchArea onPinchUpdated" + "\n"
        }

        MouseArea {
            anchors.fill: parent
            onCanceled: {
                log.text += "MouseArea onCanceled" + "\n"
            }
            onClicked: {
                log.text += "MouseArea onClicked" + "\n"
            }
            onDoubleClicked: {
                log.text += "MouseArea onDoubleClicked" + "\n"
            }
            onEntered: {
                log.text += "MouseArea onEntered" + "\n"
            }
            onExited: {
                log.text += "MouseArea onExited" + "\n"
            }
            onPositionChanged: {
                log.text += "MouseArea onPositionChanged" + "\n"
            }
            onPressAndHold: {
                log.text += "MouseArea onPressAndHold" + "\n"
            }
            onPressed: {
                log.text += "MouseArea onPressed" + "\n"
            }
            onReleased: {
                log.text += "MouseArea onReleased" + "\n"
            }
        }
    }
}
