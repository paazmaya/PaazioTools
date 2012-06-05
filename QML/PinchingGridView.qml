/* PinchingGridView.qml */
import QtQuick 2.0

Rectangle {
    id: main

    property real scalingX: 1
    property real scalingY: 1

    color: "#11262B"
    width: 480
    height: 848

    Component {
        id: gridDelegate
        Rectangle {
            width: gridArea.cellWidth
            height: gridArea.cellHeight
            color: Qt.rgba(Math.random(),
                Math.random(), Math.random(), 1)

            Text {
                anchors.centerIn: parent
                text: index
                font.pointSize: 14
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

    PinchArea {
        property real initScaleX: 1
        property real initScaleY: 1

        anchors.fill: parent
        onPinchStarted: {
            initScaleX = main.scalingX;
            initScaleY = main.scalingY;
        }
        onPinchUpdated: {
            var radians = pinch.angle * Math.PI / 180;

            var scaleX = Math.abs(Math.cos(radians) * pinch.scale);
            var scaleY = Math.abs(Math.sin(radians) * pinch.scale);

            main.scalingX = initScaleX * scaleX;
            main.scalingY = initScaleY * scaleY;
        }

        // Only by placing the given view inside PinchArea, can the pinch event be canceled
        GridView {
            id: gridArea
            anchors.fill: parent
            cellWidth: 120 * main.scalingX
            cellHeight: 80 * main.scalingY
            contentWidth: childrenRect.width
            contentHeight: childrenRect.height
            model: 200
            delegate: gridDelegate
        }
    }
}
