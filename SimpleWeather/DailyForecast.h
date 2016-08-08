//
//  DailyForecast.h
//  SimpleWeather
//
//  Created by Derek Doherty on 29/12/2015.
//  Copyright © 2015 Derek Doherty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class WeatherCD;

NS_ASSUME_NONNULL_BEGIN

@interface DailyForecast : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "DailyForecast+CoreDataProperties.h"
