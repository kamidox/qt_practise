#include <QtWidgets>

class State : public QState
{
protected:
    virtual void onEntry(QEvent *event) Q_DECL_OVERRIDE
    {
        if (event->type() == QEvent::StateMachineWrapped) {
            QStateMachine::WrappedEvent *we = dynamic_cast<QStateMachine::WrappedEvent *>(event);
            qCritical() << "event: " << we->event()->type();
        } else {
            qInfo() << "event: " << event->type();
        }
        QState::onEntry(event);
    }
};

class Window : public QWidget
{
public:
    Window(QWidget *parent = 0)
        : QWidget(parent)
    {
        QPushButton *button = new QPushButton(this);
        button->setSizePolicy(QSizePolicy::Expanding, QSizePolicy::Expanding);

        QVBoxLayout *layout = new QVBoxLayout;
        layout->addWidget(button);
        layout->setContentsMargins(80, 80, 80, 80);
        setLayout(layout);

        QStateMachine *machine = new QStateMachine(this);

        QState *s1 = new State();
        s1->assignProperty(button, "text", "Outside");

        QState *s2 = new State();
        s2->assignProperty(button, "text", "Inside");

        QEventTransition *enterTrans = new QEventTransition(button, QEvent::Enter);
        enterTrans->setTargetState(s2);
        s1->addTransition(enterTrans);

        QEventTransition *leaveTrans = new QEventTransition(button, QEvent::Leave);
        leaveTrans->setTargetState(s1);
        s2->addTransition(leaveTrans);

        QState *s3 = new State();
        s3->assignProperty(button, "text", "Pressing ...");

        QEventTransition *pressTrans = new QEventTransition(button, QEvent::MouseButtonPress);
        pressTrans->setTargetState(s3);
        s2->addTransition(pressTrans);

        QEventTransition *releaseTrans = new QEventTransition(button, QEvent::MouseButtonRelease);
        releaseTrans->setTargetState(s2);
        s3->addTransition(releaseTrans);

        machine->addState(s1);
        machine->addState(s2);
        machine->addState(s3);

        machine->setInitialState(s1);
        machine->start();
    }
};

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);

    Window w;
    w.move(500, 300);
    w.resize(300, 300);
    w.show();

    return a.exec();
}
