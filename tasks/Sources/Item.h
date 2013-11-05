//
//  Item.h
//  tasks
//
//  Created by Nate Ramirez on 11/5/13.
//  Copyright (c) 2013 natewire. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class List, Tag;

@interface Item : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * tag;
@property (nonatomic, retain) NSDate * createdDate;
@property (nonatomic, retain) NSDate * completedDate;
@property (nonatomic, retain) NSDate * dueDate;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) List *list;
@property (nonatomic, retain) NSSet *tags;
@end

@interface Item (CoreDataGeneratedAccessors)

- (void)addTagsObject:(Tag *)value;
- (void)removeTagsObject:(Tag *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;

@end
