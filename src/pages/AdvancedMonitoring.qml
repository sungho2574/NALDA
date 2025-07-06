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
        text: "가속도 및 자이로 센서 값 / 그 외 모든 세부수치를 그래프로 표시"
        color: "white"
        font.pixelSize: 20
        anchors.centerIn: parent
    }
}