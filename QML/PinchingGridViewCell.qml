/* PinchingGridViewCell.qml */
import QtQuick 2.0

Rectangle {
    id: main
    color: "#11262B"
    width: 480
    height: 848

    Component {
        id: gridDelegate
        Item {
            id: blockItem

            // Will reset to these values when outside visible area
            property real scaling: 1
            property real rotationing: -25
            property color fillColor: Qt.rgba(Math.random(),
            	Math.random(), Math.random(), 1)

            width: gridArea.cellWidth
            height: gridArea.cellHeight

            Rectangle {
                width: parent.width * blockItem.scaling
                height: parent.height * blockItem.scaling
                anchors.centerIn: parent
                rotation: blockItem.rotationing
                transformOrigin: Item.Center
                color: blockItem.fillColor

                Text {
                    anchors.centerIn: parent
                    text: index
                    font.pointSize: 14
                    color: "snow"
                }
            }

            // Once pinch starts, the area is made bigger
            PinchArea {
                property real initRotation: 0
                property real initScale: 1

                anchors.fill: parent
                onPinchStarted: {
                    anchors.margins = -100
                    initRotation = blockItem.rotationing
                    initScale = blockItem.scaling
                }
                onPinchFinished: {
                    // last event if pinch
                    anchors.margins = 0
                    blockItem.z--;
                    redBorders.visible = false
                }
                onPinchUpdated: {
                    blockItem.scaling = initScale * pinch.scale
                    blockItem.rotationing = initRotation + pinch.rotation
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        blockItem.fillColor = Qt.rgba(Math.random(),
                            Math.random(), Math.random(), 1)
                    }
                    onPressed: {
                        // This is the first interaction to both pinch and mouse areas
                        blockItem.z++;
                        redBorders.visible = true
                    }
                    onReleased: {
                        // Last event if mouse
                        blockItem.z--;
                        redBorders.visible = false
                    }

                    // See where MouseArea is affecting
                    Rectangle {
                        id: redBorders
                        anchors.fill: parent
                        color: "transparent"
                        border.width: 4
                        border.color: "red"
                        opacity: 0.5
                        visible: parent.pressed || parent.parent.pinch.active
                    }

                }
            }
        }
    }

    GridView {
        id: gridArea
        anchors.fill: parent
        cellWidth: 200
        cellHeight: 120
        contentWidth: childrenRect.width
        contentHeight: childrenRect.height
        model: 2000
        delegate: gridDelegate
    }
}
