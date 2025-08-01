import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtWebEngine 1.10

ColumnLayout {
    id: sensorGraphRoot
    anchors.fill: parent

    property bool htmlLoaded: false

    // DataProvider 인스턴스
    Connections {
        target: sensorManager

        function onDataReady(data) {
            console.log("QML에서 받은 데이터:", data)
            
            // HTML이 완전히 로드된 경우에만 JavaScript 함수 호출
            if (sensorGraphRoot.htmlLoaded) {
                var jsCode = "window.receiveData(" + JSON.stringify(data) + ");"
                webView.runJavaScript(jsCode)
                webView.runJavaScript("console.log('Data sent to HTML:', " + JSON.stringify(data) + ");")
                webView.runJavaScript("test();")
            } else {
                console.log("HTML이 아직 로드되지 않았습니다. 데이터 무시:", data)
            }
        }
    }


    // 상단 제목
    Text {
        text: "센서값 시각화"
        color: "#dddddd"
        font.pixelSize: 24
        font.bold: true
    }

    // 컨텐츠 영역
    ColumnLayout {
        Layout.topMargin: 20
       
        WebEngineView {
            id: webView
            Layout.fillWidth: true
            // Layout.fillHeight: true
            height: 400
            url: Qt.resolvedUrl("uplot/stream-data.html")
            
            onLoadingChanged: function(loadRequest) {
                if (loadRequest.status === WebEngineView.LoadFailedStatus) {
                    console.log("Failed to load:", loadRequest.errorString)
                    sensorGraphRoot.htmlLoaded = false
                } else if (loadRequest.status === WebEngineView.LoadSucceededStatus) {
                    console.log("Successfully loaded HTML file")
                    sensorGraphRoot.htmlLoaded = true
                }
            }

            onJavaScriptConsoleMessage: function(level, message, lineNumber, sourceID) {
                console.log("JS Console:", message)
            }
        }
    }

    // 여백
    Item { Layout.fillHeight: true }
}