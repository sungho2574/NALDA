import QtQuick 2.15
import QtQuick.Layouts 1.15


Item {
    id: sidebar

    signal menuSelected(int menuId)

    property var menuItems: []
    property int selectedMenuId: 1
    

    ColumnLayout {
        anchors.fill: parent
        spacing: 10

        Repeater {
            id: menuRepeater
            model: sidebar.menuItems

            delegate: Rectangle {
                id: menuItem
                
                required property var modelData

                Layout.fillWidth: true
                Layout.preferredHeight: 40
                Layout.alignment: Qt.AlignHCenter
                radius: 8
                color: sidebar.selectedMenuId === menuItem.modelData.id ? "#3a3a3a" : "#2a2a2a"

                Text {
                    text: modelData.name
                    color: "#dddddd"
                    font.pixelSize: 16
                    font.weight: 600
                    anchors.centerIn: parent
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    
                    onClicked: {
                        sidebar.selectedMenuId = menuItem.modelData.id
                        sidebar.menuSelected(menuItem.modelData.id)
                        
                        // 모든 메뉴 아이템의 색상을 강제로 업데이트
                        for (let i = 0; i < menuRepeater.count; i++) {
                            menuRepeater.itemAt(i).updateColor()
                        }
                    }
                }

                function updateColor() {
                    if (sidebar.selectedMenuId === menuItem.modelData.id) {
                        color = "#3a3a3a"
                    } else {
                        color = "#2a2a2a"
                    }
                }

            }
        }

        // 여백
        Item {
            Layout.fillHeight: true
        }
    }
}