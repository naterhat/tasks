//
//  NTItemViewController.h
//  tasks
//
//  Created by Nate Ramirez on 11/5/13.
//  Copyright (c) 2013 natewire. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"

@interface NTItemViewController : UIViewController<UITextViewDelegate>
@property (nonatomic, strong) Item *item;
@property (nonatomic, weak) IBOutlet UILabel *createdDateLabel;
@property (nonatomic, weak) IBOutlet UILabel *completedDateLabel;
@property (nonatomic, weak) IBOutlet UILabel *dueDateLabel;
@property (nonatomic, weak) IBOutlet UITextView *noteTextView;

@end
