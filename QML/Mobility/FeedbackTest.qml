import QtQuick 1.0
import QtMobility.feedback 1.1

/**
 * Vibra...
 * http://apidocs.meego.com/1.0/qtmobility/qml-feedback-api.html
 */
Rectangle {
	width: 800
	height: 600

	HapticsEffect {
		id: rumbleEffect
		attackIntensity: 0.0
		attackTime: 250
		intensity: 1.0
		duration: 100
		fadeTime: 250
		fadeIntensity: 0.0
		running: true; // play a rumble when we crash the boat
	}
}
