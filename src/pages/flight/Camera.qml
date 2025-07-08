
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15


Rectangle {
    color: "#1a1a1a"

    Rectangle {
        anchors.fill: parent
        color: "#2a2a2a"
        radius: 8
        
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 15
            spacing: 10
            
            // 비디오 스트림 영역
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "#000000"
                radius: 6
                
                Text {
                    anchors.centerIn: parent
                    text: "전방 카메라 스트림"
                    color: "#666666"
                    font.pixelSize: 18
                }
                
                // 스트림 상태 표시
                Rectangle {
                    anchors.top: parent.top
                    anchors.right: parent.right
                    anchors.margins: 10
                    width: 7
                    height: 7
                    radius: 10
                    color: "#4CAF50"
                }
            }
        }
    }
}
