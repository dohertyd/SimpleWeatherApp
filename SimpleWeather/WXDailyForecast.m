//
//  WXDailyForecast.m
//  SimpleWeather
//
//  Created by Derek Doherty on 21/12/2015.
//  Copyright © 2015 Derek Doherty. All rights reserved.
//

#import "WXDailyForecast.h"

@implementation WXDailyForecast


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    // 1
    NSMutableDictionary *paths = [[super JSONKeyPathsByPropertyKey] mutableCopy];
    // 2
    paths[@"tempHigh"] = @"temp.max";
    paths[@"tempLow"] = @"temp.min";
    // 3
    return paths;
}

@end
