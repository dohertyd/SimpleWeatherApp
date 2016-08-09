//
//  WXCondition.h
//  SimpleWeather
//
//  Created by Derek Doherty on 21/12/2015.
//  Copyright © 2015 Derek Doherty. All rights reserved.
//

#import <Mantle/Mantle.h>

@class Weather;

@interface WXCondition : MTLModel <MTLJSONSerializing>

// 2
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSNumber *humidity;
@property (nonatomic, strong) NSNumber *temperature;
@property (nonatomic, strong) NSNumber *tempHigh;
@property (nonatomic, strong) NSNumber *tempLow;
@property (nonatomic, strong) NSString *locationName;
@property (nonatomic, strong) NSDate *sunrise;
@property (nonatomic, strong) NSDate *sunset;

//@property (nonatomic, strong) NSArray<Weather *> * weather;    // This is a relationship in Core Data
@property (nonatomic, strong) NSArray * weather;    // This is a relationship in Core Data

@property (nonatomic, strong) NSNumber *windBearing;
@property (nonatomic, strong) NSNumber *windSpeed;


// 3
- (NSString *)imageName;

@end


@interface Weather : MTLModel<MTLJSONSerializing>

@property (nonatomic, assign) NSInteger weather_id;

@property (nonatomic, copy) NSString *condition;

@property (nonatomic, copy) NSString *icon;

@property (nonatomic, copy) NSString *weather_description;

@end