import QtQuick 2.2
import QtMobility.messaging 1.1

/**
 * Messaging gices the access to messages.
 * http://doc.qt.nokia.com/qtmobility-1.1.0/qml-messaging.html
 */
Rectangle {
    width: 800
    height: 600

    MessageModel {
        id: messageModel
        sortBy: MessageModel.Timestamp
        sortOrder: MessageModel.DescendingOrder
        filter: MessageIntersectionFilter {
            MessageFilter {
                type: MessageFilter.Size
                value: 1024
                comparator: MessageFilter.LessThan
            }
            MessageUnionFilter {
                MessageIntersectionFilter {
                    MessageFilter {
                        type: MessageFilter.Sender
                        value: "martin"
                        comparator: MessageFilter.Includes
                    }
                    MessageFilter {
                        negated: true
                        type: MessageFilter.Subject
                        value: "re:"
                        comparator: MessageFilter.Includes
                    }
                }
                MessageFilter {
                    type: MessageFilter.Sender
                    value: "don"
                    comparator: MessageFilter.Includes
                }
            }
        }


    }
}
