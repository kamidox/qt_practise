#include <QtWidgets>

class LightWidget : public QWidget
{
    Q_OBJECT
    Q_PROPERTY(bool on READ isOn WRITE setOn)

public:
    LightWidget(const QColor &color, QWidget *parent = 0)
        : QWidget(parent), mColor(color), mOn(false)
    {
        mTimer.connect(&mTimer, SIGNAL(timeout()), this, SLOT(flash()));
    }

    bool isOn() { return mOn; }
    void setOn(bool on) {
        if (on == mOn) {
            return;
        }
        mOn = on;
        update();
    }

public slots:
    void turnOff() { setOn(false); }
    void turnOn() { setOn(true); }

    void startFlash() {
        if (!mOn) {
            return;
        }
        flash();
        mTimer.start(500);
    }

    void stopFlash() {
        mTimer.stop();
    }

private slots:
    void flash() {
        if (mOn) {
            turnOff();
        } else {
            turnOn();
        }
    }

protected:
    virtual void paintEvent(QPaintEvent *) Q_DECL_OVERRIDE {
        if (!mOn) {
            return;
        }

        QPainter painter(this);
        painter.setRenderHint(QPainter::Antialiasing);
        painter.setBrush(mColor);
        painter.drawEllipse(0, 0, width(), height());
    }

private:
    QTimer mTimer;
    QColor mColor;
    bool mOn;
};

class TraficLightWidget : public QWidget
{
    Q_OBJECT

public:
    TraficLightWidget(QWidget *parent = 0)
        : QWidget(parent)
    {
        QVBoxLayout *vbox = new QVBoxLayout(this);
        mTimerLabel = new QLabel();
        mTimerLabel->setAlignment(Qt::AlignCenter);
        vbox->addWidget(mTimerLabel);
        mRed = new LightWidget(Qt::red);
        connect(this, SIGNAL(startFlash()), mRed, SLOT(startFlash()));
        vbox->addWidget(mRed);
        mYellow = new LightWidget(Qt::yellow);
        connect(this, SIGNAL(startFlash()), mYellow, SLOT(startFlash()));
        vbox->addWidget(mYellow);
        mGreen = new LightWidget(Qt::green);
        connect(this, SIGNAL(startFlash()), mGreen, SLOT(startFlash()));
        vbox->addWidget(mGreen);

        QPalette pal = palette();
        pal.setColor(QPalette::Background, Qt::black);
        setPalette(pal);
        setAutoFillBackground(true);

        mTimerValue = 0;
        mTimer.connect(&mTimer, SIGNAL(timeout()), this, SLOT(updateCounter()));
    }

signals:
    void startFlash();

public slots:
    void startCounter() {
        int duration = sender()->property("duration").toInt();
        mTimerValue = duration / 1000;
        mTimer.start(1000);
        updateCounter();
    }

private slots:
    void updateCounter() {
        QString text("<font color=red size=20><b>%1</b></font>");
        mTimerLabel->setText(text.arg(mTimerValue));

        if (mTimerValue <= 3) {
            emit startFlash();
        }
        mTimerValue -= 1;
    }

public:
    QLabel *timerLabel() const { return mTimerLabel; }
    LightWidget *redLight() const { return mRed; }
    LightWidget *yellowLight() const { return mYellow; }
    LightWidget *greenLight() const { return mGreen; }

private:
    QLabel *mTimerLabel;
    QTimer mTimer;
    int mTimerValue;

    LightWidget *mRed;
    LightWidget *mYellow;
    LightWidget *mGreen;
};

class LightState : public QState
{
    Q_OBJECT
    Q_PROPERTY(int duration READ duration WRITE setDuration)

public:
    LightState(int duration, QState *parent = 0)
        : QState(parent), mDuration(duration) {}

    int duration() { return mDuration; }
    void setDuration(int duration) { mDuration = duration; }

private:
    int mDuration;
};

QState *createLightState(TraficLightWidget *traficWidget,
                         LightWidget *lightWidget,
                         int duration,
                         QState *parent = 0)
{
    QState *lightState = new LightState(duration, parent);
    QTimer *timer = new QTimer(lightState);
    timer->setInterval(duration);
    timer->setSingleShot(true);

    QState *timingState = new QState(lightState);
    timingState->connect(timingState, SIGNAL(entered()), lightWidget, SLOT(turnOn()));
    timingState->connect(timingState, SIGNAL(entered()), timer, SLOT(start()));
    timingState->connect(timingState, SIGNAL(exited()), lightWidget, SLOT(turnOff()));
    timingState->connect(timingState, SIGNAL(exited()), lightWidget, SLOT(stopFlash()));

    QFinalState *done = new QFinalState(lightState);
    timingState->addTransition(timer, SIGNAL(timeout()), done);

    lightState->connect(lightState, SIGNAL(entered()), traficWidget, SLOT(startCounter()));
    lightState->setInitialState(timingState);

    return lightState;
}

class TraficLight : public QWidget
{
public:
    TraficLight(QWidget *parent = 0)
        : QWidget(parent)
    {
        QVBoxLayout *vbox = new QVBoxLayout(this);
        TraficLightWidget *widget = new TraficLightWidget();
        vbox->addWidget(widget);
        vbox->setMargin(0);

        QStateMachine *machine = new QStateMachine(this);
        QState *red = createLightState(widget, widget->redLight(), 8000);
        red->setObjectName("red");
        QState *yellowRed2Green = createLightState(widget, widget->yellowLight(), 3000);
        yellowRed2Green->setObjectName("yellowRed2Green");
        red->addTransition(red, SIGNAL(finished()), yellowRed2Green);
        QState *green = createLightState(widget, widget->greenLight(), 8000);
        green->setObjectName("green");
        yellowRed2Green->addTransition(yellowRed2Green, SIGNAL(finished()), green);
        QState *yellowGreen2Red = createLightState(widget, widget->yellowLight(), 3000);
        yellowGreen2Red->setObjectName("yellowGreen2Red");
        green->addTransition(green, SIGNAL(finished()), yellowGreen2Red);
        yellowGreen2Red->addTransition(yellowGreen2Red, SIGNAL(finished()), red);

        machine->addState(red);
        machine->addState(yellowRed2Green);
        machine->addState(green);
        machine->addState(yellowGreen2Red);
        machine->setInitialState(red);
        machine->start();
    }
};

int main(int argc, char **argv)
{
    QApplication app(argc, argv);

    TraficLight widget;
    widget.move(500, 400);
    widget.resize(110, 400);
    widget.show();

    return app.exec();
}

#include "main.moc"
