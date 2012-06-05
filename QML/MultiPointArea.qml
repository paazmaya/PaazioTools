/* MultiPointArea.qml */
// http://doc.qt.nokia.com/qt5/qtquick-2.html
import QtQuick 2.0

Rectangle {
    id: main
    color: "#11262B"
    width: 800
    height: 600

    // Blocks shown when touch points exists
    Column {
        Repeater {
            model: multiArea.maximumTouchPoints

            Rectangle {
                width: multiArea.width
                height: multiArea.height / multiArea.maximumTouchPoints
                visible: multiArea.points.length > index
                onVisibleChanged: {
                    color = Qt.rgba(Math.random(),
                             Math.random(), Math.random(), 1);
                }
                opacity: 0.3
            }
        }
    }

    // Visual presentation of the touch points
    Repeater {
        id: touchBalls
        model: multiArea.points

        Item {
            x: modelData.x
            y: modelData.y

            Rectangle {
                anchors.centerIn: parent
                color: "white"
                opacity: 0.1
                width: 1000 * modelData.pressure
                height: width
                radius: width / 2
            }

            Rectangle {
                anchors.centerIn: parent
                color: "#20cc2c"
                opacity: modelData.pressure * 10
                width: 100
                height: width
                radius: width / 2
            }
        }
    }

    // Text presentation of the touch points
    Column {
        spacing: 10

        Repeater {
            model: multiArea.points
            Text {
                font.pointSize: 12
                color: "snow"
                text: "{ x: " + modelData.x + ", y: " + modelData.y +
                      ", pressure: " + modelData.pressure + " }"
            }
        }
    }

    // http://doc.qt.nokia.com/qt5/qml-qtquick2-multipointtoucharea.html
    MultiPointTouchArea {
        id: multiArea

        property variant points: []
        /*
        [
            {x: 300, y: 120, pressure: 0.6},
            {x: 200, y: 420, pressure: 0.9}
        ]
        */

        enabled: true
        anchors.fill: parent

        minimumTouchPoints: 1
        maximumTouchPoints: 5

        // Each of the event handlers have "touchPoints" available
        // http://doc.qt.nokia.com/qt5/qml-qtquick2-touchpoint.html
        onCanceled: {
            console.log("multiArea onCanceled.")
            points = touchPoints;
        }
        onGestureStarted: {
            console.log("multiArea onGestureStarted.")
            points = touchPoints;
        }
        onPressed: {
            console.log("multiArea onPressed.")
            points = touchPoints;
        }
        onReleased: {
            console.log("multiArea onReleased.")
            points = touchPoints;
        }
        onTouchUpdated: {
            console.log("multiArea onTouchUpdated.")
            points = touchPoints;
        }
        onUpdated: {
            console.log("multiArea onUpdated.")
            points = touchPoints;
        }
    }

}
