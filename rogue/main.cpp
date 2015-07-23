#include <QtWidgets>

#include "window.h"
#include "movementtransition.h"

Window::Window()
{
    mX = 5, mY = 5;

    setupFont();
    setupMap();
    buildMachine();
}

QSize Window::sizeHint() const Q_DECL_OVERRIDE {
    QFontMetrics metrics(font());
    return QSize(metrics.width('X') * WIDTH, metrics.height() * (HEIGHT + 1));
}

QString Window::status() const { return mStatus; }
void Window::setStatus(const QString &status) {
    mStatus = status;
    this->repaint();
}

void Window::movePlayer(Direction dir) {
    switch (dir) {
    case Left:
        if (map[mX - 1][mY] != '#') {
            --mX;
        }
        break;
    case Right:
        if (map[mX + 1][mY] != '#') {
            ++mX;
        }
        break;
    case Up:
        if (map[mX][mY - 1] != '#') {
            --mY;
        }
        break;
    case Down:
        if (map[mX][mY + 1] != '#') {
            ++mY;
        }
        break;
    }
    this->repaint();
}

void Window::paintEvent(QPaintEvent *) Q_DECL_OVERRIDE {
    QFontMetrics m(font());
    QPainter painter(this);
    int fontH = m.height();
    int fontW = m.width('X');
    int yPos = fontH;
    int xPos = 0;

    painter.fillRect(rect(), Qt::black);
    painter.setPen(Qt::white);

    painter.drawText(QPoint(0, yPos), status());

    for (int y = 0; y < HEIGHT; ++ y) {
        yPos += fontH;
        xPos = 0;
        for (int x = 0; x < WIDTH; ++ x) {
            if (y == mY && x == mX) {
                xPos += fontW;
                continue;
            }

            painter.setPen(Qt::white);
            painter.drawText(QPoint(xPos, yPos), map[x][y]);
            xPos += fontW;
        }
    }

    painter.setPen(Qt::yellow);
    painter.drawText(QPoint(mX * fontW, (mY + 2) * fontH), QChar('@'));
}


void Window::setupFont() {
    QFontDatabase db;
    QFont font;

    if (db.families().contains("Monospace")) {
        font = QFont("Monospace");
    } else {
        foreach (QString family, db.families()) {
            if (db.isFixedPitch(family)) {
                font = QFont(family);
                break;
            }
        }
    }
    font.setPixelSize(12);
    setFont(font);
}

void Window::setupMap() {
    qsrand(QTime(0, 0, 0).secsTo(QTime::currentTime()));

    for (int x = 0; x < WIDTH; ++x) {
        for (int y = 0; y < HEIGHT; ++ y) {
            if (x == 0 || x == WIDTH - 1 || y == 0 || y == HEIGHT - 1 || qrand() % 10 == 0) {
                map[x][y] = '#';
            } else {
                map[x][y] = '.';
            }
        }
        map[mX][mY] = '.';
    }
}

void Window::buildMachine() {
    machine = new QStateMachine();
    QState *inputState = new QState(machine);
    inputState->assignProperty(this, "status", "Move the rogue with 2, 4, 6, 8");

    MovementTransition *move = new MovementTransition(this);
    inputState->addTransition(move);

    QState *quitState = new QState(machine);
    quitState->assignProperty(this, "status", "Really quit(y/n)?");

    QKeyEventTransition *yes = new QKeyEventTransition(this, QEvent::KeyPress, Qt::Key_Y);
    yes->setTargetState(new QFinalState(machine));
    quitState->addTransition(yes);

    QKeyEventTransition *no = new QKeyEventTransition(this, QEvent::KeyPress, Qt::Key_N);
    no->setTargetState(inputState);
    quitState->addTransition(no);

    QKeyEventTransition *quit = new QKeyEventTransition(this, QEvent::KeyPress, Qt::Key_Q);
    quit->setTargetState(quitState);
    inputState->addTransition(quit);

    machine->setInitialState(inputState);
    connect(machine, SIGNAL(finished()), qApp, SLOT(quit()));
    machine->start();
}


int main(int argc, char **argv) {
    QApplication app(argc, argv);

    Window w;
    w.move(600, 400);
    w.show();

    return app.exec();
}
