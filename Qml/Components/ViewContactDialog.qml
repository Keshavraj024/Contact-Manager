import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import ContactManager 1.0

Dialog {
    id: root
    modal: true
    anchors.centerIn: Overlay.overlay
    width: 520
    height: Math.min(640, parent.height - 80)
    padding: 0

    property string contactFirstName: ""
    property string contactLastName: ""
    property string contactFullName: ""
    property string contactInitials: ""
    property string contactEmail: ""
    property string contactPhone: ""
    property string contactCompany: ""
    property string contactJobTitle: ""
    property string contactAddress: ""
    property string contactNotes: ""
    property bool contactIsFavorite: false
    property var contactTags: []
    property string contactAvatarColor: "#6366F1"
    property int contactIndex: -1

    signal editRequested(int index)

    function loadContact(index, data) {
        contactIndex = index
        contactFirstName = data.firstName || ""
        contactLastName = data.lastName || ""
        contactFullName = data.fullName || ""
        contactInitials = data.initials || ""
        contactEmail = data.email || ""
        contactPhone = data.phone || ""
        contactCompany = data.company || ""
        contactJobTitle = data.jobTitle || ""
        contactAddress = data.address || ""
        contactNotes = data.notes || ""
        contactIsFavorite = data.isFavorite || false
        contactTags = data.tags || []
        contactAvatarColor = data.avatarColor || "#6366F1"
    }

    background: Rectangle {
        color: "#FFFFFF"
        radius: 16
        border.color: "#E5E7EB"
        border.width: 1
    }

    header: Item {
        height: 140
        Rectangle {
            anchors.fill: parent
            color: "#FFFFFF"
            radius: 16
            Rectangle {
                anchors.bottom: parent.bottom
                width: parent.width
                height: 16
                color: "#FFFFFF"
            }

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 28
                anchors.rightMargin: 28
                anchors.topMargin: 2
                spacing: 16

                Rectangle {
                    Layout.preferredWidth: 72
                    Layout.preferredHeight: 72
                    radius: 36
                    color: root.contactAvatarColor
                    Text {
                        anchors.centerIn: parent
                        text: root.contactInitials
                        font.pixelSize: 28
                        font.weight: Font.DemiBold
                        color: "#FFFFFF"
                    }
                    Rectangle {
                        visible: root.contactIsFavorite

                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        anchors.rightMargin: -2
                        anchors.bottomMargin: -2

                        width: 24
                        height: 24
                        radius: 12

                        color: "#FEF3C7"
                        border.color: "#FFFFFF"
                        border.width: 2

                        Text {
                            anchors.centerIn: parent
                            text: "\u2605"
                            font.pixelSize: 14
                            color: "#F59E0B"
                        }
                    }
                }

                ColumnLayout {
                    spacing: 4
                    Text {
                        Layout.fillWidth: true
                        text: root.contactFullName
                        font.pixelSize: 22
                        font.weight: Font.Bold
                        color: "#111827"
                        elide: Text.ElideRight
                    }

                    Text {
                        visible: root.contactJobTitle !== "" || root.contactCompany !== ""
                        text: (root.contactJobTitle && root.contactCompany) ?
                                  root.contactJobTitle + " at " + root.contactCompany :
                                  (root.contactJobTitle || contactCompany)
                        font.pixelSize: 14
                        color: "#6B7280"
                    }
                }

                CustomButton {
                    buttonText: "✖"
                    onCustomButtonClicked: root.close()
                }
            }



        }
    }

    contentItem: Flickable {
        id: contentFlickable
        clip: true
        contentHeight: detailsColumn.height + 32
        boundsBehavior: Flickable.StopAtBounds
        ScrollBar.vertical: ScrollBar {
            policy: ScrollBar.AsNeeded
        }

        ColumnLayout {
            id: detailsColumn
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 28
            spacing: 20

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 12
                visible: root.contactEmail !== "" || root.contactPhone !== ""

                RowLayout {
                    spacing: 8
                    Rectangle {
                        Layout.preferredWidth: 28
                        Layout.preferredHeight: Layout.preferredWidth
                        radius: 6
                        color: "#EEF2FF"
                        Text {
                            anchors.centerIn: parent
                            text: "\uD83D\uDCDE"
                            font.pixelSize: 14
                        }
                    }
                    Text {
                        text: "Contact"
                        font.pixelSize: 14
                        font.weight: Font.DemiBold
                        color: "#111827"
                    }
                }

                RowLayout {
                    visible: root.contactEmail !== ""
                    Layout.fillWidth: true
                    spacing: 12
                    Rectangle {
                        Layout.preferredWidth: 40
                        Layout.preferredHeight: Layout.preferredWidth
                        radius: 8
                        color: "#F3F4F6"
                        Text {
                            anchors.centerIn: parent
                            text: "\u2709"
                            font.pixelSize: 18
                            color: "#6B7280"
                        }
                    }
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2
                        Text {
                            text: "Email"
                            font.pixelSize: 11
                            font.weight: Font.Medium
                            color: "#9CA3AF"
                        }
                        Text {
                            text: root.contactEmail
                            font.pixelSize: 14
                            color: "#3B82F6"
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }
                    }
                }

                RowLayout {
                    visible: root.contactPhone !== ""
                    Layout.fillWidth: true
                    spacing: 12
                    Rectangle {
                        Layout.preferredWidth: 40
                        Layout.preferredHeight: Layout.preferredWidth
                        radius: 8
                        color: "#F3F4F6"
                        Text {
                            anchors.centerIn: parent
                            text: "\uD83D\uDCF1"
                            font.pixelSize: 18
                            color: "#6B7280"
                        }
                    }
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2
                        Text {
                            text: "Phone"
                            font.pixelSize: 11
                            font.weight: Font.Medium
                            color: "#9CA3AF"
                        }
                        Text {
                            text: root.contactPhone
                            font.pixelSize: 14
                            color: "#111827"
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }
                    }
                }
            }

            Divider {
                Layout.fillWidth: true
                visible: (root.contactEmail !== "" || root.contactPhone !== "") &&
                         (root.contactCompany !== "" || root.contactJobTitle !== "")
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 12
                visible: root.contactCompany !== "" || root.contactJobTitle !== ""
                RowLayout {
                    spacing: 8
                    Rectangle {
                        Layout.preferredWidth: 28
                        Layout.preferredHeight: Layout.preferredWidth
                        radius: 6
                        color: "#FEF3C7"
                        Text {
                            anchors.centerIn: parent
                            text: "\uD83C\uDFE2"
                            font.pixelSize: 14
                        }
                    }
                    Text {
                        text: "Work"
                        font.pixelSize: 14
                        font.weight: Font.DemiBold
                        color: "#111827"
                    }
                }
                RowLayout {
                    visible: root.contactCompany !== ""
                    Layout.fillWidth: true
                    spacing: 12
                    Rectangle {
                        Layout.preferredWidth: 40
                        Layout.preferredHeight: Layout.preferredWidth
                        radius: 8
                        color: "#F3F4F6"
                        Text {
                            anchors.centerIn: parent
                            text: "\uD83D\uDCBC"
                            font.pixelSize: 18
                            color: "#6B7280"
                        }
                    }
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2
                        Text {
                            text: "Company"
                            font.pixelSize: 11
                            font.weight: Font.Medium
                            color: "#9CA3AF"
                        }
                        Text {
                            text: root.contactCompany
                            font.pixelSize: 14
                            color: "#111827"
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }
                    }
                }
                RowLayout {
                    visible: root.contactJobTitle !== ""
                    Layout.fillWidth: true
                    spacing: 12

                    Rectangle {
                        Layout.preferredWidth: 40
                        Layout.preferredHeight: Layout.preferredWidth
                        radius: 8
                        color: "#F3F4F6"
                        Text {
                            anchors.centerIn: parent
                            text: "\uD83D\uDCCB"
                            font.pixelSize: 18
                            color: "#6B7280"
                        }
                    }
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2
                        Text {
                            text: "Job Title"
                            font.pixelSize: 11
                            font.weight: Font.Medium
                            color: "#9CA3AF"
                        }
                        Text {
                            text: root.contactJobTitle
                            font.pixelSize: 14
                            color: "#111827"
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }
                    }
                }
            }

            Divider {
                Layout.fillWidth: true
                visible: (root.contactAddress !== "") &&
                         (root.contactCompany !== "" || root.contactJobTitle !== "")
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 12
                visible: root.contactAddress !== ""
                RowLayout {
                    spacing: 8
                    Rectangle {
                        Layout.preferredWidth: 28
                        Layout.preferredHeight: Layout.preferredWidth
                        radius: 6
                        color: "#DCFCE7"
                        Text {
                            anchors.centerIn: parent
                            text: "\uD83D\uDCCD"
                            font.pixelSize: 14
                        }
                    }
                    Text {
                        text: "Address"
                        font.pixelSize: 14
                        font.weight: Font.DemiBold
                        color: "#111827"
                    }
                }
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 1
                    Rectangle {
                        Layout.preferredWidth: 40
                        Layout.preferredHeight: Layout.preferredWidth
                        radius: 8
                        color: "#F3F4F6"
                        Text {
                            anchors.centerIn: parent
                            text: "\uD83C\uDFE0"
                            font.pixelSize: 18
                            color: "#6B7280"
                        }
                    }
                    Text {
                        text: root.contactAddress
                        font.pixelSize: 14
                        color: "#111827"
                        wrapMode: Text.WordWrap
                        Layout.fillWidth: true
                    }
                }
            }

            Divider {
                Layout.fillWidth: true
                visible: (root.contactAddress !== "") &&
                         (root.contactNotes !== "")
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 12
                visible: root.contactNotes !== ""
                RowLayout {
                    spacing: 8
                    Rectangle {
                        Layout.preferredWidth: 28
                        Layout.preferredHeight: Layout.preferredWidth
                        radius: 6
                        color: "#E0E7FF"
                        Text {
                            anchors.centerIn: parent
                            text: "\uD83D\uDCDD"
                            font.pixelSize: 14
                        }
                    }
                    Text {
                        text: "Notes"
                        font.pixelSize: 14
                        font.weight: Font.DemiBold
                        color: "#111827"
                    }
                }
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: notesText.height + 24
                    radius: 10
                    color: "#F9FAFB"
                    border.color: "#E5E7EB"
                    border.width: 1
                    Text {
                        id: notesText
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.margins: 12
                        text: root.contactNotes
                        font.pixelSize: 14
                        color: "#374151"
                        wrapMode: Text.WordWrap
                    }
                }


            }

            Divider {
                Layout.fillWidth: true
                visible: (root.contactTags.length > 0) &&
                         (root.contactNotes !== "")
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 12
                visible: root.contactTags.length > 0
                RowLayout {
                    spacing: 8
                    Rectangle {
                        width: 28
                        height: 28
                        radius: 6
                        color: "#FCE7F3"
                        Text {
                            anchors.centerIn: parent
                            text: "\uD83C\uDFF7\uFE0F"
                            font.pixelSize: 14
                        }
                    }
                    Text {
                        text: "Tags"
                        font.pixelSize: 14
                        font.weight: Font.DemiBold
                        color: "#111827"
                    }
                }
                Flow {
                    Layout.fillWidth: true
                    spacing: 8
                    Repeater {
                        model: root.contactTags
                        delegate: Rectangle {
                            width: tagLabel.width + 20
                            height: 30
                            radius: 15
                            color: "#EEF2FF"
                            Text {
                                id: tagLabel
                                anchors.centerIn: parent
                                text: modelData
                                font.pixelSize: 12
                                font.weight: Font.Medium
                                color: "#4F46E5"
                            }
                        }
                    }
                }
            }
        }
    }

    footer: Item {
        height: 72
        Rectangle {
            anchors.fill: parent
            color: "#FFFFFF"
            radius: 16
            Rectangle {
                anchors.top: parent.top
                width: parent.width
                height: 1
                color: "#E5E7EB"
            }
            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 28
                anchors.rightMargin: 28
                spacing: 12

                Item { Layout.fillWidth: true }

                CustomButton {
                    buttonText: "Close"
                    onCustomButtonClicked: root.close()
                }

                CustomButton {
                    buttonText: "\u270F Edit Contact"
                    onCustomButtonClicked: function() {
                        root.close()
                        root.editRequested(root.contactIndex)
                    }
                }
            }
        }
    }

}

