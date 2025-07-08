import os
import sys

from PySide6.QtWidgets import QWidget, QVBoxLayout
from PySide6.QtCore import QUrl, QObject, Slot
from PySide6.QtQuickWidgets import QQuickWidget

from .utils import resource_path


class DockableWidget(QWidget):
    """도킹 가능한 위젯 클래스"""

    def __init__(self, title: str, qml_path: str, parent=None):
        super().__init__(parent)
        self.setWindowTitle(title)

        layout = QVBoxLayout(self)

        # QML 위젯을 포함
        self.qml_widget = QQuickWidget()
        self.qml_widget.setSource(QUrl.fromLocalFile(resource_path(qml_path)))
        self.qml_widget.setResizeMode(QQuickWidget.SizeRootObjectToView)

        layout.addWidget(self.qml_widget)


class DockManager(QObject):
    """도크 위젯 관리자 - QML과 Python 간의 통신을 담당"""

    def __init__(self, main_window, parent=None):
        super().__init__(parent)
        self.main_window = main_window

    @Slot(str)
    def toggle_dock_area(self, page_name):
        """페이지에 따라 도크 영역 토글"""
        if page_name == "FLIGHT":
            # MainPanel이면 도크 영역 보이기
            if not self.main_window.dock_area_visible:
                self.main_window.toggle_dock_area()
        else:
            # 다른 페이지면 도크 영역 숨기기
            if self.main_window.dock_area_visible:
                self.main_window.toggle_dock_area()
