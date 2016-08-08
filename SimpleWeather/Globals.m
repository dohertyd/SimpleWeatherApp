//
//  Globals.m
//  AceChat
//
//  Created by Derek Doherty on 18/09/2015.
//  Copyright © 2015 Derek Doherty. All rights reserved.
//

#import "Globals.h"

// We store our settings in the NSUserDefaults dictionary using these keys
static NSString* const NickNameKey = @"NickName";


@interface Globals()
// Private interface here


@end


@implementation Globals

+(Globals *)sharedInstance
{
    static Globals * sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init ];
        // Register default values for our settings
        [[NSUserDefaults standardUserDefaults] registerDefaults:@{NickNameKey: @""}];
    });
    
    return sharedInstance;
}


-(void)setNickName:(NSString *)_nickName
{
    nickName = _nickName;
    [[NSUserDefaults standardUserDefaults]  setObject:_nickName forKey:NickNameKey];
}
+(void)setNickName:(NSString *)nickName
{
    [[Globals sharedInstance] setNickName:nickName];
}

-(NSString *)getNickName
{
    NSString * nn = [[NSUserDefaults standardUserDefaults] objectForKey:NickNameKey];
    nickName = nn;
    return nickName;
}
+(NSString *)getNickName
{
    return [[Globals sharedInstance] getNickName];
}

-(CoreDataStack *)getCds
{
    return cds;
}

+(CoreDataStack *)getCds
{
    return [[Globals sharedInstance] getCds];
}

-(void)setCds:(CoreDataStack *)_cds
{
    cds = _cds;
}

+(void)setCds:(CoreDataStack *)cds
{
    [[Globals sharedInstance] setCds:cds];
}



@end
