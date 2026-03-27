// Hyprlands SDDM Video Theme — Main.qml
// Based on sddm-astronaut-theme by Keyitdev (GPLv3+)
// Enhanced with user avatar, particle shimmer, glassmorphism panel

import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects 1.0
import QtMultimedia
import SddmComponents 2.0 as SDDM
import "Components"

Pane {
    id: root

    height: config.ScreenHeight || Screen.height
    width:  config.ScreenWidth  || Screen.width
    padding: config.ScreenPadding || 0

    LayoutMirroring.enabled: config.RightToLeftLayout == "true" ? true : Qt.application.layoutDirection === Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    palette.window:          config.BackgroundColor
    palette.highlight:       config.HighlightBackgroundColor
    palette.highlightedText: config.HighlightTextColor
    palette.buttonText:      config.HoverSystemButtonsIconsColor

    FontLoader {
        id: localFont
        source: typeof config.FontFile !== "undefined" && config.FontFile !== "" ? "Fonts/" + config.FontFile : ""
    }

    font.family:    localFont.status === FontLoader.Ready ? localFont.name : config.Font
    font.pointSize: config.FontSize !== "" ? config.FontSize : parseInt(height / 80) || 13

    focus: true

    // ── Position helpers ───────────────────────────────────────────
    property bool leftleft:    config.HaveFormBackground == "true" && config.PartialBlur == "false" && config.FormPosition == "left"  && config.BackgroundHorizontalAlignment == "left"
    property bool leftcenter:  config.HaveFormBackground == "true" && config.PartialBlur == "false" && config.FormPosition == "left"  && config.BackgroundHorizontalAlignment == "center"
    property bool rightright:  config.HaveFormBackground == "true" && config.PartialBlur == "false" && config.FormPosition == "right" && config.BackgroundHorizontalAlignment == "right"
    property bool rightcenter: config.HaveFormBackground == "true" && config.PartialBlur == "false" && config.FormPosition == "right" && config.BackgroundHorizontalAlignment == "center"

    Item {
        id: sizeHelper
        anchors.fill: parent

        // ── VIDEO BACKGROUND ────────────────────────────────────────
        AnimatedImage {
            id: backgroundImage

            MediaPlayer {
                id: player
                videoOutput: videoOutput
                autoPlay: true
                playbackRate: config.BackgroundSpeed == "" ? 1.0 : config.BackgroundSpeed
                loops: MediaPlayer.Infinite
                onPlayingChanged: backgroundPlaceholderImage.visible = false
            }

            VideoOutput {
                id: videoOutput
                fillMode: config.CropBackground == "true" ? VideoOutput.PreserveAspectCrop : VideoOutput.PreserveAspectFit
                anchors.fill: parent
            }

            height: parent.height
            width:  config.HaveFormBackground == "true" && config.FormPosition != "center" && config.PartialBlur != "true"
                    ? parent.width - formBackground.width : parent.width
            anchors.left:  leftleft  || leftcenter  ? formBackground.right : undefined
            anchors.right: rightright || rightcenter ? formBackground.left  : undefined

            horizontalAlignment: config.BackgroundHorizontalAlignment == "left"  ? Image.AlignLeft  :
                                 config.BackgroundHorizontalAlignment == "right" ? Image.AlignRight : Image.AlignHCenter
            verticalAlignment:   config.BackgroundVerticalAlignment   == "top"   ? Image.AlignTop   :
                                 config.BackgroundVerticalAlignment   == "bottom"? Image.AlignBottom: Image.AlignVCenter

            speed:    config.BackgroundSpeed == "" ? 1.0 : config.BackgroundSpeed
            paused:   config.PauseBackground == "true" ? true : false
            fillMode: config.CropBackground  == "true" ? Image.PreserveAspectCrop : Image.PreserveAspectFit
            asynchronous: true
            cache: false
            clip:  true
            mipmap: true

            Component.onCompleted: {
                var ext = config.Background.substring(config.Background.lastIndexOf(".") + 1).toLowerCase()
                const videoExts = ["mp4", "avi", "mov", "mkv", "m4v", "webm"]
                if (videoExts.includes(ext)) {
                    backgroundPlaceholderImage.visible = true
                    player.source = Qt.resolvedUrl(config.Background)
                    player.play()
                } else {
                    backgroundImage.source = config.Background
                }
            }
        }

        // Placeholder shown while video loads
        Image {
            id: backgroundPlaceholderImage
            z: 0
            anchors.fill: backgroundImage
            source: config.BackgroundPlaceholder || ""
            fillMode: Image.PreserveAspectCrop
            visible: false
        }

        // ── DIM / TINT LAYER ───────────────────────────────────────
        Rectangle {
            id: tintLayer
            anchors.fill: parent
            z: 1
            color:   config.DimBackgroundColor
            opacity: config.DimBackground || 0
        }

        // ── PARTICLE SHIMMER CANVAS ────────────────────────────────
        Canvas {
            id: particleCanvas
            anchors.fill: parent
            z: 2
            opacity: 0.35

            property var particles: []
            property int particleCount: 60

            Component.onCompleted: {
                for (var i = 0; i < particleCount; i++) {
                    particles.push({
                        x: Math.random() * width,
                        y: Math.random() * height,
                        r: Math.random() * 2.5 + 0.5,
                        vx: (Math.random() - 0.5) * 0.4,
                        vy: -Math.random() * 0.6 - 0.2,
                        alpha: Math.random()
                    })
                }
            }

            Timer {
                interval: 33
                repeat: true
                running: true
                onTriggered: particleCanvas.requestPaint()
            }

            onPaint: {
                var ctx = getContext("2d")
                ctx.clearRect(0, 0, width, height)
                var color = config.AccentParticleColor || "#ffffff"
                for (var i = 0; i < particles.length; i++) {
                    var p = particles[i]
                    p.x += p.vx; p.y += p.vy; p.alpha += 0.005
                    if (p.y < -5 || p.alpha > 1.2) {
                        p.x = Math.random() * width
                        p.y = height + 5
                        p.alpha = 0
                    }
                    var a = Math.sin(p.alpha * Math.PI) * 0.7
                    ctx.beginPath()
                    ctx.arc(p.x, p.y, p.r, 0, 2 * Math.PI)
                    ctx.fillStyle = Qt.rgba(1,1,1, a)
                    ctx.fill()
                }
            }
        }

        // ── BLUR / PARTIAL BLUR ────────────────────────────────────
        ShaderEffectSource {
            id: blurMask
            height: parent.height
            width:  form.width
            anchors.centerIn: form
            sourceItem: backgroundImage
            sourceRect: Qt.rect(x, y, width, height)
            visible: config.FullBlur == "true" || config.PartialBlur == "true"
        }

        FastBlur {
            id: blur
            height: parent.height
            width:  (config.FullBlur == "true" && config.PartialBlur == "false" && config.FormPosition != "center")
                    ? parent.width - formBackground.width
                    : config.FullBlur == "true" ? parent.width : form.width
            anchors.centerIn: config.FullBlur == "true" ? backgroundImage : form
            source: config.FullBlur == "true" ? backgroundImage : blurMask
            radius: config.Blur == "" ? 48 : Math.min(config.Blur * 24, 64)
            visible: config.FullBlur == "true" || config.PartialBlur == "true"
        }

        // ── FORM GLASS BACKGROUND ──────────────────────────────────
        Rectangle {
            id: formBackground
            anchors.fill: form
            anchors.centerIn: form
            z: 3
            color:   config.FormBackgroundColor
            visible: config.HaveFormBackground == "true"
            opacity: config.PartialBlur == "true" ? 0.25 : 0.88
            radius:  config.RoundCorners || 18

            // inner highlight rim
            border.color: Qt.rgba(1,1,1,0.08)
            border.width: 1
        }

        // ── LOGIN FORM ─────────────────────────────────────────────
        LoginForm {
            id: form
            height: parent.height
            width:  parent.width / 2.5
            anchors.left:             config.FormPosition == "left"   ? parent.left             : undefined
            anchors.horizontalCenter: config.FormPosition == "center" ? parent.horizontalCenter : undefined
            anchors.right:            config.FormPosition == "right"  ? parent.right            : undefined
            z: 4
        }

        // ── VIRTUAL KEYBOARD ───────────────────────────────────────
        Loader {
            id: virtualKeyboard
            source: "Components/VirtualKeyboard.qml"
            width:  config.KeyboardSize == "" ? parent.width * 0.4 : parent.width * config.KeyboardSize
            anchors.bottom: parent.bottom
            anchors.left:             config.VirtualKeyboardPosition == "left"   ? parent.left             : undefined
            anchors.horizontalCenter: config.VirtualKeyboardPosition == "center" ? parent.horizontalCenter : undefined
            anchors.right:            config.VirtualKeyboardPosition == "right"  ? parent.right            : undefined
            z: 5

            state: "hidden"
            property bool keyboardActive: item ? item.active : false
            function switchState() { state = state == "hidden" ? "visible" : "hidden" }

            states: [
                State { name: "visible"; PropertyChanges { target: virtualKeyboard; y: root.height - virtualKeyboard.height; opacity: 1 } },
                State { name: "hidden";  PropertyChanges { target: virtualKeyboard; y: root.height - root.height/4;         opacity: 0 } }
            ]
            transitions: [
                Transition {
                    from: "hidden"; to: "visible"
                    SequentialAnimation {
                        ScriptAction { script: { virtualKeyboard.item.activated = true; Qt.inputMethod.show() } }
                        ParallelAnimation {
                            NumberAnimation  { target: virtualKeyboard; property: "y";       duration: 100; easing.type: Easing.OutQuad }
                            OpacityAnimator { target: virtualKeyboard;                       duration: 100; easing.type: Easing.OutQuad }
                        }
                    }
                },
                Transition {
                    from: "visible"; to: "hidden"
                    SequentialAnimation {
                        ParallelAnimation {
                            NumberAnimation  { target: virtualKeyboard; property: "y";       duration: 100; easing.type: Easing.InQuad }
                            OpacityAnimator { target: virtualKeyboard;                       duration: 100; easing.type: Easing.InQuad }
                        }
                        ScriptAction { script: { virtualKeyboard.item.activated = false; Qt.inputMethod.hide() } }
                    }
                }
            ]
        }

        MouseArea {
            anchors.fill: backgroundImage
            onClicked: parent.forceActiveFocus()
        }
    }
}
