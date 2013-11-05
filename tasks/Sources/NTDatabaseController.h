//
//  NTDatabaseController.h
//  tasks
//
//  Created by Nate Ramirez on 11/5/13.
//  Copyright (c) 2013 natewire. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NTDatabaseController : NSObject
+ (NSManagedObjectContext *)managedObjectContext;
+ (void)saveContext;

@end
