import sys
from pathlib import Path

from PySide6.QtCore import QObject, Slot, Signal, Property, QUrl
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine, qmlRegisterType

import serial.tools.list_ports


# QML에서 사용할 데이터 모델 클래스
class PortInfo(QObject):
    def __init__(self, device, description, parent=None):
        super().__init__(parent)
        self._device = device
        self._description = description

    @Property(str, constant=True)
    def device(self):
        return self._device

    @Property(str, constant=True)
    def description(self):
        return self._description

# QML과 통신을 담당할 백엔드 클래스
class InitializePortSelect(QObject):
    def __init__(self, parent=None):
        super().__init__(parent)
        self._table_data = []

    # 데이터가 변경되었음을 QML에 알리는 시그널
    tableDataChanged = Signal()

    # QML에서 backend.tableData로 접근할 수 있는 프로퍼티
    # 데이터가 변경되면 tableDataChanged 시그널을 emit해야 QML이 업데이트됩니다.
    @Property(list, notify=tableDataChanged)
    def tableData(self):
        return self._table_data

    # QML에서 호출할 수 있는 슬롯 (리스트 초기화)
    @Slot()
    def initialize_list(self):
        self._table_data.clear()
        ports = serial.tools.list_ports.comports()
        for port in ports:
            self._table_data.append({'device': port.device, 'description': port.description})
        
        # 데이터가 변경되었음을 QML에 알림
        self.tableDataChanged.emit()

    # QML에서 호출할 수 있는 슬롯 (리스트에 항목 추가)
    @Slot(str, str)
    def add_item(self, device, description):
        print(f"Python: '{device}' 항목 추가")
        self._table_data.append({'device': device, 'description': description})
        self.tableDataChanged.emit()

    # QML에서 '연결' 버튼을 누르면 호출될 슬롯
    @Slot(str, str, int)
    def connect_button_clicked(self, device, description, baudrate):
        print("--- Python: 연결 버튼 클릭됨 ---")
        if not device:
            print("오류: 포트가 선택되지 않았습니다.")
            return
        
        try:
            ser = serial.Serial(device, baudrate)
            print(f"{device}에 성공적으로 연결되었습니다.")
        except Exception as e:
            print(f"연결 실패: {e}")
