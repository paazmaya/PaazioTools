import QtQuick 1.1

/**
 * GridView
 * http://doc.qt.nokia.com/4.7/qml-gridview.html
 */
Rectangle {
	width: 800
	height: 600

	ListModel {
		id: gridViewModel

		ListElement {
			paragraph: "Qt Quick provides a declarative framework for building highly dynamic, custom user interfaces from a rich set of QML elements. Qt Quick helps programmers and designers collaborate to build the fluid user interfaces that are becoming common in portable consumer devices, such as mobile phones, media players, set-top boxes and netbooks. Qt Quick consists of the QtDeclarative C++ module, QML, and the integration of both of these into the Qt Creator IDE. Using the QtDeclarative C++ module, you can load and interact with QML files from your Qt application."
		}
		ListElement {
			paragraph: "QML is an extension to JavaScript, that provides a mechanism to declaratively build an object tree of QML elements. QML improves the integration between JavaScript and Qt's existing QObject-based type system, adds support for automatic property bindings and provides network transparency at the language level."
		}
		ListElement {
			paragraph: "The QML elements are a sophisticated set of graphical and behavioral building blocks. These different elements are combined together in QML documents to build components ranging in complexity from simple buttons and sliders, to complete Internet-enabled applications like a photo browser for the popular Flickr photo-sharing site."
		}
		ListElement {
			paragraph: "Qt Quick builds on Qt's existing strengths. QML can be be used to incrementally extend an existing application or to build completely new applications. QML is fully extensible from C++ through the QtDeclarative Module."
		}
	}


	GridView {
		id: gridViewGrid
		anchors.fill: parent
		flickableDirection: Flickable.HorizontalAndVerticalFlick
		contentWidth: childrenRect.width
		contentHeight: childrenRect.height
		clip: true
		cellWidth: 300
		cellHeight: 200
		flow: GridView.LeftToRight

		model: gridViewModel
		delegate: gridViewDelegate

		highlight: gridViewHightlight
		highlightFollowsCurrentItem: false
	}

	Component {
		id: gridViewHightlight
		Rectangle {
			color: "blue"
			opacity: 0.5
			x: gridViewGrid.currentItem.x
			y: gridViewGrid.currentItem.y
			width: gridViewGrid.cellWidth;
			height: gridViewGrid.cellHeight
			/*
			Behavior on y {
				NumberAnimation {
					easing.type: "InOutQuad";
					duration: 300
				}
			}
			Behavior on x {
				NumberAnimation {
					easing.type: "InOutQuad";
					duration: 300
				}
			}
			*/
		}
	}

	Component {
		id: gridViewDelegate
		Rectangle {
			color: "darkred"
			width: gridViewGrid.cellWidth
			height: gridViewGrid.cellHeight
			Text {
				color: "white"
				text: paragraph;
				wrapMode: Text.WordWrap
				anchors.fill: parent
				anchors.margins: 10
				anchors.horizontalCenter: parent.horizontalCenter
			}
			MouseArea {
				anchors.fill: parent
				onClicked: {
				}
			}
		}
	}

}
