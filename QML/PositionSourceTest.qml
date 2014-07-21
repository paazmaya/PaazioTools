import QtQuick 2.2

import QtMobility.location 1.0

Rectangle {
	width: 800
	height: 600

	color: "olive"

	Text {
		id: title
		text: "Simple position test app"
		font {pointSize: 12; bold: true}
	}
	PositionSource {
		id: positionSource
		active: true
		updateInterval: 1000
	}
	Column {
		id: data
		anchors {top: title.bottom; left: title.left}
		Text {text: "<==== PositionSource ====>"}
		Text {text: "positioningMethod: "  + printableMethod(positionSource.positioningMethod)}
		Text {text: "nmeaSource: "         + positionSource.nmeaSource}
		Text {text: "updateInterval: "     + positionSource.updateInterval}
		Text {text: "active: "     + positionSource.active}
		Text {text: "<==== Position ====>"}
		Text {text: "latitude: "   + positionSource.position.latitude}
		Text {text: "longtitude: "   + positionSource.position.longtitude}
		Text {text: "altitude: "   + positionSource.position.altitude}
		Text {text: "speed: " + positionSource.position.speed}
		Text {text: "timestamp: "  + positionSource.position.timestamp}
		Text {text: "altitudeValid: "  + positionSource.position.altitudeValid}
		Text {text: "longtitudeValid: "  + positionSource.position.longtitudeValid}
		Text {text: "latitudeValid: "  + positionSource.position.latitudeValid}
		Text {text: "speedValid: "     + positionSource.position.speedValid}
	}
	function printableMethod(method) {
		if (method == PositionSource.SatellitePositioningMethod)
			return "Satellite";
		else if (method == PositionSource.NoPositioningMethod)
			return "Not available"
		else if (method == PositionSource.NonSatellitePositioningMethod)
			return "Non-satellite"
		else if (method == PositionSource.AllPositioningMethods)
			return "All/multiple"
		return "source error";
	}
}
