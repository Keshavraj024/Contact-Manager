import QtQuick 2.15
import QtQuick.Controls

Item {
    id: root

    property string buttonText: "Custom Button"
    property color rectColor: "#F3F4F6"
    property color textColor: "#6B7280"

    signal customButtonClicked

    width: buttonTextId.implicitWidth + 30
    height: buttonTextId.implicitHeight + 20

    Button{
        id: customButton

        anchors.fill: parent

        background: Rectangle {
            radius: customButton.width * 0.25

            color: customButton.hovered ?  root.rectColor : Qt.lighter(root.rectColor, 1.2)
            border.color: customButton.hovered ? "#F3F4F6" : "transparent"
            border.width: customButton.hovered ? 1 : 0
        }

        contentItem: Text {
            id: buttonTextId
            text: root.buttonText
            font.pixelSize: 16
            font.bold: customButton.hovered ? true : false
            color: root.textColor
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        onClicked: root.customButtonClicked()
    }

}
