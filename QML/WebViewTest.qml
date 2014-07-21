import QtQuick 2.2
import QtWebKit 1.0

/**
 * Web view is used as a browser window
 * http://qt-project.org/doc/qt-5/qml-qtquick-webview.html
 */
Rectangle {
	width: 840
	height: 600

	Flickable {
		anchors.fill: parent
		anchors.margins: 60
		contentHeight: webView.height
		contentWidth: webView.width

		WebView {
			id: webView
			anchors.fill: parent

            url: "http://qt-project.org/"
			smooth: true

			settings.pluginsEnabled: true
			settings.autoLoadImages: true
			settings.javascriptEnabled: true
			settings.javaEnabled: true

			onLoadFinished: {
				favicon.source = icon;
				address.text = title;
			}
			onLoadFailed: {
				console.log("Load failed. " + statusText);
			}
			onLoadStarted: {
				console.log("loading of " + url + " started..");
			}
		}
	}

	Rectangle {
		anchors.margins: 10
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.top: parent.top
		Image {
			id: favicon
			anchors.left: parent.left
		}
		Text {
			id: address
			anchors.left: favicon.right
			anchors.leftMargin: 10
			text: "Loading..."
		}
		Text {
			id: statusField
			anchors.left: address.right
			anchors.leftMargin: 10
			text: "Status: " + webView.statusText
		}
	}


}
