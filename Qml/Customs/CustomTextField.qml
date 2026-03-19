import QtQuick 2.15
import QtQuick.Controls

Item {
    id: root

    property string placeholderStr: "Custom Text"
    property alias customText: customTextField.text

    TextField {
        id: customTextField

        anchors.fill: parent

        placeholderText: root.placeholderStr
        font.pixelSize: 14
        color: "#111827"
        placeholderTextColor: "#9CA3AF"

        leftPadding: 14
        rightPadding: 14

        background: Rectangle {
            color: customTextField.activeFocus ? "#FFFFFF" : "#F9FAFB"
            border.color: customTextField.activeFocus ? "#3B82F6" : "#E5E7EB"
            border.width: customTextField.activeFocus ? 2 : 1
            radius: 10
        }
    }
}
