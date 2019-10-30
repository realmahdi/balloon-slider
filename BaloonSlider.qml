import QtQuick 2.0
import QtQuick.Controls 2.12

Slider {

    id: control
    value: 0.5

    enum MoveDirection {
        FORWARD,
        BACKWARD,
        FIX
    }

    property real last_value: position
    property int move_direction: BaloonSlider.MoveDirection.FIX
    property bool is_moved: false

    background: Rectangle {
        x: control.leftPadding
        y: control.topPadding + control.availableHeight / 2 - height / 2
        width: control.availableWidth
        height: implicitHeight
        implicitWidth: 200
        implicitHeight: 4
        color: "#bdbebf"
        radius: 2

        Rectangle {
            width: control.visualPosition * parent.width
            height: parent.height
            color: "#4527a0"
            radius: 2
        }
    }

    handle: Rectangle {
        id: handler
        x: control.leftPadding + control.visualPosition * (control.availableWidth - width)
        y: control.topPadding + control.availableHeight / 2 - height / 2
        implicitWidth: 20
        implicitHeight: 20
        border.color: "#4527a0"
        border.width: (control.pressed)? 1 : radius / 2
        color: (control.pressed) ? "#f0f0f0" : "#f6f6f6"
        scale: (control.pressed) ? 1.3 : 1
        radius: 13

        Behavior on scale {
            NumberAnimation { duration: 100 }
        }

        Behavior on border.width {
            NumberAnimation { duration: 100 }
        }
    }

    Image
    {
        id: baloon_img
        y: (control.pressed) ? ((handler.y - height) - 10) : (handler.y - (handler.height /2))
        x: (handler.x - (handle.implicitWidth + 1))
        width: 64
        height: 64
        sourceSize: "64x64"
        source: "qrc:/Resource/balloon.svg"
        antialiasing: true
        scale: (control.pressed) ? 1 : 0
        rotation: (control.is_moved) ?
                      (control.move_direction === BaloonSlider.MoveDirection.FORWARD) ? -20 : 20 : 0

        Behavior on scale {
            NumberAnimation { duration: 200 }
        }

        Behavior on x {
            NumberAnimation { duration: 70; easing.type: Easing.InCurve }
        }

        Behavior on rotation {
            NumberAnimation { duration: 70; easing.type: Easing.InCurve }
        }

        Behavior on y {
            NumberAnimation { duration: 200; easing.type: Easing.InCurve }
        }

        Label {
            y: baloon_img.height * 0.3
            anchors.horizontalCenter: baloon_img.horizontalCenter
            text: (control.value * 100).toFixed(0)
            visible: control.pressed
            font.pointSize: 12
            color: "white"
        }
    }

    onMoved: {
        control.move_direction = (position > last_value) ? BaloonSlider.MoveDirection.FORWARD
                                                         : BaloonSlider.MoveDirection.BACKWARD;
        last_value = value;
    }

    Timer {
        running: control.pressed
        interval: 10
        repeat: true
        property real last_pos

        onTriggered: {
            control.is_moved = (last_pos !== control.position);
            if (!is_moved)
                control.move_direction = BaloonSlider.MoveDirection.FIX;
            last_pos = control.position;
        }
    }
}
