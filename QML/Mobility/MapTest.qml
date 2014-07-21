import QtQuick 2.2
import QtMobility.location 1.1

/**
 * Map with a simple interaction to change its center
 * http://apidocs.meego.com/git-tip/qtmobility/qml-map.html
 */
Rectangle {
    width: 800
    height: 600

    Map {
        id: mapArea
        anchors.fill: parent

        // http://en.wikipedia.org/wiki/Ut%C3%B6,_Finland
        center.latitude: 59.783333
        center.longitude: 21.366667

        connectivityMode: Map.OnlineMode
        mapType: Map.TerrainMap
        size.width: parent.width
        size.height: parent.height
        zoomLevel: 14

        // No idea where to find a list of possible plugins...
        plugin : Plugin {
            name : "nokia"
        }

        MapCircle {
            border.color: "pink"
            border.width: 2
            center: mapArea.center
            radius: 1000 // 1 km
        }
    }

    // Change map center to where it was clicked
    MouseArea {
        anchors.fill: parent
        onClicked: {
            var pos = mapArea.toCoordinate(
                    Qt.point(mouse.x, mouse.y));
            console.log("alt: " + pos.altitude +
                        ", lat: " + pos.latitude +
                        ", lng: " + pos.longitude);
            mapArea.center = pos;
        }
    }
}
