import QtQuick 1.0
import QtMobility.contacts 1.1

/**
 * Contacts
 * http://apidocs.meego.com/1.0/qtmobility/qml-contacts.html
 */
Rectangle {
	width: 800
	height: 600


	ContactModel {
		id: contactsModel

		sortOrders: [
		   SortOrder {
			  detail:ContactDetail.Organization
			  field:Organization.Name
			  direction:Qt.AscendingOrder
		   },
		   SortOrder {
			  detail:ContactDetail.Name
			  field:Name.FirstName
			  direction:Qt.AscendingOrder
		   }
		]
		filter: IntersectionFilter {
			DetailFilter {
				detail:ContactDetail.Address
				field: Address.Country
				value: "Australia"
			}
			UnionFilter {
				DetailRangeFilter {
					detail:ContactDetail.Birthday
					field:Birthday.Birthday
					min: '1970-01-01'
					max: '1984-12-31'
				}
				DetailFilter {
					detail:ContactDetail.Gender
					field:Gender.Gender
					value:Gender.Male
				}
			}
		}
	}

}
