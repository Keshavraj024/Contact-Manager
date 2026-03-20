import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import ContactManager 1.0

Dialog {
    id: root

    modal: true
    anchors.centerIn: Overlay.overlay
    width: 420
    height: 400
    padding: 0

    property int contactIndex: -1
    property string contactName: ""
    property string contactInitials: ""
    property string contactAvatarColor: "#6366F1"

    signal deleteConfirmed(int index)

    function setContact(index, item) {
        contactIndex = index
        contactName = item.firstName + " " + item.lastName
        contactInitials = item.initials
        contactAvatarColor = item.avatarColor || "#6366F1"
    }

    background: Rectangle {
        color: "#FFFFFF"
        radius: 16
        border.color: "#E5E7EB"
        border.width: 1
    }

    header: Item {
        height: 100

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 12
            Rectangle {
                Layout.alignment: Qt.AlignHCenter
                width: 56
                height: 56
                radius: 28
                color: "#FEE2E2"
                Text {
                    anchors.centerIn: parent
                    text: "\u26A0"
                    font.pixelSize: 28
                }
            }
            Text {
                Layout.alignment: Qt.AlignHCenter
                text: "Delete Contact"
                font.pixelSize: 18
                font.weight: Font.Bold
                color: "#111827"
            }
        }
    }

    contentItem: Item {
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 24
            spacing: 16
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 56
                radius: 10
                color: "#F9FAFB"
                border.color: "#E5E7EB"
                border.width: 1

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    spacing: 12
                    Rectangle {
                        Layout.preferredWidth: 36
                        Layout.preferredHeight: 36
                        radius: 18
                        color: root.contactAvatarColor
                        Text {
                            anchors.centerIn: parent
                            text: root.contactInitials
                            font.pixelSize: 14
                            font.weight: Font.DemiBold
                            color: "#FFFFFF"
                        }
                    }

                    Text {
                        Layout.fillWidth: true
                        text: root.contactName
                        font.pixelSize: 15
                        font.weight: Font.Medium
                        color: "#111827"
                        elide: Text.ElideRight
                    }
                }
            }

            Text {
                Layout.fillWidth: true
                text: "Are you sure you want to delete this contact? This action cannot be undone."
                font.pixelSize: 14
                color: "#6B7280"
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
            }
            Item {
                Layout.fillHeight: true
            }
        }
    }

    footer: Item {
        height: 80

        Divider {
            Layout.fillWidth: true
        }

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 24
            anchors.rightMargin: 24
            spacing: 12
            Item { Layout.fillWidth: true }

            CustomButton {
                buttonText: "Cancel"

                onCustomButtonClicked: root.close()
            }

            CustomButton {
                buttonText: "Delete"
                onCustomButtonClicked: {
                    root.deleteConfirmed(root.contactIndex)
                    root.close()
                }
            }
        }
    }
}
