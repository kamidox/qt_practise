#include <QtWidgets>

int main(int argc, char **argv)
{
    QApplication app(argc, argv);

    QPushButton btn;
    QStateMachine m;

    QState *off = new QState();
    off->assignProperty(&btn, "text", "Off");
    off->setObjectName("off");

    QState *on = new QState();
    on->assignProperty(&btn, "text", "On");
    on->setObjectName("on");

    off->addTransition(&btn, SIGNAL(clicked()), on);
    on->addTransition(&btn, SIGNAL(clicked()), off);

    m.addState(off);
    m.addState(on);
    m.setInitialState(on);
    m.start();

    btn.move(500, 400);
    btn.resize(400, 200);
    btn.show();

    return app.exec();
}
