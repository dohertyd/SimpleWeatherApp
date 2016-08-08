//
//  WeatherCD+CoreDataProperties.h
//  SimpleWeather
//
//  Created by Derek Doherty on 29/12/2015.
//  Copyright © 2015 Derek Doherty. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "WeatherCD.h"

NS_ASSUME_NONNULL_BEGIN

@interface WeatherCD (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *condition;
@property (nullable, nonatomic, retain) NSString *icon;
@property (nullable, nonatomic, retain) NSString *weather_description;
@property (nullable, nonatomic, retain) NSNumber *weather_id;
@property (nullable, nonatomic, retain) Condition *weatherCondition;
@property (nullable, nonatomic, retain) NSManagedObject *dailyForecast;

@end

NS_ASSUME_NONNULL_END
