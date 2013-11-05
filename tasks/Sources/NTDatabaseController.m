//
//  NTDatabaseController.m
//  tasks
//
//  Created by Nate Ramirez on 11/5/13.
//  Copyright (c) 2013 natewire. All rights reserved.
//

#import "NTDatabaseController.h"

static NSPersistentStoreCoordinator *_persistentStoreCoordinator = nil;
static NSManagedObjectContext *_managedObjectContext = nil;
static NSManagedObjectModel *_managedObjectModel = nil;
static NSUndoManager *_undoManager = nil;


@implementation NTDatabaseController

+ (NSManagedObjectContext *)managedObjectContext
{
    if(_managedObjectContext) return _managedObjectContext;
    
    NSPersistentStoreCoordinator *coordinator = [self persistantStoreCoodinator];
    if(coordinator){
        //        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
        [_managedObjectContext setUndoManager:[self undoManager]];
    }
    
    return _managedObjectContext;
}

+ (NSPersistentStoreCoordinator *)persistantStoreCoodinator
{
    if(_persistentStoreCoordinator) return _persistentStoreCoordinator;
    
    NSURL *dirURL =     [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"mine" isDirectory:YES];
    NSURL *databaseURL = [dirURL URLByAppendingPathComponent:kFileNameDatabase];
    //    NSURL *databaseURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:kFileNameDatabase];
    NSError *error = nil;
    
    // Create a Directory
    [[NSFileManager defaultManager] createDirectoryAtURL:dirURL withIntermediateDirectories:YES attributes:nil error:nil];
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if(![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:databaseURL options:nil error:&error]){
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        //        abort();
    }
    
    return _persistentStoreCoordinator;
}

+ (NSManagedObjectModel *)managedObjectModel
{
    if(_managedObjectModel) return _managedObjectModel;
    
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:kFileNameModel withExtension:nil];
    
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:fileURL];
    
    return _managedObjectModel;
}


+ (NSUndoManager *)undoManager
{
    if(_undoManager) return _undoManager;
    
    _undoManager = [[NSUndoManager alloc] init];
    return _undoManager;
}

+ (BOOL)connect
{
    return [self managedObjectContext] != nil;
}

+ (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask] lastObject];
}


+ (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    if(managedObjectContext){
        if([managedObjectContext hasChanges] && ![managedObjectContext save:&error]){
            NSLog(@"Unresolved error: %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
