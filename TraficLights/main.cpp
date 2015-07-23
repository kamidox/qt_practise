#include <QtWidgets>

#define FLASH_TIME 2000
#define FLASH_INTERVAL 200

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
        mTimer.start(FLASH_INTERVAL);
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
        vbox->addWidget(mRed);
        mYellow = new LightWidget(Qt::yellow);
        vbox->addWidget(mYellow);
        mGreen = new LightWidget(Qt::green);
        vbox->addWidget(mGreen);

        QPalette pal = palette();
        pal.setColor(QPalette::Background, Qt::black);
        setPalette(pal);
        setAutoFillBackground(true);

        mTimerValue = 0;
        mTimer.connect(&mTimer, SIGNAL(timeout()), this, SLOT(updateCounter()));
    }

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

/**
 * @brief createLightState create the light state.
 *        Light state have 3 sub states: alwaysOnState -> flashState -> done
 *        alwaysOnState: duration - 2 seconds, the light is always on
 *        flashState: 2 seconds, the light is flashed
 *        done: light is off and the flash is stop
 * @param traficWidget
 * @param lightWidget
 * @param duration
 * @param parent
 * @return the light state
 */
QState *createLightState(TraficLightWidget *traficWidget,
                         LightWidget *lightWidget,
                         int duration,
                         QState *parent = 0)
{
    QState *lightState = new LightState(duration, parent);
    QTimer *timer = new QTimer(lightState);
    timer->setInterval(qMax(duration - FLASH_TIME, 0));
    timer->setSingleShot(true);

    QTimer *flashTimer = new QTimer(lightState);
    flashTimer->setInterval(FLASH_TIME);
    flashTimer->setSingleShot(true);

    QState *alwaysOnState = new QState(lightState);
    alwaysOnState->connect(alwaysOnState, SIGNAL(entered()), timer, SLOT(start()));

    QState *flashState = new QState(lightState);
    flashState->connect(flashState, SIGNAL(entered()), lightWidget, SLOT(startFlash()));
    flashState->connect(flashState, SIGNAL(entered()), flashTimer, SLOT(start()));
    flashState->connect(flashState, SIGNAL(exited()), lightWidget, SLOT(stopFlash()));
    alwaysOnState->addTransition(timer, SIGNAL(timeout()), flashState);

    QFinalState *done = new QFinalState(lightState);
    flashState->addTransition(flashTimer, SIGNAL(timeout()), done);

    lightState->connect(lightState, SIGNAL(entered()), traficWidget, SLOT(startCounter()));
    lightState->connect(lightState, SIGNAL(entered()), lightWidget, SLOT(turnOn()));
    lightState->connect(lightState, SIGNAL(exited()), lightWidget, SLOT(turnOff()));
    lightState->setInitialState(alwaysOnState);

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
        QState *red = createLightState(widget, widget->redLight(), 5000, machine);
        red->setObjectName("red");
#if IN_US
        QState *yellowRed2Green = createLightState(widget, widget->yellowLight(), 3000, machine);
        yellowRed2Green->setObjectName("yellowRed2Green");
        red->addTransition(red, SIGNAL(finished()), yellowRed2Green);
        QState *green = createLightState(widget, widget->greenLight(), 5000, machine);
        green->setObjectName("green");
        yellowRed2Green->addTransition(yellowRed2Green, SIGNAL(finished()), green);
#else
        QState *green = createLightState(widget, widget->greenLight(), 5000, machine);
        green->setObjectName("green");
        red->addTransition(red, SIGNAL(finished()), green);
#endif
        QState *yellowGreen2Red = createLightState(widget, widget->yellowLight(), 3000, machine);
        yellowGreen2Red->setObjectName("yellowGreen2Red");
        green->addTransition(green, SIGNAL(finished()), yellowGreen2Red);
        yellowGreen2Red->addTransition(yellowGreen2Red, SIGNAL(finished()), red);

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
