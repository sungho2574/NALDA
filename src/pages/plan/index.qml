import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

Rectangle {
    id: initPage
    color: "#2a2a2a"
    Layout.fillHeight: true
    Layout.fillWidth: true
    Layout.margins: 20

    Text {
        text: "GPS waypoint 입력 및 천이 옵션 지정"
        color: "white"
        font.pixelSize: 20
        anchors.centerIn: parent
    }
}