//
//  CoreDataStack.m
//  AceChat
//
//  Created by Derek Doherty on 20/09/2015.
//  Copyright © 2015 Derek Doherty. All rights reserved.
//

#import "CoreDataStack.h"

// Replace if needed with different App name
static NSString * moduleName = @"SimpleWeather";

@interface CoreDataStack()

@end



@implementation CoreDataStack

@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

@synthesize managedObjectContext = _managedObjectContext;
@synthesize saveManagedObjectContext = _saveManagedObjectContext;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.dd.AceChat" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:moduleName withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
   // NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"SimpleWeather.sqlite"];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", moduleName]];
    NSError *error = nil;
    
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:@{NSMigratePersistentStoresAutomaticallyOption : @YES, NSInferMappingModelAutomaticallyOption : @YES} error:&error])
    {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
//    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
//    if (!coordinator) {
//        return nil;
//    }
    // Setting concurrency type to main Q here
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    
    // We make this MOC a child of the PRIVATE Q saveManagedObject
    _managedObjectContext.parentContext = [self saveManagedObjectContext];
    
    
    //[_managedObjectContext setPersistentStoreCoordinator:coordinator]; // Not Needed as the SAVE MOC connects tothe PSC
    
    return _managedObjectContext;
}

// This is a new MANAGED OBJECT CONTEXT on a PRIVATE Q which can be used to do saving off the MAIN Q
- (NSManagedObjectContext *)saveManagedObjectContext
{
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_saveManagedObjectContext != nil) {
        return _saveManagedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    // Setting concurrency type to PRIVATE Q here
    _saveManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    
    [_saveManagedObjectContext setPersistentStoreCoordinator:coordinator];
    return _saveManagedObjectContext;
}



#pragma mark - Core Data Saving support

- (void)saveContext
{
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil  && self.saveManagedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] || [self.saveManagedObjectContext hasChanges])
        {
            [managedObjectContext performBlockAndWait:^   // This must be sync as on Main Q
             {
                NSError *error = nil;
                 if (![managedObjectContext save:&error])
                 {
                     // Replace this implementation with code to handle the error appropriately.
                     // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                     NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                     abort();
                 }
                 
             }];
            
            [self.saveManagedObjectContext performBlock:^   // CAn do this ASync here as on private Q
             {
                 NSError *error = nil;
                 if (![self.saveManagedObjectContext save:&error])
                 {
                     // Replace this implementation with code to handle the error appropriately.
                     // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                     NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                     abort();
                 }
                 
             }];
        }
        else
        {
            return;
        }
    }
}

@end
