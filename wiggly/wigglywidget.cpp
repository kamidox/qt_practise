#include "wigglywidget.h"
#include <QtWidgets>

WigglyWidget::WigglyWidget(QWidget *parent) : QWidget(parent)
{
    setBackgroundRole(QPalette::Midlight);
    setAutoFillBackground(true);

    QFont newFont = font();
    newFont.setPointSize(newFont.pointSize() + 20);
    setFont(newFont);

    mStep = 0;
    mTimer.start(60, this);
}

void WigglyWidget::paintEvent(QPaintEvent */* e */)
{
    static const int sineTable[16] = {
            0, 38, 71, 92, 100, 92, 71, 38, 0, -38, -71, -92, -100, -92, -71, -38
        };

    QFontMetrics metrics(font());
    int x = (width() - metrics.width(mText)) / 2;
    int y = (height() + metrics.ascent() - metrics.descent()) / 2;
    QColor color;

    QPainter painter(this);
    for (int i = 0; i < mText.size(); ++i) {
        int index = (mStep + i) % 16;
        color.setHsv((15 - index) * 16, 255, 191);
        painter.setPen(color);
        painter.drawText(x, y - ((sineTable[index] * metrics.height()) / 400), QString(mText[i]));
        x += metrics.width(mText[i]);
    }
}

void WigglyWidget::timerEvent(QTimerEvent *e)
{
    if (e->timerId() == mTimer.timerId()) {
        ++ mStep;
        update();
    } else {
        QWidget::timerEvent(e);
    }
}
