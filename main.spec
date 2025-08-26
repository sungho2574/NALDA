# -*- mode: python ; coding: utf-8 -*-

# 소스 파일 포함
datas = [
    ('backend', 'backend'),
    ('src', 'src'),
    ('windows', 'windows'),
]

a = Analysis(
    ['main.py'],
    pathex=[],
    binaries=[],
    datas=datas,
    hiddenimports=[],
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[],
    noarchive=False,
    optimize=0,
)
pyz = PYZ(a.pure)

exe = EXE(
    pyz,
    a.scripts,
    a.binaries,
    a.datas,
    [],
    name='NALDA',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    upx_exclude=[],
    runtime_tmpdir=None,
    # console=False,
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
    icon=['src/assets/app.ico'],
)
app = BUNDLE(
    exe,
    name='NALDA.app',
    icon='src/assets/app.ico',
    bundle_identifier=None,
)
