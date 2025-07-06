import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15
import QtLocation 5.15
import QtPositioning 5.15

import "./components" as Components


ApplicationWindow {
    id: mainWindow
    visible: true
    width: Screen.width
    height: Screen.height
    color: "#1a1a1a"
    title: "NALDA"
    
    // Material 테마 설정
    Material.theme: Material.Dark
    Material.accent: Material.Blue
    
    // 전체화면 설정
    // visibility: Window.FullScreen
    
    // ESC 키로 종료
    Shortcut {
        sequence: "Escape"
        onActivated: Qt.quit()
    }

    property string currentPage: "MainPanel"
    
    // 페이지 매핑을 한 곳에서 관리
    readonly property var pageMap: ({
        "Initialize": "pages/Initialize.qml",
        "FlightPlanning": "pages/FlightPlanning.qml",
        "MainPanel": "pages/MainPanel.qml",
        "Rescue": "pages/Rescue.qml",
        "Landing": "pages/Landing.qml",
        "AdvancedMonitoring": "pages/AdvancedMonitoring.qml",
        "PFDND": "pages/PFDND.qml"
    })
    
    // 메인 레이아웃
    RowLayout {
        anchors.fill: parent

        // 왼쪽 사이드바
        Components.Sidebar {
            Layout.fillHeight: true
            Layout.preferredWidth: 60

            onPageSelected: function(pageName) {
                mainWindow.currentPage = pageName
            }
        }

        // 메인 컨텐츠 영역
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "#1a1a1a"
            
            Loader {
                id: pageLoader
                anchors.fill: parent
                anchors.margins: 20
                
                source: mainWindow.pageMap[mainWindow.currentPage] || mainWindow.pageMap["MainPanel"]
            }
        }
    }
}