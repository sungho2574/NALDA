import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15

Rectangle {
    id: initializePage
    Layout.fillHeight: true
    Layout.fillWidth: true
    color: "#1a1a1a"
    

    Rectangle {
        width: 800
        height: 600
        anchors.centerIn: parent
        color: "#2a2a2a"
        radius: 8

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20

            // 제목
            Text {
                text: "포트 설정"
                font.pixelSize: 20
                font.weight: 700
                color: "white"
                Layout.bottomMargin: 15
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 20

                Rectangle {
                    Layout.fillHeight: true
                    width: 500

                    color: "#2a2a2a"

                    // 포트 목록
                    // 테이블
                    Rectangle {
                        anchors.fill: parent
                        border.color: "#606060"
                        border.width: 1
                        radius: 8
                        color: "#2a2a2a"

                        
                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 1
                            spacing: 0
                            
                            // 테이블 헤더
                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 40
                                color: "#2a2a2a"
                                topLeftRadius: 8
                                topRightRadius: 8
                                
                                Rectangle {
                                    anchors.bottom: parent.bottom
                                    width: parent.width
                                    height: 1
                                    color: "#606060"
                                }
                                
                                
                                RowLayout {
                                    anchors.fill: parent
                                    anchors.leftMargin: 15
                                    anchors.rightMargin: 15
                                    spacing: 0
                                    
                                    Text {
                                        text: "port"
                                        font.pixelSize: 14
                                        font.bold: true
                                        color: "white"
                                        Layout.preferredWidth: 300
                                    }
                                    
                                    Text {
                                        text: "description"
                                        font.pixelSize: 14
                                        font.bold: true
                                        color: "white"
                                        Layout.fillWidth: true
                                    }
                                }
                            }

                            
                            // 테이블 내용
                            Rectangle {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                color: "#2a2a2a"
                                radius: 8
                                clip: true

                                ScrollView {
                                    anchors.fill: parent
                                    
                                    ListView {
                                        id: tableListView
                                        model: initializePortSelect.tableData
                                        
                                        delegate: Rectangle {
                                            id: tableRow
                                            required property int index
                                            required property var modelData
                                            
                                            width: tableListView.width
                                            height: 40

                                            color: tableRow.ListView.isCurrentItem ? "#4CAF50" 
                                                : (mouseArea.hovered ? "#3a3a3a" 
                                                : "#2a2a2a")

                                            MouseArea {
                                                id : mouseArea
                                                anchors.fill: parent
                                                hoverEnabled: true

                                                onClicked: {
                                                    tableListView.currentIndex = index
                                                }
                                            }
                                            
                                            RowLayout {
                                                anchors.fill: parent
                                                anchors.leftMargin: 5
                                                anchors.rightMargin: 5
                                                spacing: 0
                                                
                                                Text {
                                                    text: tableRow.modelData.device
                                                    font.pixelSize: 14
                                                    color: "white"
                                                    Layout.preferredWidth: 300
                                                    elide: Text.ElideRight
                                                    Layout.leftMargin: 10
                                                }
                                                
                                                Text {
                                                    text: tableRow.modelData.description
                                                    font.pixelSize: 14
                                                    color: "white"
                                                    Layout.fillWidth: true
                                                    elide: Text.ElideRight
                                                }
                                            }
                                            
                                            Rectangle {
                                                anchors.bottom: parent.bottom
                                                width: parent.width
                                                height: 1
                                                color: "#606060"
                                                visible: tableRow.index !== tableListView.count - 1
                                            }
                                        }

                                        Component.onCompleted: {
                                            // 초기 선택 상태 설정
                                            tableListView.currentIndex = -1;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "#2a2a2a"

                    ColumnLayout {
                        anchors.fill: parent

                        // 보율 선택
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 8

                            Text {
                                text: "Baud rate"
                                color: "#999999"
                                font.pixelSize: 14
                                font.bold: true
                            }
                            ComboBox {
                                id: baudRateComboBox
                                Layout.fillWidth: true
                                Layout.preferredHeight: 40
                                model: [1200, 2400, 4800, 9600, 19200, 38400, 57600, 115200]
                                currentIndex: 0
                            }
                        }

                        // 여백
                        Item { Layout.fillHeight: true }

                        
                        // 연결 버튼
                        Button {
                            text: "연결"
                            Layout.fillWidth: true
                            Layout.preferredHeight: 40
                            background: Rectangle {
                                color: "#4CAF50"
                                radius: 8
                            }
                            contentItem: Text {
                                text: parent.text
                                color: "white"
                                font.pixelSize: 14
                                font.weight: 700
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }

                             // 5. 버튼 클릭 시 Python의 connect_button_clicked 함수 호출
                            onClicked: {
                                if (tableListView.currentIndex === -1) {
                                    console.log("포트를 선택해주세요.");
                                    return;
                                }
                                // backend
                                // 선택된 항목의 데이터와 보율을 인자로 전달
                                initializePortSelect.connect_button_clicked(
                                    tableListView.model[tableListView.currentIndex].device,
                                    tableListView.model[tableListView.currentIndex].description,
                                    baudRateComboBox.currentValue
                                )
                            }
                        }
                    }
                }
            }
        }
    }
}