#include "hkmanager.h"
#include <QDebug>
#import <HealthKit/HealthKit.h>

HKManager::HKManager()
{
    m_healthStore = [[HKHealthStore alloc] init];
}

void HKManager::requestAuthorization()
{
    NSMutableArray *readTypes = [NSMutableArray new];
    if(m_readBirthDate) [readTypes addObject:[HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierDateOfBirth]];
    if(m_readHeartRate) [readTypes addObject:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate]];
    // [[HealthKitManagerOC sharedManager] requestAuthorizationWithReadTypes: readTypes];

    if ([HKHealthStore isHealthDataAvailable] == NO) {
        // If our device doesn't support HealthKit -> return.
        return;
    }

    NSArray *writeTypes = @[[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass],
                            [HKObjectType workoutType]];

    [m_healthStore requestAuthorizationToShareTypes:[NSSet setWithArray:writeTypes]
                                             readTypes:[NSSet setWithArray:readTypes] completion:nil];
}

void HKManager::getBirthDate()
{
//    NSDate *birthDate = [[HealthKitManagerOC sharedManager] readBirthDate];
//    double timestamp = [birthDate timeIntervalSince1970];
//    qint64 timestampMS = 1000*timestamp;
//    QDateTime birthDateQt = QDateTime::fromMSecsSinceEpoch(timestampMS);
    //    // return birthDateQt;
}

void HKManager::getHeartRate()
{
    qDebug() << "Getting heart rate...";
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay
                                               fromDate:now];
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    components.day = 1;
    components.month = 1;
    components.year = 2010;
    // NSDate *beginOfTime = [calendar dateFromComponents:components];
    NSDate *beginOfTime = [NSDate dateWithTimeIntervalSince1970:0];
    // beginOfTime = [NSDate dateWithTimeIntervalSinceNow:-86400];

    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:beginOfTime endDate:now options:HKQueryOptionStrictStartDate];
    qDebug() << "Predicate ready";
    HKSampleQuery *sampleQuery = [[HKSampleQuery alloc] initWithSampleType:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate] predicate:predicate limit:0 sortDescriptors:nil resultsHandler:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {
        qDebug() << "Query finished after " << m_timer.restart()/1000. << " seconds, looping through " << results.count << " things";

        for (HKQuantitySample *sample in results) {
            HKUnit *unit = [[HKUnit countUnit] unitDividedByUnit:[HKUnit minuteUnit]];
            NSDate *date = sample.startDate;
            float unixTimestamp = date.timeIntervalSince1970;
            float value = [sample.quantity doubleValueForUnit:unit];
            QPair<QDateTime, float> point(QDateTime::fromMSecsSinceEpoch(1000*unixTimestamp), value);
            m_heartRate.push_back(point);
            qDebug() << "Heart rate: " << value;
        }

        qDebug() << "Done after " << m_timer.elapsed()/1000. << " seconds.";
//        for(auto p : m_heartRate) {
//            qDebug() << p;
//        }
    }];

    qDebug() << "Executing query";
    m_timer.start();
    [m_healthStore executeQuery:sampleQuery];
}

bool HKManager::readHeartRate() const
{
    return m_readHeartRate;
}

bool HKManager::readBirthDate() const
{
    return m_readBirthDate;
}

void HKManager::setReadHeartRate(bool readHeartRate)
{
    if (m_readHeartRate == readHeartRate)
        return;

    m_readHeartRate = readHeartRate;
    emit readHeartRateChanged(readHeartRate);
}

void HKManager::setReadBirthDate(bool readBirthDate)
{
    if (m_readBirthDate == readBirthDate)
        return;

    m_readBirthDate = readBirthDate;
    emit readBirthDateChanged(readBirthDate);
}
