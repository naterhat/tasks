//
//  NTItemViewController.m
//  tasks
//
//  Created by Nate Ramirez on 11/5/13.
//  Copyright (c) 2013 natewire. All rights reserved.
//

#import "NTItemViewController.h"

static NSDateFormatter *_dateFormatter = nil;

@implementation NTItemViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.title = self.item.name;
    if(self.item.createdDate)   self.createdDateLabel.text = [[self dateFormatter] stringFromDate:self.item.createdDate];
    else self.createdDateLabel.text = @"Not Yet";
    
    if(self.item.dueDate)       self.dueDateLabel.text = [[self dateFormatter] stringFromDate:self.item.dueDate];
    else self.dueDateLabel.text = @"Not Yet";
    
    if(self.item.completedDate) self.completedDateLabel.text = [[self dateFormatter] stringFromDate:self.item.completedDate];
    else self.completedDateLabel.text = @"Not Yet";
    
    self.noteTextView.text = self.item.notes;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.item.notes = self.noteTextView.text;
    [NTDatabaseController saveContext];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSDateFormatter *)dateFormatter
{
    if(! _dateFormatter){
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateStyle:NSDateFormatterShortStyle];
    } return _dateFormatter;
}


@end
