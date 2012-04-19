import QtQuick 1.1

/**
 * Column organises its child items to a column.
 * http://doc.qt.nokia.com/4.7/qml-column.html
 */
Rectangle {
	width: 800
	height: 600

	Column {
		spacing: 2
        Repeater {
            model: 6
            Rectangle {
                color: Qt.rgba(Math.random(), Math.random(), Math.random(), 1)
                width: 30 + Math.random() * 200
                height: 50
            }
        }
		move: Transition {
			NumberAnimation {
				properties: "y"
				easing.type: "OutBounce"
                duration: 600
			}
		}
	}
}
