// Hyprlands SDDM — Clock.qml
// Enhanced clock with animated time, styled date label

import QtQuick 2.15
import QtQuick.Controls 2.15

Column {
    id: clock
    spacing: 4

    // Clock is stretched by the parent layout, so always center the text
    property int textAlign: Text.AlignHCenter

    // Optional header text from config
    Label {
        id: headerTextLabel
        width: parent.width
        horizontalAlignment: clock.textAlign
        font.pointSize: root.font.pointSize * 2.2
        color: config.HeaderTextColor
        renderType: Text.QtRendering
        text: config.HeaderText || ""
        visible: text !== ""
    }

    // Large animated time display
    Label {
        id: timeLabel
        width: parent.width
        horizontalAlignment: clock.textAlign
        font.pointSize: root.font.pointSize * 8.5
        font.bold: true
        color: config.TimeTextColor
        renderType: Text.QtRendering

        // Subtle entrance animation
        Behavior on text {
            SequentialAnimation {
                NumberAnimation { target: timeLabel; property: "opacity"; to: 0.6; duration: 80 }
                NumberAnimation { target: timeLabel; property: "opacity"; to: 1.0; duration: 80 }
            }
        }

        function updateTime() {
            text = new Date().toLocaleTimeString(
                Qt.locale(config.Locale),
                config.HourFormat === "long" ? Locale.LongFormat :
                config.HourFormat !== ""     ? config.HourFormat : Locale.ShortFormat
            )
        }
    }

    Label {
        id: dateLabel
        width: parent.width
        horizontalAlignment: clock.textAlign
        color: config.DateTextColor
        font.pointSize: root.font.pointSize * 1.8
        font.bold: true
        renderType: Text.QtRendering

        function updateTime() {
            text = new Date().toLocaleDateString(
                Qt.locale(config.Locale),
                config.DateFormat === "short" ? Locale.ShortFormat :
                config.DateFormat !== ""      ? config.DateFormat : Locale.LongFormat
            )
        }
    }

    Timer {
        interval: 1000
        repeat: true
        running: true
        onTriggered: { timeLabel.updateTime(); dateLabel.updateTime() }
    }

    Component.onCompleted: { timeLabel.updateTime(); dateLabel.updateTime() }
}
