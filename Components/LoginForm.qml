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

    // Resolve alignment flags based on form position so content looks intentional
    property int contentAlignment: {
        if (a == "left")  return Qt.AlignLeft  | Qt.AlignBottom
        if (a == "right") return Qt.AlignRight | Qt.AlignBottom
        return Qt.AlignHCenter | Qt.AlignBottom
    }
    property int contentAlignH: {
        if (a == "left")  return Qt.AlignLeft
        if (a == "right") return Qt.AlignRight
        return Qt.AlignHCenter
    }

    // ── Clock ──────────────────────────────────────────────────────
    Clock {
        id: clock
        Layout.alignment:       Qt.AlignHCenter
        Layout.preferredHeight: root.height / 3.2
        Layout.fillWidth:       true
        Layout.leftMargin:      0
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
        Layout.alignment:       Qt.AlignHCenter | Qt.AlignBottom
        Layout.preferredHeight: root.height / 7
        Layout.maximumHeight:   root.height / 7
        Layout.leftMargin: 0

        exposedSession: input.exposeSession
    }

    // ── WM / Session selector ──────────────────────────────────────
    SessionButton {
        id: sessionSelect
        Layout.alignment:       Qt.AlignHCenter | Qt.AlignBottom
        Layout.preferredHeight: root.height / 30
        Layout.maximumHeight:   root.height / 30
        Layout.leftMargin: 0
    }

    // ── Virtual Keyboard toggle ────────────────────────────────────
    VirtualKeyboardButton {
        id: virtualKeyboardButton
        Layout.alignment:       Qt.AlignHCenter | Qt.AlignTop
        Layout.preferredHeight: root.height / 27
        Layout.maximumHeight:   root.height / 27
        Layout.leftMargin: 0
    }
}
