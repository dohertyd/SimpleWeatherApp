//
//  WXManager.m
//  SimpleWeather
//
//  Created by Derek Doherty on 21/12/2015.
//  Copyright © 2015 Derek Doherty. All rights reserved.
//

#import "WXManager.h"
#import "WXClient.h"
#import <TSMessages/TSMessage.h>
#import "Globals.h"

@interface WXManager ()

// 1
@property (nonatomic, strong, readwrite) CLLocation *currentLocation;

@property (nonatomic, strong, readwrite) WXCondition *currentCondition;
@property (nonatomic, strong, readwrite) NSArray *hourlyForecast;
@property (nonatomic, strong, readwrite) NSArray *dailyForecast;

// 2
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) BOOL isFirstUpdate;
@property (nonatomic, strong) WXCLient * client;

@end

@implementation WXManager

+ (instancetype)sharedManager {
    static id _sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}



-(id)init
{
    if (self = [super init])
    {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        
        _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        _locationManager.distanceFilter=kCLDistanceFilterNone;
        [_locationManager requestWhenInUseAuthorization];
        //[locationManager startMonitoringSignificantLocationChanges];
        
        
        _client = [[WXCLient alloc] init];
        
        //
        // Add a KVO to client for property currentCondition
        //
        [_client addObserver:self forKeyPath:@"currentCondition" options:NSKeyValueObservingOptionNew context:NULL];
        [_client addObserver:self forKeyPath:@"hourlyForecast" options:NSKeyValueObservingOptionNew context:NULL];
        [_client addObserver:self forKeyPath:@"dailyForecast" options:NSKeyValueObservingOptionNew context:NULL];
        
    }
    
    return self;
}

-(void)findCurrentLocation
{
    self.isFirstUpdate = YES;
    [self.locationManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    //
    // The first update is usually rubbish so Ignore it!
    //
    if (self.isFirstUpdate)
    {
        self.isFirstUpdate = NO;
        return;
    }
    
    CLLocation *location = [locations lastObject];
    
    if (location.horizontalAccuracy > 0)
    {
        self.currentLocation = location;            // Calls the overridden setter on currentlocation
        [self.locationManager stopUpdatingLocation];
    }
}

//
// Property currentLocation SETTER override
//
-(void)setCurrentLocation:(CLLocation *)currentLocation
{
    NSLog(@"CurrentLocation has been updated to >%@<", currentLocation);
    _currentLocation = currentLocation;
    [self updateCurrentConditions];
    
}

-(void)updateCurrentConditions
{
    //
    // This will call the async network calls and parse the JSON data into the Mantle classes
    // Eventually updating the currentCondition variable which we will observe the change on
    // here and eventually update the Interface as needed
    //
    [self.client fetchCurrentConditionsForLocation:self.currentLocation.coordinate];
    [self.client fetchHourlyForecastForLocation:self.currentLocation.coordinate];
    [self.client fetchDailyForecastForLocation:self.currentLocation.coordinate];
}

#pragma - mark KVO on WXCLient property currentCondition

//
// Single point for all responses to subscribed observation
//
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    //
    // OKAY, here we get the change from the client which means currentCondition has been updated
    //
    if ([keyPath isEqualToString:@"currentCondition"])
    {
        //NSLog(@"CurrentCondition in the client has been Updated with change = >%@<", change);
        NSLog(@"CurrentCondition in the client has been Updated in WXManager");
        self.currentCondition = (WXCondition *)(change[@"new"]);

        
    }
    else if ([keyPath isEqualToString:@"hourlyForecast"])
    {
        //NSLog(@"hourlyForecast in the client has been Updated with change = >%@<", change);
        NSLog(@"hourlyForecast in the client has been Updated in WXManager");
        self.hourlyForecast = (NSArray *)(change[@"new"]);
    }
    else if ([keyPath isEqualToString:@"dailyForecast"])
    {
        //NSLog(@"dailyForecast in the client has been Updated with change = >%@<", change);
        NSLog(@"dailyForecast in the client has been Updated in WXManager");
        self.dailyForecast = (NSArray *)(change[@"new"]);
    }
    
}




//
// Unsubscribe KVO
//
-(void)dealloc
{
    [self.client removeObserver:self forKeyPath:@"currentCondition"];
    [self.client removeObserver:self forKeyPath:@"hourlyForecast"];
    [self.client removeObserver:self forKeyPath:@"dailyForecast"];
}


@end























