import QtQuick 2.2

/**
 * Column organises its child items to a column.
 * http://qt-project.org/doc/qt-5/qml-qtquick-column.html
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
