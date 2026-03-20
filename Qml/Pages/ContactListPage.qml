import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import ContactManager 1.0

Page {
    id: root

    property var proxyModel: []
    property int totalContacts: 0
    property int favoritesContacts: 0


    signal viewContact(int index, Item item)
    signal addContactRequested()
    signal deleteRequested(int index, Item item)
    signal editRequested(int index, Item item)

    background: Rectangle {
        color: "#F9FAFB"
    }

    header: ToolBar {
        height: 80

        background: Rectangle {
            color: "#FFFFFF"
            Rectangle {
                anchors.bottom: parent.bottom
                width: parent.width
                height: 1
                color: "#E5E7EB"
            }
        }
        RowLayout {
            anchors.fill: parent

            anchors.leftMargin: 24
            anchors.rightMargin: 24
            spacing: 16

            Text {
                text: "Contacts"
                font.pixelSize: 28
                font.weight: Font.Bold
                color: "#111827"
            }

            Item { Layout.fillWidth: true }

            Text {
                text: qsTr("%n contact(s)", "", root.proxyModel.count)
                font.pixelSize: 14
                color: "#6B7280"
            }


            Button {
                background: Rectangle {
                    color: parent.pressed ? "#2563EB" : parent.hovered ? "#3B82F6" :
                                                                         "#3B82F6"
                    radius: 10
                    Behavior on color {
                        ColorAnimation { duration: 150 }
                    }
                }
                contentItem: Text {
                    text: "+ Add"
                    font.pixelSize: 14
                    font.weight: Font.Medium
                    color: "#FFFFFF"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    leftPadding: 20
                    rightPadding: 20
                    topPadding: 10
                    bottomPadding: 10
                }
                onClicked: root.addContactRequested()
            }
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 24

        FilterPanel {
            id: filterPanel

            Layout.preferredWidth: 280
            Layout.fillHeight: true

            onFavoritesToggled: function(enabled) {
                root.proxyModel.favoritesOnly = enabled
            }
            onSortChanged: function(sortBy, ascending) {
                root.proxyModel.sortAscending = ascending
            }
            onTagToggled: function(selectedTags) {
                root.proxyModel.selectedTags = filterPanel.selectedTags
            }
        }

        ColumnLayout {
            spacing: 16
            // Search bar
            SearchBar {
                id: searchBar
                Layout.fillWidth: true
                onSearchTextChanged: function(text){
                    root.proxyModel.searchText = text
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "#FFFFFF"
                radius: 12

                ListView {
                    id: contactListView
                    anchors.fill: parent
                    anchors.margins: 2
                    clip: true
                    spacing: 0

                    visible: root.proxyModel.count > 0
                    model: root.proxyModel

                    Component {
                        id: sectionHeading
                        Rectangle {
                            width: sectionText.width + 10
                            height: sectionText.height + 2
                            x: 2

                            required property string section

                            Text {
                                id: sectionText
                                text: parent.section
                                font.bold: true
                                font.pixelSize: 20
                            }
                        }
                    }

                    delegate: ContactDelegate {

                        width: contactListView.width
                        height: 80

                        dataModel: model

                        onClicked: {
                            const modelData = contactListView.itemAtIndex(index)
                            root.viewContact(index, modelData)
                        }

                        onFavoriteToggled: function(isToggled){
                            model.isFavorite = isToggled
                        }

                        onDeleteRequested: function() {
                            const modelData = contactListView.itemAtIndex(index)
                            root.deleteRequested(index, modelData)
                        }

                        onEditRequested: function() {
                            const modelData = contactListView.itemAtIndex(index)
                            root.editRequested(index, modelData)
                        }

                    }

                    section.property: "firstName"
                    section.criteria: ViewSection.FirstCharacter
                    section.delegate: sectionHeading


                    ScrollBar.vertical: ScrollBar {
                        policy: ScrollBar.AsNeeded
                        background: Rectangle {
                            color: "transparent"
                        }
                        contentItem: Rectangle {
                            implicitWidth: 6
                            radius: 3
                            color: parent.pressed ? "#9CA3AF" : "#D1D5DB"
                            Behavior on color {
                                ColorAnimation { duration: 150 }
                            }
                        }
                    }

                }

                Item {
                    id: emptyState
                    anchors.centerIn: parent
                    visible: root.proxyModel.count === 0
                    width: 300
                    height: 200
                    ColumnLayout {
                        anchors.fill: parent
                        spacing: 16
                        Text {
                            text: "0"
                            font.pixelSize: 64
                            Layout.alignment: Qt.AlignHCenter
                        }
                        Text {
                            text: "No contacts"
                            font.pixelSize: 20
                            font.weight: Font.DemiBold
                            color: "#111827"
                            Layout.alignment: Qt.AlignHCenter
                        }
                        Text {
                            text: "Add your first contact to get started"
                            font.pixelSize: 14
                            color: "#6B7280"
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }
                }
            }
        }
    }

    footer: ToolBar {
        height: 36
        background: Rectangle {
            color: "#FFFFFF"
            Rectangle {
                anchors.top: parent.top
                width: parent.width
                height: 1
                color: "#E5E7EB"
            }
        }
        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 24
            anchors.rightMargin: 24
            spacing: 24

            Text {
                text: `Total Contacts : ${root.totalContacts}`
                font.pixelSize: 12
                font.weight: Font.DemiBold
                color: "#6B7280"
            }

            Divider {
                Layout.fillHeight: true
            }

            Text {
                text: `Favorite Contacts: ${root.favoritesContacts}`
                font.pixelSize: 12
                font.weight: Font.DemiBold
                color: "#6B7280"
            }
            Item { Layout.fillWidth: true }

            Text {
                text: "Contact Manager v1.0"
                font.pixelSize: 12
                color: "#9CA3AF"
            }
        }
    }

}
