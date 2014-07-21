import QtQuick 2.2


Rectangle {
	width: 800
	height: 600

	Flow {
		spacing: 2
		flow: Flow.TopToBottom
		Repeater {
			model: ["one", "two", "three", "four"]
			delegate: Rectangle {
				color: "magenta"
				width: Math.random() * 50 + 25
				height: Math.random() * 50 + 25
				Text {
					text: index + " = " + modelData
				}
			}
		}

		move: Transition {
			NumberAnimation {
				properties: "y"
				easing.type: "OutBounce"
			}
		}
	}
}
