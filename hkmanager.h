#ifndef HEALTHMANAGER_H
#define HEALTHMANAGER_H

#include <QObject>
#include <QDateTime>
#include <QVector>
#include <QPair>
#include <QElapsedTimer>

class HKManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool readHeartRate READ readHeartRate WRITE setReadHeartRate NOTIFY readHeartRateChanged)
    Q_PROPERTY(bool readBirthDate READ readBirthDate WRITE setReadBirthDate NOTIFY readBirthDateChanged)
    void *m_healthStore = nullptr;
    bool m_readHeartRate = false;
    bool m_readBirthDate = false;
    QVector<QPair<QDateTime, float>> m_heartRate;
    QElapsedTimer m_timer;
public:
    HKManager();
    Q_INVOKABLE void requestAuthorization();
    Q_INVOKABLE void getBirthDate();
    Q_INVOKABLE void getHeartRate();
    bool readHeartRate() const;
    bool readBirthDate() const;

public slots:
    void setReadHeartRate(bool readHeartRate);
    void setReadBirthDate(bool readBirthDate);

signals:
    void readHeartRateChanged(bool readHeartRate);
    void readBirthDateChanged(bool readBirthDate);
};

#endif // HEALTHMANAGER_H
