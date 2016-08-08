//
//  WXCLient.m
//  SimpleWeather
//
//  Created by Derek Doherty on 21/12/2015.
//  Copyright © 2015 Derek Doherty. All rights reserved.
//

#import "WXCLient.h"
#import <TSMessage.h>
#import "Globals.h"
#import "Condition.h"



@interface WXCLient ()

@property (strong, nonatomic) NSURLSession * session;

//
// Track the networking  call type
//
typedef NS_ENUM(NSInteger, NetworkCallType)
{
    CURRENT,
    HOURLY,
    DAILY
};
@property (assign) NetworkCallType networkCallType;

@end


@implementation WXCLient


-(instancetype)init
{
    if (self = [super init])
    {
        NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config];
    }
    return  self;
}

//
// This will be called when json property is set
//
-(void)setCurrentConditionJson:(NSDictionary *)currentConditionJson
{
    NSLog(@"currentConditionJson has been updated = >%@<", currentConditionJson);
    _currentConditionJson = currentConditionJson;
    
    NSError *error = nil;
    self.currentCondition = [MTLJSONAdapter modelOfClass:[WXCondition class] fromJSONDictionary:self.currentConditionJson error:&error ];
    
    
    
    if (!error)
    {
         NSLog(@"currentCondition Mantle Object is = >%@<", self.currentCondition);
    }
    else
    {
        NSLog(@"Error in Mantle deserialisation is = >%@<", [NSString stringWithFormat:@"%@",[error localizedDescription]]);
    }
    
    //
    // Store the received data in the Core Data Model
    //
    
   // dispatch_async(dispatch_get_main_queue(),
                  //^{
                    // NSError * error;
    NSManagedObject *managedCurrentCondition = [MTLManagedObjectAdapter managedObjectFromModel:self.currentCondition insertingIntoContext:[Globals getCds].managedObjectContext error:&error];
    if (!error)
    {
        NSLog(@"currentCondition Managed Object is = >%@<", managedCurrentCondition);
    }
    else
    {
        NSLog(@"Error in Mantle deserialisation is = >%@<", [NSString stringWithFormat:@"%@",[error localizedDescription]]);
    }
                       //
                       // Fetch !!
                       //
                       NSEntityDescription * entity = [NSEntityDescription entityForName:@"Condition" inManagedObjectContext:[Globals getCds].managedObjectContext];
                       
                       //
                       // DO A FETCH on Stored Contact Data
                       //
                       NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
                       [fetchRequest setEntity:entity];
                       
                       NSArray * fetchedObjects = [[Globals getCds].managedObjectContext executeFetchRequest:fetchRequest error:&error];
                       
                       
                       for (Condition *cc in fetchedObjects)
                       {
                           NSLog(@"Condition is = >%@< and weather Array is >%@<" , cc, cc.weathercd);
                       }
                  // });
}

//Post *cdPost = [NSEntityDescription insertNewObjectForEntityForName:@"Post"
//                                             inManagedObjectContext:self.managedObjectContext];
//// configure the cdPost object with the data from the web service
//for (id commentObject in commentArrayFromPostObject) {
//    Comment *cdComment =
//    [NSEntityDescription insertNewObjectForEntityForName:@"Comment"
//                                  inManagedObjectContext:self.managedObjectContext];
//    // configure the cdComment object with the data from the web service
//    cdComment.post = cdPost;
//}

-(void)setHourlyForecastJson:(NSDictionary *)hourlyForecastJson
{
    NSLog(@"hourlyForecastJson has been updated = >%@<", hourlyForecastJson);
    _hourlyForecastJson = hourlyForecastJson;
    
    //RACSequence *list = [json[@"list"] rac_sequence];
    NSArray * hourlyList = hourlyForecastJson[@"list"];
    
    NSError *error = nil;
   // self.hourlyForecast = [MTLJSONAdapter modelOfClass:[WXCondition class] fromJSONArray:hourlyList error:&error ];
    self.hourlyForecast = [MTLJSONAdapter modelsOfClass:[WXCondition class] fromJSONArray:hourlyList error:&error];
    
    if (!error)
    {
        //NSLog(@"hourlyForecast Mantle Object is = >%@<", self.hourlyForecast);
    }
    else
    {
        NSLog(@"Error in hourlyForecast Mantle deserialisation is = >%@<", [NSString stringWithFormat:@"%@",[error localizedDescription]]);
    }
    
    
    NSManagedObject *managedCurrentCondition = [MTLManagedObjectAdapter managedObjectFromModel:self.currentCondition insertingIntoContext:[Globals getCds].managedObjectContext error:&error];
    if (!error)
    {
        NSLog(@"currentCondition Managed Object is = >%@<", managedCurrentCondition);
    }
    else
    {
        NSLog(@"Error in Mantle deserialisation is = >%@<", [NSString stringWithFormat:@"%@",[error localizedDescription]]);
    }
}

-(void)setDailyForecastJson:(NSDictionary *)dailyForecastJson
{
    NSLog(@"dailyForecastJson has been updated = >%@<", dailyForecastJson);
    _dailyForecastJson = dailyForecastJson;
    
    NSError *error = nil;
    NSArray * dailyList = dailyForecastJson[@"list"];
    self.dailyForecast = [MTLJSONAdapter modelsOfClass:[WXDailyForecast class] fromJSONArray:dailyList error:&error];
    
    
    
    if (!error)
    {
       // NSLog(@"dailyForecastJson Mantle Object is = >%@<", self.dailyForecast);
    }
    else
    {
        NSLog(@"Error in dailyForecast Mantle deserialisation is = >%@<", [NSString stringWithFormat:@"%@",[error localizedDescription]]);
    }
}




//
// Using this as a utility function
//
-(id)fetchJSONFromURL:(NSURL *)url withType:(NetworkCallType)type   // 0,1,2
{
    NSLog(@"Fetching: %@", url.absoluteString);
    
    
    NSURLSessionDataTask * dataTask = [self.session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
    {
        
        if (!error)
        {
            NSError *jsonError = nil;
            //
            // Using id here as it can be either a dictionary or an array returned
            id json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
            if (! jsonError)
            {

                
                switch (type)
                {
                    case CURRENT:
                        self.currentConditionJson = (NSDictionary * )json;
                        break;
                    case HOURLY:
                        self.hourlyForecastJson = (NSDictionary * )json;
                        break;
                    case DAILY:
                        self.dailyForecastJson = (NSDictionary * )json;
                        break;
                    default:
                        break;
                };
            }
            else
            {
                self.currentConditionJson = nil;
                self.hourlyForecastJson = nil;
                self.dailyForecastJson = nil;
            }
            
        }
        else
        {
            // TODO: Handle error situation
            NSLog(@"%@",error);
            [TSMessage showNotificationWithTitle:@"Error"
                                        subtitle:@"There was a problem fetching the latest weather."
                                            type:TSMessageNotificationTypeError];
        }
    }];
    
    [dataTask resume];
    
    return nil;
}

#define APIKEY 9aa420ebdb686a331513a0e5fe810d16


-(void)fetchCurrentConditionsForLocation:(CLLocationCoordinate2D)coordinate
{
    NSString * ulrString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&units=imperial&APPID=9aa420ebdb686a331513a0e5fe810d16", coordinate.latitude, coordinate.longitude];
    
    NSURL *url = [NSURL URLWithString:ulrString];
    
    [self fetchJSONFromURL:url withType:CURRENT];
    
}

-(void)fetchHourlyForecastForLocation:(CLLocationCoordinate2D)coordinate
{
    NSString * ulrString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast?lat=%f&lon=%f&units=imperial&cnt=12&APPID=9aa420ebdb686a331513a0e5fe810d16", coordinate.latitude, coordinate.longitude];
    
    NSURL *url = [NSURL URLWithString:ulrString];
    
    [self fetchJSONFromURL:url withType:HOURLY];
}


-(void)fetchDailyForecastForLocation:(CLLocationCoordinate2D)coordinate
{
    NSString * ulrString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast/daily?lat=%f&lon=%f&units=imperial&cnt=7&APPID=9aa420ebdb686a331513a0e5fe810d16", coordinate.latitude, coordinate.longitude];
    
    NSURL *url = [NSURL URLWithString:ulrString];
    
    [self fetchJSONFromURL:url withType:DAILY];
}

@end















