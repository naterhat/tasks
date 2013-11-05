//
//  NTItemsViewController.h
//  tasks
//
//  Created by Nate Ramirez on 11/5/13.
//  Copyright (c) 2013 natewire. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "List.h"

@interface NTItemsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *editButtonItem2;
@property (nonatomic, strong) List *list;
@property (nonatomic, strong) NSArray *sectionHeaders;
@property (nonatomic, strong) NSMutableArray *completedItems;
@property (nonatomic, strong) NSMutableArray *todoItems;
- (IBAction)add:(id)sender;
- (IBAction)edit:(id)sender;
@end
