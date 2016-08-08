//
//  Globals.h
//  AceChat
//
//  Created by Derek Doherty on 18/09/2015.
//  Copyright © 2015 Derek Doherty. All rights reserved.
//

#ifndef Globals_h
#define Globals_h

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CoreDataStack.h"

@interface Globals : NSObject

{
    NSString * nickName;
   // NSManagedObjectContext * moc;
    CoreDataStack * cds;
}

+(Globals *)sharedInstance;

+(NSString *)getNickName;
+(void)setNickName:(NSString *)nickName;

+(CoreDataStack *)getCds;
+(void)setCds:(CoreDataStack *)cds;

@end








#endif /* Globals_h */
