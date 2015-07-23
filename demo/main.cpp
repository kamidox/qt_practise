#include <QCoreApplication>
#include "counter.h"
#include <QDebug>

int main(int argc, char *argv[])
{
    QCoreApplication app(argc, argv);

#if 0
    Counter a, b;
    QVariant varA("a"), varB("b");
    a.setProperty(PROP_INSTANCE_NAME, varA);
    b.setProperty(PROP_INSTANCE_NAME, varB);

    qDebug() << "signals and slots demo";
    a.connect(&a, &Counter::valueChanged, &b, &Counter::setValue);
    b.connect(&b, &Counter::valueChanged, &a, &Counter::setValue);

    //a.connect(&a, &Counter::valueChanged, &b, &Counter::setValue, Qt::QueuedConnection);
    //b.connect(&b, &Counter::valueChanged, &a, &Counter::setValue, Qt::QueuedConnection);

    qDebug() << "initial state. a=" << a.value() << " b=" << b.value();
    a.setValue(12);
    qDebug() << "after set a to 12. a=" << a.value() << " b=" << b.value();
    b.setValue(48);
    qDebug() << "after set b to 48. a=" << a.value() << " b=" << b.value();
#endif

    QList<QString> list;
    list << "A" << "B" << "C" << "D";
    QList<QString>::const_iterator iter;
    for (iter = list.begin(); iter != list.end(); iter ++)
    {
        qDebug() << *iter;
    }

    QVector<int> a, b;
    a.resize(10000);

    QVector<int>::iterator iterI = a.begin();
    qDebug() << "initial state. *iterI =" << *iterI;

    b = a;  // copy a vector, iter point to the shared memory of a and b - copy on write
    a[0] = 5;   // copy on write
    b[0] = 1;
    qDebug() << "copy on write, now iterI is point to b. a[0] =" << a[0] << " b[0] =" << b[0] << " *iterI =" << *iterI;

    b.clear();
    qDebug() << "after b clear, iterI is undefined. a[0] =" << a[0] << " b[0] =" << b[0] << " b.size =" << b.size() << " *iterI =" << *iterI;
    return app.exec();
}
