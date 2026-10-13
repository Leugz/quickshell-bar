import "../components"
import QtQuick
import Quickshell
import Quickshell.Services.Notifications
import Quickshell.Wayland

PanelWindow {
    id: root

    required property NotificationServer server
    property var linkedCenter

    WlrLayershell.namespace: "quickshell:notifoverlay"
    margins.top: 50
    margins.right: 15
    width: 360
    implicitHeight: popupColumn.height
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore

    anchors {
        top: true
        right: true
    }

    Column {
        id: popupColumn

        width: parent.width
        spacing: 12

        Repeater {
            model: root.server.trackedNotifications

            delegate: Item {
                id: toastWrapper

                property bool expired: false

                width: parent.width
                clip: true
                Component.onCompleted: {
                    if (root.linkedCenter && root.linkedCenter.isOpen)
                        toastWrapper.expired = true;

                }
                opacity: expired ? 0 : 1
                visible: opacity > 0
                height: expired ? 0 : toast.implicitHeight

                HoverHandler {
                    id: wrapperHover
                }

                Timer {
                    interval: 5000
                    running: !wrapperHover.hovered
                    onTriggered: toastWrapper.expired = true
                }

                Connections {
                    function onIsOpenChanged() {
                        if (root.linkedCenter && root.linkedCenter.isOpen)
                            toastWrapper.expired = true;

                    }

                    target: root.linkedCenter
                }

                NotificationToast {
                    id: toast

                    notification: modelData
                    width: parent.width
                }

                Behavior on opacity {
                    NumberAnimation {
                        duration: 250
                    }

                }

                Behavior on height {
                    NumberAnimation {
                        duration: 250
                        easing.type: Easing.OutExpo
                    }

                }

            }

        }

    }

}
