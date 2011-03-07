import QtQuick 1.0

/**
 * Flow arranges items...
 */
Rectangle {
	width: 800
	height: 600

	Flow {
		id: flow
        anchors.fill: parent
        flow: Flow.TopToBottom
		move: Transition {
			NumberAnimation {
				properties: "x,y"
                easing.type: Easing.InOutBounce
				easing.amplitude: 2.0
				easing.period: 1.5
			}
		}
		add: flow.move
	}

	focus: true
	Keys.onReleased: {
        if (event.key == Qt.Key_Space) {
            var item = Qt.createQmlObject('; Rectangle {}',
                flow, "item");
            item.color = Qt.rgba(Math.random(), Math.random(), Math.random(), 1);
            item.width = Math.random() * 80 + 20;
            item.height = Math.random() * 80 + 20;
		}
	}

}
