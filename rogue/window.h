#ifndef WINDOW_H
#define WINDOW_H

#include <QtWidgets>

#define WIDTH 35
#define HEIGHT 20

class Window : public QWidget
{
    Q_OBJECT
    Q_PROPERTY(QString status READ status WRITE setStatus)

public:
    enum Direction {Up, Down, Left, Right};

    Window();

    QSize sizeHint() const Q_DECL_OVERRIDE;

    QString status() const;
    void setStatus(const QString &status);

    void movePlayer(Direction dir);

protected:
    virtual void paintEvent(QPaintEvent *) Q_DECL_OVERRIDE;

private:
    void setupFont();
    void setupMap();
    void buildMachine();

private:
    QString mStatus;
    int mX, mY;
    QChar map[WIDTH][HEIGHT];
    QStateMachine *machine;\
};

#endif // WINDOW_H

