#-------------------------------------------------
#
# Project created by QtCreator 2015-07-16T09:20:03
#
#-------------------------------------------------

QT       += core gui

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = TextEditor
TEMPLATE = app


SOURCES += main.cpp\
        texteditor.cpp

HEADERS  += texteditor.h

FORMS    += texteditor.ui

RESOURCES += \
    texteditor.qrc

TRANSLATIONS = texteditor_zh.ts

DISTFILES += \
    TextEditor.supp
