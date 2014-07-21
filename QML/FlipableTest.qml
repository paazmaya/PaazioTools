import QtQuick 2.2

/**
 * Demonstrates the use of the Flipable display item.
 * http://qt-project.org/doc/qt-5/qml-qtquick-flipable.html
 */
Rectangle {
	width: 800
	height: 600



	Flipable {
		id: flip
		front: flipFront
		back: flipBack
		anchors.fill: parent

		property int angle: 0
		property bool flipped: false

		transform: Rotation {
			origin.x: flip.width / 2
			origin.y: flip.height / 2
			axis.x: 1
			axis.y: 0
			axis.z: 0
			angle: flip.angle
		}

		states: State {
			name: "back"
			PropertyChanges {
				target: flip
				angle: 180
			}
			when: flip.flipped
		}

		transitions: Transition {
			NumberAnimation {
				properties: "angle"
				duration: 1000
				easing.type: Easing.InOutCubic
			}
		}

		MouseArea {
			anchors.fill: parent
			onClicked: flip.flipped = !flip.flipped
		}
	}

	Rectangle {
		id: flipFront
		anchors.fill: parent
		anchors.margins: 20
		radius:  10
		gradient: Gradient {
			GradientStop { position: 0.0; color: "red" }
			GradientStop { position: 0.4; color: "yellow" }
			GradientStop { position: 1.0; color: "green" }
		}
		Text {
			anchors.centerIn: parent
			text: "FRONT"
			font.pointSize: 44
		}
	}

	Rectangle {
		id: flipBack
		anchors.fill: parent
		anchors.margins: 20
		radius: 10
		gradient: Gradient {
			GradientStop { position: 0.0; color: "blue" }
			GradientStop { position: 0.4; color: "orange" }
			GradientStop { position: 1.0; color: "grey" }
		}
		Text {
			anchors.centerIn: parent
			text: "BACK"
			font.pointSize: 44
		}
	}

}
