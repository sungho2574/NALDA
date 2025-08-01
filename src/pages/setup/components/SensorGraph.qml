import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15

ColumnLayout {
    anchors.fill: parent

    Text {
        text: "센서값 시각화"
        color: "white"
        font.pixelSize: 24
        font.bold: true
    }

    ColumnLayout {
        Layout.topMargin: 20

        // 센서 그래프 영역
    }

    // 여백
    Item { Layout.fillHeight: true }
}