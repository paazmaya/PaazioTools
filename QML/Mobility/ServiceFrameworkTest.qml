import QtQuick 1.1
import QtMobility.serviceframework 1.1

/**
 * Random services...
 * http://doc.qt.nokia.com/qtmobility-1.1.0/qml-serviceframework.html
 */
Rectangle {
	width: 800
	height: 600

	Text {
		anchors.fill: parent
		anchors.margins: 20
		text: Location.Label
	}

	Service {
		id: myService
		interfaceName: "com.nokia.qt.examples.ExampleService"

		Component.onCompleted: {
			var obj = myService.serviceObject;
		}
	}
}
