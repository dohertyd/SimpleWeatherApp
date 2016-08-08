//
//  WXCLient.h
//  SimpleWeather
//
//  Created by Derek Doherty on 21/12/2015.
//  Copyright © 2015 Derek Doherty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXCondition.h"
#import "WXDailyForecast.h"

@import CoreLocation;

@interface WXCLient : NSObject

@property (strong, nonatomic)  NSDictionary *currentConditionJson;
@property (strong, nonatomic)  NSDictionary *hourlyForecastJson;
@property (strong, nonatomic)  NSDictionary *dailyForecastJson;

@property (strong, nonatomic) WXCondition * currentCondition;
@property (nonatomic, strong) NSArray *hourlyForecast;
@property (nonatomic, strong) NSArray *dailyForecast;

-(void)fetchCurrentConditionsForLocation:(CLLocationCoordinate2D)coordinate;
-(void)fetchHourlyForecastForLocation:(CLLocationCoordinate2D)coordinate;
-(void)fetchDailyForecastForLocation:(CLLocationCoordinate2D)coordinate;





@end
