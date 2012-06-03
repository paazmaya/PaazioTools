import QtQuick 1.1

Rectangle {
    color: "#11262B"
    width: 480
    height: 848

    Text {
        id: log
        anchors.fill: parent
        anchors.margins: 10
        font.pointSize: 12
        color: "snow"
    }

    Flickable {
        id: flickArea

        anchors.fill: parent
        contentHeight: col.height
        opacity: 0.5 // so the log can be seen

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

            Column {
                id: col
                spacing: 10

                Repeater {
                    model: 20

                    Rectangle {
                        width: flickArea.width
                        height: 50
                        color: Qt.rgba(Math.random(),
                            Math.random(), Math.random(), 1)

                        Text {
                            anchors.centerIn: parent
                            text: index
                            font.pointSize: 16
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                parent.color = Qt.rgba(Math.random(),
                                    Math.random(), Math.random(), 1)
                            }
                        }
                    }
                }
            }
        }
    }
}
