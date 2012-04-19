import QtQuick 1.1
import Qt.labs.gestures 2.0

/**
 * Gestures provide the missing functionality
 * over MouseArea which are used in mobile devices.
 * http://doc.qt.nokia.com/4.7/qml-gesturearea.html
 */
Rectangle {
    id: main

	width: 800
	height: 480
    color: "darkgreen"

    function walkObject(obj) {
        for (var name in obj) {
            if (obj.hasOwnProperty(name)) {
                console.log("> " + name + " > " + obj[name]);
            }
        }
    }

    Rectangle {
        id: marker
        color: "pink"
        height: 20
        width: 20
        radius: 10
        opacity: 0

        Behavior on opacity {
            NumberAnimation {
                easing.type: Easing.InOutQuad
                duration: 200
            }
        }
    }

	GestureArea {
        id: gArea

        property real initX: 0
        property real initY: 0

		anchors.fill: parent

/*
        Default {
            onStarted: {
                console.log("Default onStarted");
            }
            onUpdated: {
                console.log("Default onUpdated");
            }
            onCanceled: {
                console.log("Default onCanceled");
            }
            onFinished: {
                console.log("Default onFinished");
            }

        }

        TapAndHold {
            onStarted: {
                console.log("TapAndHold onStarted");
            }
            onUpdated: {
                console.log("TapAndHold onUpdated");
            }
            onCanceled: {
                console.log("TapAndHold onCanceled");
            }
            onFinished: {
                console.log("TapAndHold onFinished");
            }

        }

        Pinch {
            onStarted: {
                console.log("Pinch onStarted");
            }
            onUpdated: {
                console.log("Pinch onUpdated");
            }
            onCanceled: {
                console.log("Pinch onCanceled");
            }
            onFinished: {
                console.log("Pinch onFinished");
            }

        }
        Swipe {
            onStarted: {
                console.log("Swipe onStarted");
                marker.opacity = 1;
            }
            onUpdated: {
                console.log("Swipe onUpdated");
                marker.x = gesture.hotSpot.x;
                marker.y = gesture.hotSpot.y;
                walkObject(gesture);
            }
            onCanceled: {
                console.log("Swipe onCanceled");
            }
            onFinished: {
                console.log("Swipe onFinished");
                marker.opacity = 0;
            }
        }*/
        Tap {
            onStarted: {
                console.log("Tap onStarted");
                walkObject(gesture);
                gArea.initX = gesture.position.x;
                gArea.initY = gesture.position.y;
                console.log("gArea.initX: " + gArea.initX);
                console.log("gArea.initY: " + gArea.initY);
            }
            onUpdated: {
                console.log("Tap onUpdated");
            }
            onCanceled: {
                console.log("Tap onCanceled");
            }
            onFinished: {
                console.log("Tap onFinished");
            }
        }

        Pan {
            onStarted: {
                console.log("Pan onStarted");
                marker.opacity = 1;
                console.log("x: " + gesture.lastOffset.x);
            }
            onUpdated: {
                console.log("Pan onUpdated");

                //marker.x = gesture.lastOffset.x;
                //marker.y = gesture.lastOffset.y;

                marker.x = gesture.lastOffset.x + gArea.initX;
                marker.y = gesture.lastOffset.y + gArea.initY;

            }
            onCanceled: {
                console.log("Pan onCanceled");
            }
            onFinished: {
                console.log("Pan onFinished");
                marker.opacity = 0;
            }
        }

	}

}


