// Hyprlands SDDM — VirtualKeyboardButton.qml
import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    implicitHeight: virtualKeyboardButton.implicitHeight
    implicitWidth: virtualKeyboardButton.implicitWidth

    Button {
        id: virtualKeyboardButton
        anchors.horizontalCenter: parent.horizontalCenter
        z: 1

        visible:   virtualKeyboard.status == Loader.Ready && config.HideVirtualKeyboard == "false"
        checkable: true
        onClicked: virtualKeyboard.switchState()

        Keys.onReturnPressed: { toggle(); virtualKeyboard.switchState() }
        Keys.onEnterPressed:  { toggle(); virtualKeyboard.switchState() }

        contentItem: Text {
            id: vkbText
            text: config.TranslateVirtualKeyboardButtonOff || "Virtual Keyboard (off)"
            font.pointSize: root.font.pointSize * 0.8
            font.family:    root.font.family
            color: parent.visualFocus ? config.HoverVirtualKeyboardButtonTextColor : config.VirtualKeyboardButtonTextColor
        }

        background: Rectangle { color: "transparent" }

        states: [
            State { name: "HoveredAndChecked"; when: virtualKeyboardButton.checked && virtualKeyboardButton.hovered; PropertyChanges { target: vkbText; text: config.TranslateVirtualKeyboardButtonOn || "Virtual Keyboard (on)";  color: config.HoverVirtualKeyboardButtonTextColor } },
            State { name: "checked";           when: virtualKeyboardButton.checked;                                   PropertyChanges { target: vkbText; text: config.TranslateVirtualKeyboardButtonOn || "Virtual Keyboard (on)" } },
            State { name: "hovered";           when: virtualKeyboardButton.hovered;                                   PropertyChanges { target: vkbText; text: config.TranslateVirtualKeyboardButtonOff || "Virtual Keyboard (off)"; color: config.HoverVirtualKeyboardButtonTextColor } }
        ]
    }
}
