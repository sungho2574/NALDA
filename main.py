import os
import sys

from src.modules.backend import *

from PySide6.QtGui import QGuiApplication, QFontDatabase, QFont
from PySide6.QtQml import QQmlApplicationEngine


def resource_path(relative_path: str) -> str:
    """ Get absolute path to resource, works for dev and for PyInstaller """
    base_path = getattr(sys, '_MEIPASS', os.path.dirname(os.path.abspath(__file__)))
    return os.path.join(base_path, relative_path)


if __name__ == "__main__":
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()

    # 폰트 로드
    font_path = resource_path("src/assets/fonts/PretendardVariable.ttf")
    font_id = QFontDatabase.addApplicationFont(font_path)
    if font_id != -1:
        family = QFontDatabase.applicationFontFamilies(font_id)[0]
        app.setFont(QFont(family))
    else:
        print("Pretendard 폰트 로드 실패")
        sys.exit(-1)

    # Backend 인스턴스 생성
    backend = InitializePortSelect()

    # Backend 인스턴스를 "backend"라는 이름으로 QML의 전역 컨텍스트 속성에 등록
    engine.rootContext().setContextProperty("initializePortSelect", backend)

    # QML 파일 로드
    engine.load("src/main.qml")

    if not engine.rootObjects():
        sys.exit(-1)

    backend.initialize_list()

    sys.exit(app.exec())
