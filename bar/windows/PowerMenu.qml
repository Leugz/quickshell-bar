import "../"
import QtQuick
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: root

    WlrLayershell.namespace: "quickshell:powermenu"
    visible: false
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    color: "transparent"

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    Rectangle {
        id: dimBg

        readonly property bool vertical: height > width
        readonly property real cellW: vertical ? Math.max(140, Math.min(300, Math.min(width, height) * 0.3)) : Math.max(120, Math.min(220, width * 0.11))
        readonly property real cellH: vertical ? cellW * 0.75 : Math.max(200, Math.min(400, height * 0.24))

        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, 0.7)
        focus: true
        Keys.onEscapePressed: root.visible = false

        MouseArea {
            anchors.fill: parent
            onClicked: root.visible = false
        }

        Grid {
            anchors.centerIn: parent
            columns: dimBg.vertical ? 2 : 4
            spacing: 0

            Repeater {
                model: [{
                    "name": "Suspend",
                    "icon": "\uf28c",
                    "cmd": "systemctl suspend",
                    "accent": Theme.indigo
                }, {
                    "name": "Logout",
                    "icon": "\udb80\udf43",
                    "cmd": "hyprctl dispatch exit",
                    "accent": Theme.cyan
                }, {
                    "name": "Reboot",
                    "icon": "\uead2",
                    "cmd": "systemctl reboot",
                    "accent": Theme.mauve
                }, {
                    "name": "Shutdown",
                    "icon": "\uf011",
                    "cmd": "systemctl poweroff",
                    "accent": Theme.maroon
                }]

                delegate: Item {
                    id: cell

                    readonly property bool atLeft: dimBg.vertical ? (index % 2 === 0) : (index === 0)
                    readonly property bool atRight: dimBg.vertical ? (index % 2 === 1) : (index === 3)
                    readonly property bool atTop: dimBg.vertical ? (index < 2) : true
                    readonly property bool atBottom: dimBg.vertical ? (index >= 2) : true
                    readonly property real hoverR: mouseArea.containsMouse ? 40 : 0

                    function cornerRadius(isLeft, isTop) {
                        if (dimBg.vertical) {
                            if (atLeft === isLeft && atTop === isTop)
                                return 40;

                            if (atLeft !== isLeft && atTop !== isTop)
                                return 0;

                            return hoverR;
                        }
                        return ((isLeft && atLeft) || (!isLeft && atRight)) ? 40 : hoverR;
                    }

                    width: dimBg.cellW
                    height: dimBg.cellH

                    Rectangle {
                        id: actionButton

                        width: dimBg.vertical && mouseArea.containsMouse ? cell.width * 1.25 : cell.width
                        height: mouseArea.containsMouse ? cell.height * (dimBg.vertical ? 1.25 : 1.167) : cell.height
                        x: dimBg.vertical && cell.atLeft ? cell.width - width : 0
                        y: dimBg.vertical ? (cell.atTop ? cell.height - height : 0) : (cell.height - height) / 2
                        color: mouseArea.containsMouse ? Qt.rgba(1, 1, 1, 0.1) : Qt.rgba(1, 1, 1, 0.06)
                        topLeftRadius: cell.cornerRadius(true, true)
                        topRightRadius: cell.cornerRadius(false, true)
                        bottomLeftRadius: cell.cornerRadius(true, false)
                        bottomRightRadius: cell.cornerRadius(false, false)

                        Text {
                            anchors.centerIn: parent
                            text: modelData.icon
                            font.family: Theme.fontFamilyAlt
                            font.pixelSize: mouseArea.containsMouse ? 68 : 52
                            color: mouseArea.containsMouse ? modelData.accent : "#ffffff"

                            Behavior on font.pixelSize {
                                NumberAnimation {
                                    duration: 200
                                }

                            }

                            Behavior on color {
                                ColorAnimation {
                                    duration: 150
                                }

                            }

                        }

                        MouseArea {
                            id: mouseArea

                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                root.visible = false;
                                Quickshell.execDetached(["bash", "-c", modelData.cmd]);
                            }
                        }

                        Behavior on width {
                            NumberAnimation {
                                duration: 300
                                easing.type: Easing.OutBack
                            }

                        }

                        Behavior on height {
                            NumberAnimation {
                                duration: 300
                                easing.type: Easing.OutBack
                            }

                        }

                        Behavior on color {
                            ColorAnimation {
                                duration: 200
                            }

                        }

                        Behavior on topLeftRadius {
                            NumberAnimation {
                                duration: 200
                            }

                        }

                        Behavior on topRightRadius {
                            NumberAnimation {
                                duration: 200
                            }

                        }

                        Behavior on bottomLeftRadius {
                            NumberAnimation {
                                duration: 200
                            }

                        }

                        Behavior on bottomRightRadius {
                            NumberAnimation {
                                duration: 200
                            }

                        }

                    }

                }

            }

        }

    }

}
