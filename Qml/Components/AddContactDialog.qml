import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import ContactManager 1.0

Dialog {
    id: root
    modal: true
    anchors.centerIn: Overlay.overlay
    width: 560
    height: Math.min(720, parent.height - 80)
    padding: 0

    readonly property var availableTags: ["client", "alumni", "lead", "friends",
        "vendor", "prospect", "partner", "work", "family", "colleague"]

    property list<string> selectedTags: []


    signal contactAdded(string firstName, string lastName, string email,
                        string phone, string company, string jobTitle, string address,
                        string notes, bool isFavorite, var tags)

    onOpened: {
        firstNameField.customText = ""
        lastNameField.customText = ""
        emailField.customText = ""
        phoneField.customText = ""
        companyField.customText = ""
        jobTitleField.customText = ""
        addressField.customText = ""
        notesField.customText = ""
        favoriteSwitch.checked = false
        selectedTags = []
        firstNameField.forceActiveFocus()
    }

    onAccepted: {
        if (firstNameField.customText.trim() !== "" || lastNameField.customText.trim() !== "") {
            root.contactAdded(
                        firstNameField.customText.trim(),
                        lastNameField.customText.trim(),
                        emailField.customText.trim(),
                        phoneField.customText.trim(),
                        companyField.customText.trim(),
                        jobTitleField.customText.trim(),
                        addressField.customText.trim(),
                        notesField.customText.trim(),
                        favoriteSwitch.checked,
                        selectedTags
                        )
        }
    }


    background: Rectangle {
        color: "#FFFFFF"
        radius: 16
        border.color: "#E5E7EB"
        border.width: 1
    }


    header: Item {
        height: 72
        Rectangle {
            anchors.fill: parent
            color: "#FFFFFF"
            radius: 16
            // CHECK DO WE NEED THIS

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 28
                anchors.rightMargin: 28
                Column {
                    spacing: 4
                    Text {
                        text: "Add New Contact"
                        font.pixelSize: 20
                        font.weight: Font.Bold
                        color: "#111827"
                    }
                    Text {
                        text: "Fill in the details below"
                        font.pixelSize: 13
                        color: "#6B7280"
                    }
                }

                Item { Layout.fillWidth: true }

                CustomButton {
                    id: closeButon

                    buttonText: "✕"

                    onCustomButtonClicked: root.close()
                }
            }

            Rectangle {
                anchors.bottom: parent.bottom
                width: parent.width
                height: 4
                color: "red "
            }
        }


    }

    contentItem: Flickable {
        id: contentFlickable
        clip: true
        contentHeight: formColumn.implicitHeight + 32
        boundsBehavior: Flickable.StopAtBounds

        ScrollBar.vertical: ScrollBar {
            policy: ScrollBar.AsNeeded
            background: Rectangle {
                color: "transparent"
            }
            contentItem: Rectangle {
                implicitWidth: 6
                radius: 3
                color: parent.pressed ? "#9CA3AF" : "#D1D5DB"
            }
        }

        ColumnLayout {
            id: formColumn

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 28

            spacing: 24

            RowLayout {
                spacing: 8
                Rectangle {
                    width: 32
                    height: 32
                    radius: 8
                    color: "#EEF2FF"
                    Text {
                        anchors.centerIn: parent
                        text: "👤"
                        font.pixelSize: 16
                    }
                }
                Text {
                    text: "Personal Information"
                    font.pixelSize: 15
                    font.weight: Font.DemiBold
                    color: "#111827"
                }
            }

            RowLayout {
                spacing: 16
                Layout.fillWidth: true
                Layout.preferredHeight: 60
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 6
                    Text {
                        text: "First Name"
                        font.pixelSize: 13
                        font.weight: Font.Medium
                        color: "#374151"
                    }

                    CustomTextField {
                        id: firstNameField

                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        placeholderStr: "Abdul"
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 6
                    Text {
                        text: "Last Name"
                        font.pixelSize: 13
                        font.weight: Font.Medium
                        color: "#374151"
                    }
                    CustomTextField {
                        id: lastNameField

                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        placeholderStr: "Kalam"
                    }
                }
            }

            RowLayout {
                spacing: 16
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.preferredWidth: 2
                    Layout.preferredHeight: 60
                    spacing: 6
                    Text {
                        text: "Email"
                        font.pixelSize: 13
                        font.weight: Font.Medium
                        color: "#374151"
                    }

                    CustomTextField {
                        id: emailField

                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        placeholderStr: "john.doe@gmail.com"
                    }

                }

                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.preferredWidth: 1
                    Layout.preferredHeight: 60
                    spacing: 6
                    Text {
                        text: "Phone"
                        font.pixelSize: 13
                        font.weight: Font.Medium
                        color: "#374151"
                    }
                    CustomTextField {
                        id: phoneField

                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        placeholderStr: "+49-123456789"
                    }
                }
            }

            Divider {
                Layout.fillWidth: true
            }

            RowLayout {
                spacing: 8
                Rectangle {
                    width: 32
                    height: 32
                    radius: 8
                    color: "#FEF3C7"
                    Text {
                        anchors.centerIn: parent
                        text: "💼"
                        font.pixelSize: 16
                    }
                }
                Text {
                    text: "Work Information"
                    font.pixelSize: 15
                    font.weight: Font.DemiBold
                    color: "#111827"
                }
            }

            RowLayout {
                spacing: 16
                ColumnLayout {
                    spacing: 6
                    Text {
                        text: "Company"
                        font.pixelSize: 13
                        font.weight: Font.Medium
                        color: "#374151"
                    }
                    CustomTextField {
                        id: companyField
                        Layout.fillWidth: true
                        Layout.preferredHeight: 44
                        placeholderStr: "Acme Inc."
                    }
                }

                ColumnLayout {
                    spacing: 6
                    Text {
                        text: "Job Title"
                        font.pixelSize: 13
                        font.weight: Font.Medium
                        color: "#374151"
                    }
                    CustomTextField {
                        id: jobTitleField
                        Layout.fillWidth: true
                        Layout.preferredHeight: 44
                        placeholderStr: "QML Engineer"
                    }
                }
            }

            Divider {
                Layout.fillWidth: true
            }

            ColumnLayout {
                spacing: 16
                RowLayout {
                    spacing: 8
                    Rectangle {
                        width: 32
                        height: 32
                        radius: 8
                        color: "#DCFCE7"
                        Text {
                            anchors.centerIn: parent
                            text: "📍"
                            font.pixelSize: 16
                        }
                    }
                    Text {
                        text: "Address"
                        font.pixelSize: 15
                        font.weight: Font.DemiBold
                        color: "#111827"
                    }
                }

                CustomTextField {
                    id: addressField

                    Layout.fillWidth: true
                    Layout.preferredHeight: 44

                    placeholderStr: "🏠 123 Main St, City, Country"

                }
            }

            Divider {
                Layout.fillWidth: true
            }

            ColumnLayout {
                spacing: 16
                RowLayout {
                    spacing: 8
                    Rectangle {
                        width: 32
                        height: 32
                        radius: 8
                        color: "#E0E7FF"
                        Text {
                            anchors.centerIn: parent
                            text: "📝"
                            font.pixelSize: 16
                        }
                    }
                    Text {
                        text: "Notes"
                        font.pixelSize: 15
                        font.weight: Font.DemiBold
                        color: "#111827"
                    }
                }

                CustomTextArea {
                    id: notesField
                    Layout.fillWidth: true
                    Layout.preferredHeight: 88
                }

            }

            Divider {
                Layout.fillWidth: true
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 56
                radius: 12
                color: favoriteSwitch.checked ? "#FEF9C3" : "#F9FAFB"
                border.color: favoriteSwitch.checked ? "#FDE047" : "#E5E7EB"
                border.width: 1
                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 16
                    anchors.rightMargin: 16
                    spacing: 12

                    Text {
                        text: "★"
                        font.pixelSize: 22
                        color: favoriteSwitch.checked ? "#F59E0B" : "#D1D5DB"
                    }

                    ColumnLayout {
                        spacing: 2
                        Text {
                            text: "Mark as Favorite"
                            font.pixelSize: 14
                            font.weight: Font.Medium
                            color: "#111827"
                        }
                        Text {
                            text: "Favorite contacts appear at the top"
                            font.pixelSize: 12
                            color: "#6B7280"
                        }
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    Switch {
                        id: favoriteSwitch

                        indicator: Rectangle {
                            implicitWidth: 48
                            implicitHeight: 26
                            anchors.verticalCenter: parent.verticalCenter
                            radius: 13
                            color: favoriteSwitch.checked ? "#F59E0B" : "#E5E7EB"

                            Behavior on color { ColorAnimation { duration: 200 }}

                            Rectangle {
                                x: favoriteSwitch.checked ? parent.width - width - 3 : 3
                                anchors.verticalCenter: parent.verticalCenter
                                width: 20
                                height: 20
                                radius: 10
                                color: "#FFFFFF"
                                Behavior on x { NumberAnimation { duration: 200; easing.type: Easing.OutCubic }}
                            }
                        }
                    }
                }
            }

            Divider {
                Layout.fillWidth: true
            }

            ColumnLayout {

                spacing: 16
                RowLayout {
                    spacing: 8
                    Rectangle {
                        width: 32
                        height: 32
                        radius: 8
                        color: "#FCE7F3"
                        Text {
                            anchors.centerIn: parent
                            text: "🏷"
                            font.pixelSize: 16
                        }
                    }
                    Text {
                        text: "Tags"
                        font.pixelSize: 15
                        font.weight: Font.DemiBold
                        color: "#111827"
                    }
                    Text {
                        text: "(optional)"
                        font.pixelSize: 13
                        color: "#9CA3AF"
                    }
                }

                Flow {
                    spacing: 10
                    Layout.fillWidth: true
                    Repeater {
                        model: root.availableTags

                        delegate: Button {
                            // CHECK WIDTH, HEIGHT BUTTON
                            id: tagButton

                            property bool isSelected: root.selectedTags.indexOf(modelData) >=
                                                      0

                            background: Rectangle {
                                color: tagButton.isSelected ? "#DBEAFE" : "#F3F4F6"
                                radius: 16
                                border.width: tagButton.isSelected ? 2 : 0
                                border.color: "#3B82F6"
                                Behavior on color {
                                    ColorAnimation { duration: 150 }
                                }
                            }

                            contentItem: Text {
                                text: modelData
                                font.pixelSize: 12
                                font.weight: tagButton.isSelected ? Font.Medium : Font.Normal
                                color: tagButton.isSelected ? "#1E40AF" : "#6B7280"

                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter

                                leftPadding: 12
                                rightPadding: 12
                                topPadding: 6
                                bottomPadding: 6

                                Behavior on color {
                                    ColorAnimation { duration: 150 }
                                }
                            }

                            onClicked: {
                                // Copy the array
                                let tags = root.selectedTags.slice()
                                const index = tags.indexOf(modelData)

                                index === -1 ? tags.push(modelData) : tags.splice(index, 1)
                                root.selectedTags = tags
                            }
                        }

                    }


                }

            }
        }

    }


    footer: Item {
        height: 80
        Rectangle {
            anchors.fill: parent
            color: "#FFFFFF"
            radius: 16
            // Cover top corners
            Rectangle {
                anchors.top: parent.top
                width: parent.width
                height: 16
                color: "#FFFFFF"
            }
            // Top border
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

                Text {
                    text: "* First or Last name required"
                    font.pixelSize: 12
                    font.bold: true
                    color: "#9CA3AF"
                }

                Item { Layout.fillWidth: true }

                CustomButton {

                    buttonText: "Cancel"
                    rectColor: "#2563EB"
                    textColor: "#FFFFFF"

                    onCustomButtonClicked: root.close()
                }

                CustomButton {
                    buttonText: "Add Contact"
                    rectColor: "#2563EB"
                    textColor: "#FFFFFF"

                    onCustomButtonClicked: root.accept()
                }
            }


        }
    }
}


