// Hyprlands SDDM — LoginForm.qml
// Layout: Clock → UserAvatar → Input → SystemButtons → SessionButton → VirtualKeyboardButton

import QtQuick 2.15
import QtQuick.Layouts 1.15
import SddmComponents 2.0 as SDDM

ColumnLayout {
    id: formContainer

    SDDM.TextConstants { id: textConstants }

    property int    p: config.ScreenPadding == "" ? 0 : config.ScreenPadding
    property string a: config.FormPosition

    // ── Clock ──────────────────────────────────────────────────────
    Clock {
        id: clock
        Layout.alignment:       Qt.AlignHCenter | Qt.AlignBottom
        Layout.preferredHeight: root.height / 3.2
        Layout.leftMargin: p != 0 ? (a == "left" ? -p : a == "right" ? p : 0) : 0
    }

    // ── User Avatar ────────────────────────────────────────────────
    UserAvatar {
        id: avatar
        Layout.alignment:    Qt.AlignHCenter
        Layout.topMargin:    root.font.pointSize * 1.5
        Layout.bottomMargin: root.font.pointSize * 0.5
        avatarSize:          root.height / 7
        Layout.leftMargin:   p != 0 ? (a == "left" ? -p : a == "right" ? p : 0) : 0
    }

    // ── Login fields ───────────────────────────────────────────────
    Input {
        id: input
        Layout.alignment:       Qt.AlignVCenter
        Layout.preferredHeight: root.height / 9
        Layout.leftMargin: p != 0 ? (a == "left" ? -p : a == "right" ? p : 0) : 0
        Layout.topMargin:  0
    }

    // ── Power / System buttons ─────────────────────────────────────
    SystemButtons {
        id: systemButtons
        Layout.alignment:      Qt.AlignHCenter | Qt.AlignBottom
        Layout.preferredHeight: root.height / 5
        Layout.maximumHeight:   root.height / 5
        Layout.leftMargin: p != 0 ? (a == "left" ? -p : a == "right" ? p : 0) : 0

        exposedSession: input.exposeSession
    }

    // ── WM / Session selector ──────────────────────────────────────
    SessionButton {
        id: sessionSelect
        Layout.alignment:      Qt.AlignHCenter | Qt.AlignBottom
        Layout.preferredHeight: root.height / 54
        Layout.maximumHeight:   root.height / 54
        Layout.leftMargin: p != 0 ? (a == "left" ? -p : a == "right" ? p : 0) : 0
    }

    // ── Virtual Keyboard toggle ────────────────────────────────────
    VirtualKeyboardButton {
        id: virtualKeyboardButton
        Layout.alignment:      Qt.AlignHCenter | Qt.AlignTop
        Layout.preferredHeight: root.height / 27
        Layout.maximumHeight:   root.height / 27
        Layout.leftMargin: p != 0 ? (a == "left" ? -p : a == "right" ? p : 0) : 0
    }
}
