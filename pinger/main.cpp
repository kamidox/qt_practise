#include <QtCore>

class PingEvent : public QEvent
{
public:
    PingEvent() : QEvent(QEvent::Type(QEvent::User + 2)) {}
};

class PongEvent : public QEvent
{
public:
    PongEvent() : QEvent(QEvent::Type(QEvent::User + 3)) {}
};

class PongTransition : public QAbstractTransition
{
public:
    PongTransition() {}

protected:
    virtual bool eventTest(QEvent *event) Q_DECL_OVERRIDE {
        return (event->type() == QEvent::User + 3);
    }

    virtual void onTransition(QEvent *) Q_DECL_OVERRIDE {
        machine()->postDelayedEvent(new PingEvent(), 500);
        qInfo() << "ping";
    }
};

class PingTransition : public QAbstractTransition
{
public:
    PingTransition() {}

protected:
    virtual bool eventTest(QEvent *event) Q_DECL_OVERRIDE {
        return (event->type() == QEvent::User + 2);
    }

    virtual void onTransition(QEvent *) Q_DECL_OVERRIDE {
        machine()->postDelayedEvent(new PongEvent(), 500);
        qInfo() << "pong";
    }
};

class Pinger : public QState
{
public:
    Pinger(QState *parent) : QState(parent) {}

protected:
    virtual void onEntry(QEvent *) Q_DECL_OVERRIDE {
        machine()->postEvent(new PingEvent());
        qInfo() << "ping";
    }
};

int main(int argc, char **argv)
{
    QCoreApplication app(argc, argv);

    QStateMachine machine;
    QState *group = new QState(QState::ParallelStates);
    group->setObjectName("group");

    QState *pinger = new Pinger(group);
    pinger->setObjectName("pinger");
    pinger->addTransition(new PongTransition());

    QState *ponger = new QState(group);
    ponger->setObjectName("ponger");
    ponger->addTransition(new PingTransition());

    machine.addState(group);
    machine.setInitialState(group);
    machine.start();

    return app.exec();
}
