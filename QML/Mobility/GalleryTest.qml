import QtQuick 1.1
import QtMobility.gallery 1.1

/**
 * Gallery stuff...
 * http://doc.qt.nokia.com/qtmobility-1.1.0/qml-gallery.html
 */
Rectangle {
	width: 800
	height: 600

	DocumentGalleryQueryModel {
		id: galleryModel
		gallery: DocumentGallery {}

		itemType: "Image"
		properties: ["thumbnailImage"]
		filter: GalleryWildcardFilter {
			property: "fileName";
			value: "*.jpg";
		}
	}

	Flickable {
		Repeater {
			model: galleryModel
		}
	}

}
