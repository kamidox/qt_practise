#include <QCoreApplication>
#include <QtCore>

class Factorial : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int x READ x WRITE setX)
    Q_PROPERTY(int fac READ fac WRITE setFac)

public:
    Factorial(QObject *parent = 0)
        : QObject(parent), mX(-1), mFac(1)
    {}

    int x() const
    {
        return mX;
    }

    void setX(int x)
    {
        if (mX == x) {
            return;
        }
        mX = x;
        emit xChanged(x);
    }

    int fac() const
    {
        return mFac;
    }

    void setFac(int fac)
    {
        mFac = fac;
    }

Q_SIGNALS:
    void xChanged(int x);

private:
    int mX;
    int mFac;
};

class FacLoopTransition : public QSignalTransition
{
public:
    FacLoopTransition(Factorial *fac)
        : QSignalTransition(fac, SIGNAL(xChanged(int))),
          mFac(fac)
    {}

    virtual bool eventTest(QEvent *event) Q_DECL_OVERRIDE
    {
        if (!QSignalTransition::eventTest(event)) {
            return false;
        }

        QStateMachine::SignalEvent *se = static_cast<QStateMachine::SignalEvent *>(event);
        return se->arguments().at(0).toInt() > 1;
    }

    virtual void onTransition(QEvent *event) Q_DECL_OVERRIDE
    {
        QStateMachine::SignalEvent *se = static_cast<QStateMachine::SignalEvent *>(event);
        int x = se->arguments().at(0).toInt();
        int fac = mFac->property("fac").toInt();

        qInfo() << " x = " << x << " ; fac = " << fac;

        mFac->setProperty("fac", x * fac);
        mFac->setProperty("x", x - 1);
    }
private:
    Factorial *mFac;
};

class FacDoneTransition : public QSignalTransition
{
public:
    FacDoneTransition(Factorial *fac)
        : QSignalTransition(fac, SIGNAL(xChanged(int))),
          mFac(fac)
    {}

    virtual bool eventTest(QEvent *event) Q_DECL_OVERRIDE
    {
        if (!QSignalTransition::eventTest(event)) {
            return false;
        }

        QStateMachine::SignalEvent *se = static_cast<QStateMachine::SignalEvent *>(event);
        return se->arguments().at(0).toInt() <= 1;
    }

    virtual void onTransition(QEvent *event) Q_DECL_OVERRIDE
    {
        QStateMachine::SignalEvent *se = static_cast<QStateMachine::SignalEvent *>(event);
        int x = se->arguments().at(0).toInt();
        int fac = mFac->property("fac").toInt();

        qInfo() << " x = " << x << " ; result = " << fac;
    }

private:
    Factorial *mFac;
};

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);

    Factorial fac;
    QStateMachine machine;

    QState *compute = new QState(&machine);
    compute->assignProperty(&fac, "fac", 1);
    compute->assignProperty(&fac, "x", 6);
    compute->addTransition(new FacLoopTransition(&fac));

    QFinalState *done = new QFinalState(&machine);
    FacDoneTransition *doneTrans = new FacDoneTransition(&fac);
    doneTrans->setTargetState(done);
    compute->addTransition(doneTrans);

    machine.setInitialState(compute);
    QObject::connect(&machine, SIGNAL(finished()), &a, SLOT(quit()));
    machine.start();

    return a.exec();
}

#include "main.moc"
