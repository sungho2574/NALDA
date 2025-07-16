import sys
import serial
from .packet import *
from typing import Optional
from enum import IntEnum

#추후 다른 메시지를 읽어야한다면 주석 해제하여 사용, 현재는 GPS만 읽는다고 생각하고 나머지 주석 처리함.
#기존의 FC Github의 display method 삭제 (지금 굳이 필요 없음)
class MSG_NUM(IntEnum):
    # SCALED_IMU = 26
    # RAW_IMU = 27
    # SCALED_PRESSURE = 29
    # SERVO_OUTPUT_RAW = 36
    # RC_CHANNELS = 65
    # SCALED_IMU2 = 116
    GLOBAL_POSITION_INT = 33 #  GPS 관련 메시지 ID인 GLOBAL_POSITION_INT (ID: 33)를 추가

#GPS 데이터를 저장할 멤버 변수를 추가하고, update() 메서드를 구현하여 GLOBAL_POSITION_INT 메시지를 파싱
class MAVLink:
    rx: Optional[packet] = None
    ser: Optional[serial.Serial] = None
    __cnt:int = 0

    # GPS 데이터 저장 변수
    _lat: float = 0.0
    _lon: float = 0.0
    _alt: float = 0.0
    _hdg: float = 0.0
 
    def __init__(self, port, baudrate=115200):
        self.rx = packet()
        self.connect(port, baudrate)

    def connect(self, port, baudrate=115200):
        self.ser = serial.Serial(port, baudrate)
        self.__cnt = 0
        print("[%s %d] Connected!"%(port, baudrate))
        return 0

    # MSG 선택
    def select(self, num:MSG_NUM):
        tx = [0xFD]
        tx.append(int(num))
        crc = calulate_crc(tx, 4)
        tx.append(crc >> 8)
        tx.append(crc & 0xff)

        if self.ser is not None:
            self.ser.write(bytes(tx))
        return 0

    # 모든 바이트를 받았을 때
    def update(self):
        if self.rx is None:
            return

        # MAVLink2 GLOBAL_POSITION_INT 메시지 파싱 (ID: 33)
        # 메시지 구조: https://mavlink.io/en/messages/common.html#GLOBAL_POSITION_INT
        # payload: time_boot_ms (uint32), lat (int32), lon (int32), alt (int32),
        #          relative_alt (int32), vx (int16), vy (int16), vz (int16),
        #          hdg (uint16)
        if self.rx.data[1] == MSG_NUM.GLOBAL_POSITION_INT: # 메시지 ID 확인
            # lat (int32) - bytes 4-7
            self._lat = int.from_bytes(self.rx.data[4:8], byteorder='little', signed=True) / 1e7
            # lon (int32) - bytes 8-11
            self._lon = int.from_bytes(self.rx.data[8:12], byteorder='little', signed=True) / 1e7
            # alt (int32) - bytes 12-15
            self._alt = int.from_bytes(self.rx.data[12:16], byteorder='little', signed=True) / 1e3
            # hdg (uint16) - bytes 28-29
            self._hdg = int.from_bytes(self.rx.data[28:30], byteorder='little', signed=False) / 100.0
            return True
        return False

    # byte 단위로 데이터 받아옴
    def getByte(self):
        try:
            if self.ser is None:
                return 1
            rx_byte = self.ser.read()  # 1바이트씩 읽기

            if self.rx is not None:
                if rx_byte == b'\xFD':  # 0xFD이 나오면
                    self.rx.length = self.__cnt
                    self.__cnt = 0

                    if(self.rx.length>0 and self.rx.checkCRC()):
                        return 0

                self.rx.data[self.__cnt] = byte2int(rx_byte.hex())
                self.__cnt = self.__cnt + 1
        except Exception as e:
            print(e)
            sys.exit(0)


        return 1

    # 한 패킷을 받아서 출력
    def getData(self):
        if(self.getByte() == 0):
            return self.update() # update가 성공하면 True 반환
        return False

    @property
    def lat(self):
        return self._lat

    @property
    def lon(self):
        return self._lon

    @property
    def alt(self):
        return self._alt

    @property
    def hdg(self):
        return self._hdg 
