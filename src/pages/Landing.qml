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
        text: "전방, 하방 카메라 영상 표시 및 라벨링 / 그 외 필요한 모니터링 수치 표시"
        color: "white"
        font.pixelSize: 20
        anchors.centerIn: parent
    }
}