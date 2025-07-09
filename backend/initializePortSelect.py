import serial.tools.list_ports

from PySide6.QtCore import QObject, Slot


# QML과 통신을 담당할 백엔드 클래스
class InitializePortSelect(QObject):
    def __init__(self, parent=None):
        super().__init__(parent)
        self.port_list = []

    # QML에서 호출할 수 있는 슬롯 (포트 목록 전달)
    @Slot(result=list)
    def get_port_list(self):
        self.port_list.clear()
        ports = serial.tools.list_ports.comports()
        for port in ports:
            self.port_list.append({
                'device': port.device,
                'display': f"{port.device} ({port.description})",
            })

        return self.port_list

    # QML에서 '연결' 버튼을 누르면 호출될 슬롯
    @Slot(str, int)
    def connect_button_clicked(self, device, baudrate):
        print("--- Python: 연결 버튼 클릭됨 ---")
        if not device:
            print("오류: 포트가 선택되지 않았습니다.")
            return

        print(f"Port: {device}, Baud rate: {baudrate}")
        try:
            ser = serial.Serial(device, baudrate)
            print(f"{device}에 성공적으로 연결되었습니다.")
        except Exception as e:
            print(f"연결 실패: {e}")
