//
//  WXCondition.m
//  SimpleWeather
//
//  Created by Derek Doherty on 21/12/2015.
//  Copyright © 2015 Derek Doherty. All rights reserved.
//

#import "WXCondition.h"

@implementation WXCondition



+ (NSDictionary *)imageMap {
    // 1
    static NSDictionary *_imageMap = nil;
    if (! _imageMap) {
        // 2
        _imageMap = @{
                      @"01d" : @"weather-clear",
                      @"02d" : @"weather-few",
                      @"03d" : @"weather-few",
                      @"04d" : @"weather-broken",
                      @"09d" : @"weather-shower",
                      @"10d" : @"weather-rain",
                      @"11d" : @"weather-tstorm",
                      @"13d" : @"weather-snow",
                      @"50d" : @"weather-mist",
                      @"01n" : @"weather-moon",
                      @"02n" : @"weather-few-night",
                      @"03n" : @"weather-few-night",
                      @"04n" : @"weather-broken",
                      @"09n" : @"weather-shower",
                      @"10n" : @"weather-rain-night",
                      @"11n" : @"weather-tstorm",
                      @"13n" : @"weather-snow",
                      @"50n" : @"weather-mist",
                      };
    }
    return _imageMap;
}

// 3
- (NSString *)imageName {
    return [WXCondition imageMap][((Weather *)(self.weather[0])).icon];
    // return [WXCondition imageMap][self.icon];
}


//
// This Maps Property Name to JSON KeyPath
//
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"date": @"dt",
             @"locationName": @"name",
             @"humidity": @"main.humidity",
             @"temperature": @"main.temp",
             @"tempHigh": @"main.temp_max",
             @"tempLow": @"main.temp_min",
             @"sunrise": @"sys.sunrise",
             @"sunset": @"sys.sunset",
//             @"conditionDescription": @"Weather.description",
             @"weather": @"weather",

             @"windBearing": @"wind.deg",
             @"windSpeed": @"wind.speed"
             };
}


+(NSString *)managedObjectEntityName
{
    return @"Condition";
}

//We return an empty dictionary because the property names are identical in the class and entity
+ (NSDictionary *)managedObjectKeysByPropertyKey
{
    return @{
             @"date": @"date",
             @"locationName": @"locationName",
             @"humidity": @"humidity",
             @"temperature": @"temperature",
             @"tempHigh": @"tempHigh",
             @"tempLow": @"tempLow",
             @"sunrise": @"sunrise",
             @"sunset": @"sunset",
             //@"conditionDescription": @"Weather.description",
                   //@"weather": @"weathercd",        // Relationship Here !
             
             @"windBearing": @"windBearing",
             @"windSpeed": @"windSpeed"
             };
}

+ (NSDictionary *)relationshipModelClassesByPropertyKey
{
    return @{
             @"weathercd": Weather.class
             };
    
}

//+ (NSValueTransformer *)entityAttributeTransformerForKey:(NSString *)key
//{
//    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[Weather class]];
//}

#pragma - mark MTLValueTransformers

//
// Date Transform
//
+(NSValueTransformer *)dateJSONTransformer
{
    NSValueTransformer * vt = [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error)
    {
        return [NSDate dateWithTimeIntervalSince1970:dateString.floatValue];
    }
    reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error)
    {
          return [NSString stringWithFormat:@"%f",[date timeIntervalSince1970]];
    }];
    
    return vt;
}

+ (NSValueTransformer *)sunriseJSONTransformer {
    return [self dateJSONTransformer];
}

+ (NSValueTransformer *)sunsetJSONTransformer {
    return [self dateJSONTransformer];
}


+ (NSValueTransformer *)weatherJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[Weather class]];
}

//+(NSValueTransformer *)conditionDescriptionJSONTransformer
//{
//    NSValueTransformer * vt = [MTLValueTransformer transformerUsingForwardBlock:^id(NSArray *values, BOOL *success, NSError *__autoreleasing *error)
//    {
//        return [values firstObject];
//    }
//    reverseBlock:^id(NSString *str, BOOL *success, NSError *__autoreleasing *error)
//    {
//        return @[str];   // Literal array
//    }];
//    
//    return vt;
//}
//
//+ (NSValueTransformer *)conditionJSONTransformer {
//    return [self conditionDescriptionJSONTransformer];
//}
//
//+ (NSValueTransformer *)iconJSONTransformer {
//    return [self conditionDescriptionJSONTransformer];
//}




#define MPS_TO_MPH 2.23694f

+ (NSValueTransformer *)windSpeedJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^(NSNumber *num,  BOOL *success, NSError *__autoreleasing *error)
    {
        return @(num.floatValue*MPS_TO_MPH);
    } reverseBlock:^(NSNumber *speed, BOOL *success, NSError *__autoreleasing *error)
    {
        return @(speed.floatValue/MPS_TO_MPH);
    }];
}

@end

#pragma - mark Weather Class

@implementation Weather

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"weather_id":@"id",
             @"weather_description":@"description",
             @"condition": @"main",
             @"icon": @"icon",
             };
}

+(NSString *)managedObjectEntityName
{
    return @"WeatherCD";
}

//We return an empty dictionary because the property names are identical in the class and entity
+ (NSDictionary *)managedObjectKeysByPropertyKey
{

    return @{
             @"weather_id":@"weather_id",
             @"weather_description":@"weather_description",
             @"condition": @"condition",
             @"icon": @"icon",
             };
}

+ (NSDictionary *)relationshipModelClassesByPropertyKey
{
    return @{@"weatherCondition": WXCondition.class};
}

@end



