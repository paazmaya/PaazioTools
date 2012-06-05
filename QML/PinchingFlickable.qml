/* PinchingFlickable.qml */
import QtQuick 2.0

Rectangle {
    id: main

    property real itemHeight: 50

    color: "#11262B"
    width: 480
    height: 848

    Flickable {
        id: flickArea
        anchors.fill: parent
        contentHeight: col.height

        PinchArea {
            property real initHeight: 0

            anchors.fill: parent
            onPinchStarted: {
                initHeight = main.itemHeight
            }
            onPinchUpdated: {
                main.itemHeight = initHeight * pinch.scale
            }

            Column {
                id: col
                spacing: 10

                Repeater {
                    model: 200

                    Rectangle {
                        width: flickArea.width
                        height: main.itemHeight
                        color: Qt.rgba(Math.random(),
                            Math.random(), Math.random(), 1)

                        Text {
                            anchors.centerIn: parent
                            text: "Item at position: " + index
                            font.pointSize: 16
                            color: "snow"
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
