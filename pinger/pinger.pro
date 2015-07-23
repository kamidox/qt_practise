QT = core
win32: CONFIG += console
mac:CONFIG -= app_bundle

# install
target.path = $$[QT_INSTALL_EXAMPLES]/widgets/statemachine/pingpong
INSTALLS += target

SOURCES += \
    main.cpp
