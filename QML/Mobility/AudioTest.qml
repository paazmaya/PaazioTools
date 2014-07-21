import QtQuick 2.2
import QtMultimediaKit 1.1

/**
 * A test for the Audio element available via multimedia
 * of the Mobility API.
 * http://apidocs.meego.com/qtmobility/qml-multimedia.html
 * http://doc.qt.nokia.com/qtmobility-1.1.0/qml-multimedia.html
 */
Rectangle {
	width: 800
	height: 600

	Text {
		text: "Play song"
		font.pointSize: 24
		color: "black"
		width: 150
		height: 50

		MouseArea {
			id: playArea
			anchors.fill: parent
			onPressed: {
				audio.play()
			}
		}
	}

	Audio {
		id: audio
		source: "../../AS3/assets/aiueo.mp3"

        //onBuffered: {}
        //onBuffering: {}
        //onEndOfMedia: {}
        onError: {
            console.log("error")
        }
        //onLoaded: {}
        onPaused: {
            console.log("paused")
        }
        onResumed: {
            console.log("resumed")
        }
        //onStalled: {}
        onStarted: {
            console.log("started")
        }
        onStopped: {
            console.log("stopped")
        }

	}
}
