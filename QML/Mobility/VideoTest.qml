import QtQuick 1.0
import QtMultimediaKit 1.1

/**
 * A test for the Video element available via multimedia
 * of the Mobility API.
 * http://doc.qt.nokia.com/qtmobility-1.1.0/qml-multimedia.html
 * http://apidocs.meego.com/qtmobility/qml-multimedia.html
 * http://doc.qt.nokia.com/qtmobility-1.1.0/qml-video.html
 */
Rectangle {
    id: main
    width: 800
    height: 600


    Video {
        id: video
        anchors.fill: parent
        source: "http://paazio.wippiespace.com/20101113/rkhsk-hki2010-11-13.jukka-paasonen.main1000.mp4"
        autoLoad: true

        MouseArea {
            anchors.fill: parent
            onClicked: {
                video.play()
            }
        }

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

    Rectangle {
        x: 10
        y: main.height - height - 10
        width: main.width - 20
        height: 20
        color: "darkgreen"
        radius: 10

        Rectangle {
            x: 2
            y: 2
            radius: parent.radius
            color: "green"
            width: (parent.width - 4)// * (video.position / video.duration)
            height: parent.height - 4
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                console.log("seekable: " + video.seekable)
                if (video.seekable) {
                    var pos = mouse.x / parent.width * video.duration;
                    video.position = pos;
                }
            }
        }
    }

    focus: true
    Keys.onSpacePressed: video.paused = !video.paused
    Keys.onLeftPressed: video.position -= 5000
    Keys.onRightPressed: video.position += 5000
}
