#include "dialog.h"
#include <QtWidgets>
#include "wigglywidget.h"

Dialog::Dialog(QWidget *parent)
    : QDialog(parent)
{
    WigglyWidget *wiggly = new WigglyWidget;
    QLineEdit *edit = new QLineEdit;

    QVBoxLayout *vbox = new QVBoxLayout(this);
    vbox->addWidget(wiggly);
    vbox->addWidget(edit);
    edit->connect(edit, SIGNAL(textChanged(QString)), wiggly, SLOT(setText(QString)));

    edit->setText(tr("hello world!"));
    setWindowTitle("wiggly");
    move(600, 400);
    resize(360, 145);
}

