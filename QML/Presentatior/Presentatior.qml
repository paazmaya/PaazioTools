/**
 * Presentatior
 * A tool for presenting presentations.
 * Should be better than powerpoint.
 */

import QtQuick 2.2
//
import Qt.labs.particles 1.0

Rectangle {
    width: 800
    height: 480


    Text {
        anchors.centerIn: parent
        text: "Hello World"
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            Qt.quit();
        }
    }
}
