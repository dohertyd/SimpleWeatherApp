//
//  DailyForecast+CoreDataProperties.h
//  SimpleWeather
//
//  Created by Derek Doherty on 29/12/2015.
//  Copyright © 2015 Derek Doherty. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "DailyForecast.h"

NS_ASSUME_NONNULL_BEGIN

@interface DailyForecast (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) NSNumber *humidity;
@property (nullable, nonatomic, retain) NSNumber *sunset;
@property (nullable, nonatomic, retain) NSDate *sunrise;
@property (nullable, nonatomic, retain) NSNumber *temperature;
@property (nullable, nonatomic, retain) NSNumber *tempHigh;
@property (nullable, nonatomic, retain) NSNumber *tempLow;
@property (nullable, nonatomic, retain) NSNumber *windBearing;
@property (nullable, nonatomic, retain) NSNumber *windSpeed;
@property (nullable, nonatomic, retain) NSSet<WeatherCD *> *weathercd;

@end

@interface DailyForecast (CoreDataGeneratedAccessors)

- (void)addWeathercdObject:(WeatherCD *)value;
- (void)removeWeathercdObject:(WeatherCD *)value;
- (void)addWeathercd:(NSSet<WeatherCD *> *)values;
- (void)removeWeathercd:(NSSet<WeatherCD *> *)values;

@end

NS_ASSUME_NONNULL_END
