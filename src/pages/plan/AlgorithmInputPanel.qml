import QtQuick 2.15
import QtQuick.Dialogs
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ApplicationWindow {
    id: algorithmInputPanel
    title: "미션 플랜 알고리즘 추가"
    width: 600
    height: 500
    visible: true
    color: "#2a2a2a"
    
    signal accepted(string algorithmName, url fileUrl)
    signal cancelled()

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 20

        // 알고리즘 이름 입력
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 10
            
            Text {
                text: "알고리즘 이름:"
                color: "white"
                font.pixelSize: 16
                font.bold: true
            }
            
            TextField {
                id: newAlgorithmName
                Layout.fillWidth: true
                placeholderText: "알고리즘 이름을 입력하세요"
                color: "white"
                background: Rectangle {
                    color: "#4a4a4a"
                    border.color: "#666666"
                    border.width: 1
                    radius: 5
                }
            }
        }
        
        // 파일 선택
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 10
            
            Text {
                text: "경로 파일 (.txt, .csv):"
                color: "white"
                font.pixelSize: 16
                font.bold: true
            }
            
            RowLayout {
                Layout.fillWidth: true
                spacing: 10
                
                Button {
                    text: "파일 선택"
                    Layout.preferredWidth: 80
                    Layout.preferredHeight: 30
                    
                    background: Rectangle {
                        color: parent.pressed ? "#616161" : "#757575"
                        radius: 4
                    }
                    
                    contentItem: Text {
                        text: parent.text
                        color: "white"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: 12
                    }
                    
                    onClicked: fileDialog.open()
                }
                
                Text {
                    id: fileUrlText
                    Layout.fillWidth: true
                    text: "파일이 선택되지 않았습니다"
                    color: "#cccccc"
                    font.pixelSize: 12
                    elide: Text.ElideMiddle
                }
            }
        }
        
        // 버튼 영역
        RowLayout {
            Layout.fillWidth: true
            Layout.topMargin: 20
            spacing: 10
            
            Button {
                text: "취소"
                Layout.fillWidth: true
                
                background: Rectangle {
                    color: parent.pressed ? "#616161" : "#757575"
                    radius: 4
                }
                
                contentItem: Text {
                    text: parent.text
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: 14
                }
                
                onClicked: {
                    cancelled()
                    close()
                }
            }
            
            Button {
                text: "추가"
                Layout.fillWidth: true
                
                background: Rectangle {
                    color: parent.pressed ? "#388E3C" : "#4CAF50"
                    radius: 4
                }
                
                contentItem: Text {
                    text: parent.text
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: 14
                }
                
                onClicked: {
                    if (newAlgorithmName.text.trim() !== "" && fileDialog.fileUrl !== "") {
                        accepted(newAlgorithmName.text.trim(), fileDialog.fileUrl)
                        close()
                    } else {
                        console.log("알고리즘 이름과 파일을 모두 선택해주세요.")
                    }
                }
            }
        }
    }
    
    FileDialog {
        id: fileDialog
        title: "경로 파일 선택"
        nameFilters: ["Text files (*.txt)", "CSV files (*.csv)", "All files (*)"]
        fileMode: FileDialog.OpenFile
        
        onAccepted: {
            var fileName = fileDialog.fileUrl.toString()
            // 파일 경로에서 파일명만 추출
            var fileNameOnly = fileName.split('/').pop()
            fileUrlText.text = fileNameOnly
        }
    }
}
