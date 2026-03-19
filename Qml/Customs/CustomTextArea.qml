import QtQuick 2.15
import QtQuick.Controls

Item {
    id: root

    property string placeholderStr: "Add any notes about this contact ..."
    property alias customText: notesField.text

    TextArea {
        id: notesField

        anchors.fill: parent

        placeholderText: root.placeholderStr
        font.pixelSize: 14
        color: "#111827"
        placeholderTextColor: "#9CA3AF"
        wrapMode: TextArea.Wrap
        leftPadding: 14
        rightPadding: 14
        topPadding: 12
        bottomPadding: 12

        background: Rectangle {
            color: notesField.activeFocus ? "#FFFFFF" : "#F9FAFB"
            border.color: notesField.activeFocus ? "#3B82F6" : "#E5E7EB"
            border.width: notesField.activeFocus ? 2 : 1
            radius: 10
        }
    }
}
