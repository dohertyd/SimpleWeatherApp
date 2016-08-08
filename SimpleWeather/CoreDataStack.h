//
//  CoreDataStack.h
//  AceChat
//
//  Created by Derek Doherty on 20/09/2015.
//  Copyright © 2015 Derek Doherty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataStack : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectContext *saveManagedObjectContext;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
//- (NSURL *)applicationDocumentsDirectory;

@end
