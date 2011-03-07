import QtQuick 1.0
import QtMobility.sensors 1.1

/**
 * Location offers data based on GPS position.
 * http://doc.qt.nokia.com/qtmobility-1.1.0/qml-location.html
 */
Rectangle {
	width: 800
	height: 600

	Text {
		anchors.fill: parent
		anchors.margins: 20
        //text: Location.label + " (" + Location.longitude +
        //      ", " + Location.latitude + ")"
        text: loc.label + " (" + loc.longitude +
              ", " + loc.latitude + ")"
	}

	/**
	 * Location.Label
	 * Location.Longitude
	 * Location.Latitude
	 */

    Location {
        id: loc
    }

}
