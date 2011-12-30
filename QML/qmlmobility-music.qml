// qmlmobility-music.qml
import QtQuick 1.0
import QtMobility.gallery 1.1
import QtMultimediaKit 1.1

Rectangle {
    width: 320
    Height: 480
    property string nowPlaying: ""

    DocumentGalleryModel {
        id: allSongsModel
        properties: ["title", "artist", "url" ]
        sortProperties: ["title"]
        rootType: DocumentGallery.Audio
    }
    Audio {
        id: song
        source: nowPlaying
    }
    ListView {
        anchors.fill: parent
        model: allSongsModel
        delegate: songDelegate
    }
    Component {
        id: songDelegate
        Rectangle {
            width: ListView.view.width
            height: 60
            color: url == nowPlaying ?
                     (song.paused ? "orange" : "lightsteelblue") : "white"
            Column {
                width: parent.width
                spacing:  5
                Text {
                    text: title
                    font { bold: true; pixelSize: 24 }
                }
                Text {
                    text: artist
                    font.pixelSize: 18
                }
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (nowPlaying == url && !song.paused) song.pause()
                    else { nowPlaying = url; song.play() }
                }
            }
        }
    }
}
