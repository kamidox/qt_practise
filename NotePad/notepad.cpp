#include "notepad.h"
#include "ui_notepad.h"

#include <QFileDialog>
#include <QMessageBox>
#include <QTextStream>

NotePad::NotePad(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::NotePad)
{
    ui->setupUi(this);
}

NotePad::~NotePad()
{
    delete ui;
}

void NotePad::on_quitButton_clicked()
{
    qApp->quit();
}

void NotePad::on_actionOpen_triggered()
{
    QString fileName = QFileDialog::getOpenFileName(this, tr("Open file"), QString(),
                                                    tr("All Files (*);;Text Files (*.txt);;C++ Files (*.cpp *.h)"));

    if (!fileName.isEmpty()) {
        QFile file(fileName);
        if (!file.open(QIODevice::ReadOnly)) {
            QMessageBox::critical(this, tr("Error"), tr("Cannot open file"));
            return;
        }

        QTextStream in(&file);
        QString text = in.readAll();
        file.close();
        ui->textEdit->setText(text);
    }
}

void NotePad::on_actionSave_triggered()
{
    QString fileName = QFileDialog::getSaveFileName(this, tr("Save file"), QString(),
                                                    tr("All Files (*);;Text Files(*.txt);;C++ Files(*.cpp *.h)"));
    if (!fileName.isEmpty()) {
        QFile file(fileName);
        if (!file.open(QIODevice::WriteOnly)) {
            QMessageBox::critical(this, tr("Error"), tr("Cannot write file"));
            return;
        }

        QTextStream out(&file);
        out << ui->textEdit->toPlainText();
        out.flush();
        file.close();
    }
}
