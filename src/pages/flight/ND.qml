import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtLocation 5.15
import QtPositioning 5.15


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
            
            // 지도 영역
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "#000000"
                radius: 6

                // 지도 추가
                Map {
                    anchors.fill: parent
                    plugin: Plugin {
                        name: "osm"   // OpenStreetMap 무료 지도
                    }
                    center: QtPositioning.coordinate(37.5665, 126.9780) // 서울 시청 예시
                    zoomLevel: 15

                    // 드론 위치 마커
                    MapQuickItem {
                        id: droneMarker
                        anchorPoint.x: 12
                        anchorPoint.y: 12
                        coordinate: QtPositioning.coordinate(37.5665, 126.9780) // 드론 위치
                        sourceItem: Rectangle {
                            width: 24; height: 24
                            color: "red"
                            radius: 12
                            border.color: "white"
                            border.width: 2
                        }
                    }
                }
            }
        }
    }
}