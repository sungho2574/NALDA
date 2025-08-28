import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtWebEngine 1.10

ColumnLayout {
    id: attitudeOverviewRoot
    anchors.fill: parent

    property var messageFrame: []
    property int selectedMessageId: 30

    property bool htmlLoaded: false

    property real rollAngle: 0
    property real pitchAngle: 0
    property real yawAngle: 0

    property bool showFixedAxes: true
    property bool showHelperAxes: true

    // htmlLoaded 변경 감지 핸들러 추가
    // 30번 ATTITUDE를 받아오도록 수정
    onHtmlLoadedChanged: {
        if (htmlLoaded) {
            var metaData = attitudeOverviewManager.setTargetMessage(attitudeOverviewRoot.selectedMessageId);
            attitudeOverviewRoot.messageFrame = metaData.fields;

            var jsCode = `window.receiveGraphMetaData(${JSON.stringify(metaData.fields)});`;
            webView.runJavaScript(jsCode);
        }
    }

    // 메시지 업데이트 수신용 Connection
    Connections {
        target: attitudeOverviewManager

        function onMessageUpdated(data) {
            // 자세 업데이트
            attitudeOverviewRoot.rollAngle = data.roll;
            attitudeOverviewRoot.pitchAngle = data.pitch;
            attitudeOverviewRoot.yawAngle = data.yaw;

            // HTML이 완전히 로드된 경우에만 JavaScript 함수 호출
            if (attitudeOverviewRoot.htmlLoaded) {
                var jsCode = `window.receiveData(${JSON.stringify(data)});`;
                webView.runJavaScript(jsCode);
            } else {
                console.log("HTML이 아직 로드되지 않았습니다. 데이터 무시:");
            }
        }
    }

    // 상단 제목
    Text {
        text: "자세 시각화"
        color: "#dddddd"
        font.pixelSize: 24
        font.bold: true
    }

    ColumnLayout {
        Layout.topMargin: 20
        Layout.fillWidth: true
        Layout.fillHeight: true

        // 컨텐츠 영역 - 직접 구현한 스크롤
        // ScrollView, Flickable을 사용하면 마우스 드래그 이벤트를 가로채서 3D 모
        Rectangle {
            id: customScrollArea
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "transparent"
            clip: true

            property real contentY: 0
            property real contentHeight: columnContent.height

            // 스크롤을 위한 MouseArea
            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.NoButton

                onWheel: function (wheel) {
                    var delta = wheel.angleDelta.y;
                    var newContentY = parent.contentY - delta / 3;

                    // 경계값 체크
                    var maxContentY = Math.max(0, parent.contentHeight - parent.height);
                    parent.contentY = Math.max(0, Math.min(maxContentY, newContentY));

                    wheel.accepted = true;
                }
            }

            ColumnLayout {
                id: columnContent
                width: parent.width
                y: -parent.contentY // 스크롤 오프셋 적용

                // 3D 모델 영역
                ModelContainer {
                    id: modelContainer
                    Layout.fillWidth: true
                    Layout.preferredHeight: 400

                    rollAngle: attitudeOverviewRoot.rollAngle
                    pitchAngle: attitudeOverviewRoot.pitchAngle
                    yawAngle: attitudeOverviewRoot.yawAngle

                    showFixedAxes: attitudeOverviewRoot.showFixedAxes
                    showHelperAxes: attitudeOverviewRoot.showHelperAxes
                }

                // 체크박스 영역
                RowLayout {
                    Layout.fillWidth: true
                    Layout.topMargin: 0
                    spacing: 20

                    // 우측 정렬을 위한 여백
                    Item {
                        Layout.fillWidth: true
                    }

                    CheckBox {
                        id: fixedCoordinateCheckBox
                        text: "고정좌표계 표시"
                        checked: true
                        Material.accent: "#33803F"

                        contentItem: Text {
                            text: fixedCoordinateCheckBox.text
                            color: "#dddddd"
                            font.pixelSize: 14
                            leftPadding: fixedCoordinateCheckBox.indicator.width + fixedCoordinateCheckBox.spacing
                            verticalAlignment: Text.AlignVCenter
                        }

                        onCheckedChanged: {
                            attitudeOverviewRoot.showFixedAxes = checked;
                        }
                    }

                    CheckBox {
                        id: auxiliaryCoordinateCheckBox
                        text: "보조좌표계 표시"
                        checked: true
                        Material.accent: "#33803F"

                        contentItem: Text {
                            text: auxiliaryCoordinateCheckBox.text
                            color: "#dddddd"
                            font.pixelSize: 14
                            leftPadding: auxiliaryCoordinateCheckBox.indicator.width + auxiliaryCoordinateCheckBox.spacing
                            verticalAlignment: Text.AlignVCenter
                        }

                        onCheckedChanged: {
                            attitudeOverviewRoot.showHelperAxes = checked;
                        }
                    }
                }

                // 그래프 영역
                Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 450 * 2 // 그래프 개수
                    Layout.topMargin: 30

                    WebEngineView {
                        id: webView
                        anchors.fill: parent
                        url: Qt.resolvedUrl("../../../components/uplot/stream-data.html")
                        // url: "src:/pages/setup/attitude-overview/uplot/stream-data.html"

                        onLoadingChanged: function (loadRequest) {
                            if (loadRequest.status === WebEngineView.LoadFailedStatus) {
                                console.log("Failed to load:", loadRequest.errorString);
                                attitudeOverviewRoot.htmlLoaded = false;
                            } else if (loadRequest.status === WebEngineView.LoadSucceededStatus) {
                                console.log("Successfully loaded HTML file");
                                attitudeOverviewRoot.htmlLoaded = true;
                            }
                        }

                        onJavaScriptConsoleMessage: function (level, message, lineNumber, sourceID) {
                            console.log("JS Console:", message);
                        }
                    }

                    // 마우스 휠 이벤트를 스크롤로 전달
                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.NoButton

                        onWheel: function (wheel) {
                            var delta = wheel.angleDelta.y;
                            var newContentY = customScrollArea.contentY - delta / 3;

                            // 경계값 체크
                            var maxContentY = Math.max(0, customScrollArea.contentHeight - customScrollArea.height);
                            customScrollArea.contentY = Math.max(0, Math.min(maxContentY, newContentY));

                            wheel.accepted = true;
                        }
                    }
                }
            }
        }
    }
}
