#ifndef WIGGLYWIDGET_H
#define WIGGLYWIDGET_H

#include <QWidget>
#include <QBasicTimer>

class WigglyWidget : public QWidget
{
    Q_OBJECT
public:
    explicit WigglyWidget(QWidget *parent = 0);

public slots:
    void setText(const QString &newText) {
        mText = newText;
    }

protected:
    void paintEvent(QPaintEvent *e) Q_DECL_OVERRIDE;
    void timerEvent(QTimerEvent *e) Q_DECL_OVERRIDE;

private:
    QBasicTimer mTimer;
    QString mText;
    int mStep;
};

#endif // WIGGLYWIDGET_H
