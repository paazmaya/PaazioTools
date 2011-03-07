import QtQuick 1.0

/**
 * Column organises its child items to a column.
 * http://doc.qt.nokia.com/4.7/qml-column.html
 */
Rectangle {
	width: 800
	height: 600

	Column {
		spacing: 2
		Rectangle { color: "red"; width: 50; height: 50 }
		Rectangle { color: "green"; width: 20; height: 50 }
		Rectangle { color: "blue"; width: 50; height: 20 }
		move: Transition {
			NumberAnimation {
				properties: "y"
				easing.type: "OutBounce"
			}
		}
	}
}
