import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15


Rectangle {
    id: sidebar
    color: "#2a2a2a"

    signal pageSelected(string pageName)
    
    property var menuItems: [
        { name: "Initialize", page: "Initialize", icon: "../assets/icons/sidebar/usb.svg" },
        { name: "Flight Planning", page: "FlightPlanning", icon: "../assets/icons/sidebar/map.svg" },
        { name: "Main Panel", page: "MainPanel", icon: "../assets/icons/sidebar/dashboard.svg" },
        { name: "Rescue", page: "Rescue", icon: "../assets/icons/sidebar/accessibility.svg" },
        { name: "Landing", page: "Landing", icon: "../assets/icons/sidebar/flight_land.svg" },
        { name: "Advanced Monitoring", page: "AdvancedMonitoring", icon: "../assets/icons/sidebar/monitoring.svg" },
        { name: "PFD & ND", page: "PFDND", icon: "../assets/icons/sidebar/simulation.svg" },
    ]
    property string selectedPage: "MainPanel"
    

    ColumnLayout {
        anchors.fill: parent
        spacing: 15

        // 상단 로고
        Image {
            source: "../assets/logo.png"
            Layout.fillWidth: true
            Layout.preferredHeight: 100
            fillMode: Image.PreserveAspectFit
            Layout.alignment: Qt.AlignHCenter
        }

        // 메뉴 버튼들
        Repeater {
            id: menuRepeater
            model: sidebar.menuItems
            
            delegate: Rectangle {
                id: menuItem
                required property var modelData
                
                Layout.preferredWidth: 40
                Layout.preferredHeight: 40
                Layout.alignment: Qt.AlignHCenter
                radius: 8
                color: sidebar.selectedPage === menuItem.modelData.page ? "#1a1a1a" : "#2a2a2a"
                
                function updateColor() {
                    if (sidebar.selectedPage === menuItem.modelData.page) {
                        color = "#1a1a1a"
                    } else {
                        color = "#2a2a2a"
                    }
                }
                
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    
                    onClicked: {
                        sidebar.selectedPage = menuItem.modelData.page
                        sidebar.pageSelected(menuItem.modelData.page)
                        
                        // 모든 메뉴 아이템의 색상을 강제로 업데이트
                        for (let i = 0; i < menuRepeater.count; i++) {
                            menuRepeater.itemAt(i).updateColor()
                        }
                    }
                    
                    onEntered: {
                        if (sidebar.selectedPage === menuItem.modelData.page) {
                            return
                        } 
                        menuItem.color = "#3a3a3a"
                    }
                    onExited: {
                        if (sidebar.selectedPage === menuItem.modelData.page) {
                            menuItem.color = "#1a1a1a"
                        } else {
                            menuItem.color = "#2a2a2a"
                        }
                    }
                    
                    ToolTip {
                        visible: parent.containsMouse
                        background: Rectangle {
                            color: "#3a3a3a"
                            radius: 6
                            border.color: "#606060"
                            border.width: 1
                        }
                        
                        contentItem: Text {
                            text: menuItem.modelData.name
                            color: "#d4d4d4"
                            font.pixelSize: 14
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            padding: 2
                        }
                        
                        // 툴팁 위치 조정 (오른쪽으로 표시)
                        x: parent.width + 15
                        y: parent.height / 2 - height / 2
                    }
                }

                Image {
                    source: menuItem.modelData.icon
                    Layout.preferredWidth: 20
                    Layout.preferredHeight: 20
                    anchors.centerIn: parent
                    fillMode: Image.PreserveAspectFit
                }
            }
        }
         
        // 여백
        Item {
            Layout.fillHeight: true
        }
    }
}