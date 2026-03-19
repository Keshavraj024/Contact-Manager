import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import ContactManager 1.0

Rectangle {
    id: root

    property bool favoritesOnly: false
    property string sortBy: "name"
    property bool sortAscending: true
    property var selectedTags: []

    signal favoritesToggled(bool enabled)
    signal sortChanged(string sortBy, bool ascending)
    signal tagToggled(var selectedTags)

    color: "#FFFFFF"
    radius: 12

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 28
        // Filters Header
        Text {
            text: "Filters"
            font.pixelSize: 18
            font.weight: Font.Bold
            color: "#111827"
        }


        RowLayout {
            spacing: 12
            Layout.fillWidth: true
            Text {
                text: "★"
                font.pixelSize: 20
                color: "#FDB022"
            }
            Text {
                text: "Favorites Only"
                font.pixelSize: 14
                color: "#374151"
                Layout.fillWidth: true
            }
            Switch {
                id: favoritesSwitch

                // CHECK HOW THIS WORKS
                checked: root.favoritesOnly

                onToggled: {
                    // console.log("CHECKED ", checked)
                    root.favoritesOnly = checked
                    root.favoritesToggled(checked)
                }

                indicator: Rectangle {

                    implicitWidth: 44
                    implicitHeight: 24
                    anchors.verticalCenter: parent.verticalCenter

                    radius: 12
                    color: favoritesSwitch.checked ? "#3B82F6" : "#E5E7EB"

                    Rectangle {
                        x: favoritesSwitch.checked ? parent.width - width - 3 : 3
                        y: (parent.height - height) / 2

                        width: 18
                        height: width
                        radius: width / 2
                        color: "#FFFFFF"
                        Behavior on x {
                            NumberAnimation {
                                duration: 150
                                easing.type: Easing.OutCubic
                            }
                        }
                    }
                    Behavior on color {
                        ColorAnimation {
                            duration: 150
                        }
                    }
                }
            }
        }

        Divider {
            Layout.fillWidth: true
        }

        ColumnLayout {
            spacing: 12
            Layout.fillWidth: true

            Text {
                text: "Sort By"
                font.pixelSize: 16
                font.weight: Font.DemiBold
                color: "#111827"
            }

            Text {
                text: "Name"
                font.pixelSize: 13
                color: "#6B7280"
            }

            RowLayout {
                spacing: 8
                Layout.fillWidth: true

                Button {
                    // CHECK HEIGHT AND HOVER ENABLED, CHECKABLE
                    Layout.fillWidth: true
                    checked: root.sortBy === "name" && root.sortAscending
                    checkable: true

                    background: Rectangle {
                        color: parent.checked ? "#3B82F6" : "#F3F4F6"
                        radius: 8
                        border.width: parent.hovered && !parent.checked ? 1 : 0
                        border.color: "#D1D5DB"

                        Behavior on color {
                            ColorAnimation { duration: 150 }
                        }

                        Behavior on border.width {
                            ColorAnimation { duration: 150 }
                        }
                    }

                    contentItem: Text {
                        text: "↑ A-Z"
                        font.pixelSize: 13
                        font.weight: Font.Medium
                        color: parent.checked ? "#FFFFFF" : "#374151"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter

                        Behavior on color {
                            ColorAnimation { duration: 150 }
                        }
                    }

                    onClicked: {
                        root.sortBy = "name"
                        root.sortAscending = true
                        root.sortChanged("name", true)
                    }
                }

                Button {
                    Layout.fillWidth: true
                    checked: root.sortBy === "name" && !root.sortAscending
                    checkable: true

                    background: Rectangle {
                        color: parent.checked ? "#3B82F6" : "#F3F4F6"
                        radius: 8
                        border.width: parent.hovered && !parent.checked ? 1 : 0
                        border.color: "#D1D5DB"

                        Behavior on color {
                            ColorAnimation { duration: 150 }
                        }

                        Behavior on border.width {
                            ColorAnimation { duration: 150 }
                        }
                    }

                    contentItem: Text {

                        text: "↓ Z-A"
                        font.pixelSize: 13
                        font.weight: Font.Medium
                        color: parent.checked ? "#FFFFFF" : "#374151"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter

                        Behavior on color {
                            ColorAnimation { duration: 150 }
                        }
                    }

                    onClicked: {
                        root.sortBy = "name"
                        root.sortAscending = false
                        root.sortChanged("name", false)
                    }

                }
            }
        }

        Divider {
            Layout.fillWidth: true
        }

        ColumnLayout {
            spacing: 12
            Layout.fillWidth: true
            Text {
                text: "Filter by Tags"
                font.pixelSize: 16
                font.weight: Font.DemiBold
                color: "#111827"
            }

            Flow {
                Layout.fillWidth: true
                spacing: 8
                Repeater {
                    model: ["client", "alumni", "lead", "friends", "vendor",
                        "prospect", "partner", "work", "family", "colleague"]

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
                            root.tagToggled(selectedTags)
                        }
                    }

                }
            }

        }

        Item {
            Layout.fillHeight: true
        }
    }

}

