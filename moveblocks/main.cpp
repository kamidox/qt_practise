#include <QtCore>
#include <QtWidgets>

class StateSwitchEvent : public QEvent
{
public:
    StateSwitchEvent(int rand)
        : QEvent(Type(StateSwitchType)), mRand(rand) {}

    enum { StateSwitchType = QEvent::User + 200 };

    int rand() const { return mRand; }

private:
    int mRand;
};


class RectGraphicsWidget : public QGraphicsWidget
{
public:
    void paint(QPainter * painter,
               const QStyleOptionGraphicsItem *,
               QWidget *) Q_DECL_OVERRIDE {

        painter->fillRect(rect(), Qt::yellow);
    }
};

class StateSwitchTransition : public QAbstractTransition
{
public:
    StateSwitchTransition(int rand) : QAbstractTransition(), mRand(rand) {}

protected:
    bool eventTest(QEvent *event) Q_DECL_OVERRIDE {
        return (event->type() == QEvent::Type(StateSwitchEvent::StateSwitchType)
                && static_cast<StateSwitchEvent *>(event)->rand() == mRand);
    }

    void onTransition(QEvent *) Q_DECL_OVERRIDE {}

private:
    int mRand;
};

class StateSwitcher : public QState
{
public:
    StateSwitcher(QStateMachine *machine)
        : QState(machine), mStateCount(0), mLastIndex(0) {}

    void onEntry(QEvent *) Q_DECL_OVERRIDE {
        int n;
        /* find the index of next un-duplicate state */
        while ((n = (qrand() % mStateCount + 1)) == mLastIndex) {}
        mLastIndex = n;
        machine()->postEvent(new StateSwitchEvent(n));
    }

    void addState(QState *state, QAbstractAnimation *anim) {
        StateSwitchTransition *trans = new StateSwitchTransition(++mStateCount);
        trans->setTargetState(state);
        addTransition(trans);
        trans->addAnimation(anim);
    }

private:
    int mStateCount;
    int mLastIndex;
};

QState *createGeometryState(QObject *w1, const QRect &r1,
                            QObject *w2, const QRect &r2,
                            QObject *w3, const QRect &r3,
                            QObject *w4, const QRect &r4,
                            QState *parent) {
    QState *s = new QState(parent);
    s->assignProperty(w1, "geometry", r1);
    s->assignProperty(w2, "geometry", r2);
    s->assignProperty(w3, "geometry", r3);
    s->assignProperty(w4, "geometry", r4);

    return s;
}

QAbstractAnimation *createAnimation(QGraphicsWidget *w1,
                                    QGraphicsWidget *w2,
                                    QGraphicsWidget *w3,
                                    QGraphicsWidget *w4)
{
    QParallelAnimationGroup *animGroup = new QParallelAnimationGroup;
    QSequentialAnimationGroup *subGroup;
    QPropertyAnimation *anim;

    anim = new QPropertyAnimation(w4, "geometry");
    anim->setDuration(1000);
    anim->setEasingCurve(QEasingCurve::OutElastic);
    animGroup->addAnimation(anim);

    subGroup = new QSequentialAnimationGroup(animGroup);
    subGroup->addPause(100);
    anim = new QPropertyAnimation(w3, "geometry");
    anim->setDuration(1000);
    anim->setEasingCurve(QEasingCurve::OutElastic);
    subGroup->addAnimation(anim);

    subGroup = new QSequentialAnimationGroup(animGroup);
    subGroup->addPause(150);
    anim = new QPropertyAnimation(w2, "geometry");
    anim->setDuration(1000);
    anim->setEasingCurve(QEasingCurve::OutElastic);
    subGroup->addAnimation(anim);

    subGroup = new QSequentialAnimationGroup(animGroup);
    subGroup->addPause(200);
    anim = new QPropertyAnimation(w1, "geometry");
    anim->setDuration(1000);
    anim->setEasingCurve(QEasingCurve::OutElastic);
    subGroup->addAnimation(anim);

    return animGroup;
}

class GraphicsView : public QGraphicsView
{
public:
    GraphicsView(QGraphicsScene *scene, QWidget *parent = 0) : QGraphicsView(scene, parent) {}

protected:
    void resizeEvent(QResizeEvent *e) Q_DECL_OVERRIDE {
        fitInView(scene()->sceneRect());
        QGraphicsView::resizeEvent(e);
    }
};

int main(int argc, char **argv)
{
    QApplication app(argc, argv);

    RectGraphicsWidget *w1 = new RectGraphicsWidget;
    RectGraphicsWidget *w2 = new RectGraphicsWidget;
    RectGraphicsWidget *w3 = new RectGraphicsWidget;
    RectGraphicsWidget *w4 = new RectGraphicsWidget;
    w2->setZValue(1);
    w3->setZValue(2);
    w4->setZValue(3);

    QGraphicsScene scene(0, 0, 300, 300);
    scene.setBackgroundBrush(Qt::black);
    scene.addItem(w1);
    scene.addItem(w2);
    scene.addItem(w3);
    scene.addItem(w4);

    GraphicsView w(&scene);
    w.setFrameStyle(0);
    w.setAlignment(Qt::AlignLeft | Qt::AlignTop);
    w.setHorizontalScrollBarPolicy(Qt::ScrollBarAlwaysOff);
    w.setVerticalScrollBarPolicy(Qt::ScrollBarAlwaysOff);

    QStateMachine machine;
    QState *group = new QState();
    QTimer timer;
    timer.setInterval(1250);
    timer.setSingleShot(true);
    QObject::connect(group, SIGNAL(entered()), &timer, SLOT(start()));

    QRect rects[][4] = {
        { QRect(100, 0, 50, 50), QRect(150, 0, 50, 50), QRect(200, 0, 50, 50), QRect(250, 0, 50, 50) },
        { QRect(250, 100, 50, 50), QRect(250, 150, 50, 50), QRect(250, 200, 50, 50), QRect(250, 250, 50, 50) },
        { QRect(150, 250, 50, 50), QRect(100, 250, 50, 50), QRect(50, 250, 50, 50), QRect(0, 250, 50, 50) },
        { QRect(0, 150, 50, 50), QRect(0, 100, 50, 50), QRect(0, 50, 50, 50), QRect(0, 0, 50, 50) },
        { QRect(100, 100, 50, 50), QRect(150, 100, 50, 50), QRect(100, 150, 50, 50), QRect(150, 150, 50, 50) },
        { QRect(50, 50, 50, 50), QRect(200, 50, 50, 50), QRect(50, 200, 50, 50), QRect(200, 200, 50, 50) },
        { QRect(0, 0, 50, 50), QRect(250, 0, 50, 50), QRect(0, 250, 50, 50), QRect(250, 250, 50, 50) },
    };

    StateSwitcher *switcher = new StateSwitcher(&machine);
    group->addTransition(&timer, SIGNAL(timeout()), switcher);
    QAbstractAnimation *anim = createAnimation(w1, w2, w3, w4);

    int cnt = (int)(sizeof(rects) / sizeof(rects[0]));
    for (int i = 0; i < cnt; ++i) {
        QState *s = createGeometryState(w1, rects[i][0],
                                        w2, rects[i][1],
                                        w3, rects[i][2],
                                        w4, rects[i][3], group);
        if (i == 0) {
            group->setInitialState(s);
        }
        switcher->addState(s, anim);
    }
    machine.addState(group);
    machine.setInitialState(group);
    machine.start();

    w.resize(300, 300);
    w.move(500, 400);
    w.show();

    qsrand(QTime(0, 0, 0).secsTo(QTime::currentTime()));

    return app.exec();
}
