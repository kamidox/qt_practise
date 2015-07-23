#include <QCoreApplication>
#include <QRunnable>
#include <QThreadPool>
#include <QDebug>

class HelloWorldTask : public QRunnable
{
    void run() {
        qDebug() << "hello world from thread" << QThread::currentThread();
    }
};

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);

    // demo of QRunnable
    HelloWorldTask *task = new HelloWorldTask();
    HelloWorldTask task2;
    QThreadPool::globalInstance()->start(task);
    task2.setAutoDelete(false);
    QThreadPool::globalInstance()->start(&task2);

    return a.exec();
}
