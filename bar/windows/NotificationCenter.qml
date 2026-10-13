import "../"
import "../components"
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Notifications
import Quickshell.Wayland

PanelWindow {
    id: root

    required property NotificationServer server
    property bool isOpen: false

    WlrLayershell.namespace: "quickshell:notifcenter"
    visible: isOpen || innerBg.height > 0
    margins.top: 45
    margins.right: 10
    width: 380
    color: "transparent"
    implicitHeight: Math.min(500, innerLayout.implicitHeight + 32)
    exclusionMode: ExclusionMode.Ignore
    onIsOpenChanged: {
        if (isOpen && !hoverHandler.hovered)
            hideTimer.restart();
        else if (!isOpen)
            hideTimer.stop();
    }

    anchors {
        top: true
        right: true
    }

    Timer {
        id: hideTimer

        interval: 2000
        onTriggered: root.isOpen = false
    }

    HoverHandler {
        id: hoverHandler

        onHoveredChanged: {
            if (hovered)
                hideTimer.stop();
            else if (root.isOpen)
                hideTimer.restart();
        }
    }

    Rectangle {
        id: innerBg

        width: parent.width
        height: root.isOpen ? root.implicitHeight : 0
        anchors.top: parent.top
        clip: true
        color: Qt.rgba(30 / 255, 30 / 255, 46 / 255, 0.6)
        border.color: Theme.surface2
        border.width: 1
        radius: Theme.moduleRadius

        ColumnLayout {
            id: innerLayout

            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 16
            spacing: 16

            RowLayout {
                Layout.fillWidth: true

                Text {
                    text: "Notifications"
                    color: Theme.text
                    font.family: Theme.fontFamily
                    font.pixelSize: 18
                    font.bold: true
                    Layout.fillWidth: true
                }

                Rectangle {
                    width: 84
                    height: 26
                    radius: 6
                    color: clearMouse.containsMouse ? Qt.alpha(Theme.indigo, 0.15) : Qt.rgba(127 / 255, 127 / 255, 127 / 255, 0.08)
                    border.color: clearMouse.containsMouse ? Qt.alpha(Theme.indigo, 0.4) : Qt.rgba(1, 1, 1, 0.12)
                    border.width: 1

                    Text {
                        anchors.centerIn: parent
                        text: "Clear All"
                        color: clearMouse.containsMouse ? Theme.indigo : Theme.text
                        font.family: Theme.fontFamily
                        font.pixelSize: 12

                        Behavior on color {
                            ColorAnimation {
                                duration: 150
                            }

                        }

                    }

                    MouseArea {
                        id: clearMouse

                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            root.isOpen = false;
                            const list = Array.from(root.server.trackedNotifications.values);
                            list.forEach((n) => {
                                return n.dismiss();
                            });
                        }
                    }

                    Behavior on color {
                        ColorAnimation {
                            duration: 150
                        }

                    }

                    Behavior on border.color {
                        ColorAnimation {
                            duration: 150
                        }

                    }

                }

            }

            ListView {
                id: popupList

                Layout.fillWidth: true
                Layout.preferredHeight: contentHeight
                Layout.maximumHeight: 400
                clip: true
                spacing: 10
                model: root.server.trackedNotifications

                delegate: NotificationToast {
                    notification: modelData
                    width: popupList.width
                }

                add: Transition {
                    NumberAnimation {
                        property: "opacity"
                        from: 0
                        to: 1
                        duration: 200
                    }

                }

                remove: Transition {
                    NumberAnimation {
                        property: "opacity"
                        to: 0
                        duration: 150
                    }

                    NumberAnimation {
                        property: "scale"
                        to: 0.9
                        duration: 150
                    }

                }

            }

        }

        Behavior on height {
            NumberAnimation {
                duration: 300
                easing.type: Easing.OutExpo
            }

        }

    }

}
