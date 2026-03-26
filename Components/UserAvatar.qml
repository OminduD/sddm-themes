// Hyprlands SDDM — UserAvatar.qml
// Circular user profile image with glowing border ring and pulse animation.
// Falls back to Assets/User.svg when no photo is found.

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.0
import SddmComponents 2.0 as SDDM

Item {
    id: avatarRoot

    // The avatar diameter — caller sets width/height equally
    property int avatarSize: root.height / 8

    width:  avatarSize
    height: avatarSize

    // Path read from userModel (index from Input's selectUser)
    property string avatarPath: {
        var path = userModel.data(userModel.index(userModel.lastIndex, 0), 0x0107 /*Qt::DecorationRole*/) || ""
        return path
    }

    // ── Animated glow ring ─────────────────────────────────────────
    Rectangle {
        id: glowRing
        anchors.centerIn: parent
        width:  avatarSize + 10
        height: avatarSize + 10
        radius: width / 2
        color: "transparent"
        border.color: config.AccentGlowColor || config.HighlightBackgroundColor
        border.width: 3
        opacity: 0.8

        SequentialAnimation on opacity {
            loops: Animation.Infinite
            NumberAnimation { to: 0.3; duration: 1800; easing.type: Easing.InOutSine }
            NumberAnimation { to: 0.9; duration: 1800; easing.type: Easing.InOutSine }
        }
    }

    // ── Circular clip container ────────────────────────────────────
    Rectangle {
        id: clip
        anchors.centerIn: parent
        width:  avatarSize
        height: avatarSize
        radius: avatarSize / 2
        color:  config.FormBackgroundColor || "#1a1a2e"
        clip:   true

        // User photo (loaded if path valid)
        Image {
            id: userPhoto
            anchors.fill: parent
            source: avatarRoot.avatarPath !== "" ? ("file://" + avatarRoot.avatarPath) : ""
            fillMode: Image.PreserveAspectCrop
            visible: status === Image.Ready
            smooth: true
            mipmap: true
        }

        // Fallback SVG icon
        Image {
            id: fallbackIcon
            anchors.centerIn: parent
            width:  parent.width  * 0.55
            height: parent.height * 0.55
            source: Qt.resolvedUrl("../Assets/User.svg")
            visible: userPhoto.status !== Image.Ready
            smooth: true

            // Tint via ColorOverlay (Qt Quick Effects)
            layer.enabled: true
            layer.effect: ColorOverlay {
                color: config.UserIconColor || "#ffffff"
            }
        }
    }

    // ── Username label below avatar ────────────────────────────────
    Label {
        id: usernameLabel
        anchors.top:              clip.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin:        8

        text: userModel.data(userModel.index(userModel.lastIndex, 0), 0) || ""
        color: config.HeaderTextColor || "#ffffff"
        font.pointSize: root.font.pointSize * 1.1
        font.bold: true
        font.family: root.font.family
        renderType: Text.QtRendering
    }
}
