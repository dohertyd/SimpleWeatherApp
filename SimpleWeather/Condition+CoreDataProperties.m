//
//  Condition+CoreDataProperties.m
//  SimpleWeather
//
//  Created by Derek Doherty on 29/12/2015.
//  Copyright © 2015 Derek Doherty. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Condition+CoreDataProperties.h"

@implementation Condition (CoreDataProperties)

@dynamic date;
@dynamic humidity;
@dynamic locationName;
@dynamic sunrise;
@dynamic sunset;
@dynamic temperature;
@dynamic tempHigh;
@dynamic tempLow;
@dynamic windBearing;
@dynamic windSpeed;
@dynamic weathercd;

@end
