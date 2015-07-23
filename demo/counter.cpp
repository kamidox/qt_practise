#include "counter.h"
#include <QDebug>

void Counter::setValue(int value) {
    QString instanceName = property(PROP_INSTANCE_NAME).toString();
    qDebug() << "[" << instanceName << "] Counter::setValue() value=" << value << " m_value=" << m_value;
    if (value != m_value) {
        m_value = value;
        qDebug() << "[" << instanceName << "] Counter::setValue() before emit signal valueChanged";
        emit valueChanged(value);
        qDebug() << "[" << instanceName << "] Counter::setValue() after emit signal valueChanged";
    }
}


