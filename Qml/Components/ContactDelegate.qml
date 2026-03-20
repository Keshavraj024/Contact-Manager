import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

SwipeDelegate {
    id: root

    property var dataModel : []
    property string firstName: dataModel?.firstName ?? ""
    property string lastName: dataModel?.lastName ?? ""
    property string email: dataModel?.email ?? ""
    property string initials: dataModel?.initials ?? ""
    property bool isFavorite: dataModel?.isFavorite ?? false
    property string avatarColor: dataModel?.avatarColor ?? "#6366F1"
    property var tags: dataModel?.tags ?? []

    signal favoriteToggled(bool isToggled)
    signal deleteRequested()
    signal editRequested()

    width: parent.width
    height: 80

    swipe.right: Button {
        id: deleteButton
        width: 80
        height: parent.height
        anchors.right: parent.right

        onClicked: {
            swipe.close()
            root.deleteRequested()
        }

        background: Rectangle {
            color: "transparent"
            Rectangle {
                anchors.centerIn: parent
                width: 60
                height: 60
                radius: 12
                color: deleteButton.pressed ? "#DC2626" : "#EF4444"
                Behavior on color {
                    ColorAnimation { duration: 100 }
                }
            }
        }
        contentItem: Item {
            Column {
                anchors.centerIn: parent
                spacing: 2
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "\uD83D\uDDD1"
                    font.pixelSize: 18
                }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Delete"
                    font.pixelSize: 10
                    font.weight: Font.Medium
                    color: "#FFFFFF"
                }
            }
        }
    }

    swipe.left: Button {
        id: editButton
        width: 80
        height: parent.height

        onClicked: {
            swipe.close()
            root.editRequested()
        }

        background: Rectangle {
            color: "transparent"
            Rectangle {
                anchors.centerIn: parent
                width: 60
                height: 60
                radius: 12
                color: editButton.pressed ? "#2563EB" : "#3B82F6"

                Behavior on color {
                    ColorAnimation { duration: 100 }
                }
            }
        }
        contentItem: Item {
            Column {
                anchors.centerIn: parent
                spacing: 2
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "\u270F"
                    font.pixelSize: 18
                }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Edit"
                    font.pixelSize: 10
                    font.weight: Font.Medium
                    color: "#FFFFFF"
                }
            }
        }
    }

    background: Rectangle {
        color: root.pressed ? "#E5E7EB" : root.hovered ? "#F3F4F6" : "#FFFFFF"
        Rectangle {
            anchors.bottom: parent.bottom
            width: parent.width
            height: 1
            color: "#E5E7EB"
        }
        Behavior on color {
            ColorAnimation { duration: 150 }
        }
    }

    contentItem: RowLayout {
        spacing: 16

        Rectangle {
            Layout.preferredWidth: 48
            Layout.preferredHeight: 48

            radius: 24
            color: root.avatarColor
            Text {
                anchors.centerIn: parent
                text: root.initials
                font.pixelSize: 18
                font.weight: Font.DemiBold
                color: "#FFFFFF"
            }
        }

        ColumnLayout {
            spacing: 4

            Text {
                text: root.firstName + " " + root.lastName
                font.pixelSize: 15
                font.weight: Font.Medium
                color: "#111827"
                elide: Text.ElideRight
                Layout.fillWidth: true
            }
            Text {
                text: root.email
                font.pixelSize: 13
                color: "#6B7280"
                elide: Text.ElideRight
                Layout.fillWidth: true
            }
        }

        Item {
            Layout.fillWidth: true
        }

        Button {
            id: favoriteButton

            Layout.preferredWidth: 24
            Layout.preferredHeight: 24

            hoverEnabled: true
            scale: hovered ? 1.15 : 1.0

            background : Item {}

            Behavior on scale {
                NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
            }

            contentItem: Text {
                text: root.isFavorite ? "★" : "☆"
                font.pixelSize: 24
                color: root.isFavorite ? "#FDB022" : "#D1D5DB"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                Behavior on color {
                    ColorAnimation { duration: 150 }
                }
            }

            MouseArea {
                id: mouse
                anchors.fill: favoriteButton
                cursorShape: Qt.PointingHandCursor
                onPressed:  function(mouse) {
                    mouse.accepted = false
                }
            }

            onClicked: {
                root.favoriteToggled(!root.isFavorite)
            }
        }

        Text {
            text: "›"
            rightPadding: 5
            font.pixelSize: 24
            color: "#D1D5DB"
        }

    }
}
