//
//  NTItemsViewController.m
//  tasks
//
//  Created by Nate Ramirez on 11/5/13.
//  Copyright (c) 2013 natewire. All rights reserved.
//

#import "NTItemsViewController.h"
#import "NTItemCell.h"
#import "Item.h"
#import "NTItemViewController.h"

@implementation NTItemsViewController
{
    NSFetchedResultsController *_fetchedResultsController;
    NSIndexPath *_accessoryTappedIndexPath;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self setTitle:self.list.name];
    self.sectionHeaders = @[@"To-Dos", @"Completed"];
    
    [self setItems:self.list.items.allObjects];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = _accessoryTappedIndexPath;
    Item *item = [self itemAtIndexPath:indexPath];
    
    NTItemViewController *itemVC = segue.destinationViewController;
    [itemVC setItem:item];
}

#pragma mark -
#pragma mark - Other Functions
- (void)addWithName:(NSString *)name
{
    NSManagedObjectContext *context = [NTDatabaseController managedObjectContext];
    Item *item = [NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:context];
    
    // set List
    item.name = name;
    item.tag = @"<tags>";
    item.createdDate = [NSDate date];
    item.dueDate = [NSDate date];
    item.notes = @"";
    
    [self.list addItemsObject:item];
    [self.todoItems insertObject:item atIndex:0];
    
    // Save and update fetch
    [NTDatabaseController saveContext];

    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)deleteItem:(id)item
{
    
}


#pragma mark -
#pragma mark - Actions
- (IBAction)add:(id)sender
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Add" message:@"Please enter item title." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Create", nil];
    [av setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [av show];
}

- (IBAction)edit:(id)sender
{
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    
    if(self.tableView.editing){
        [self.editButtonItem2 setTitle:@"Done"];
    } else {
        [self.editButtonItem2 setTitle:@"Edit"];
    }
}

#pragma mark -
#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0){
        // Cancel
    } else {
        NSString *input = [alertView textFieldAtIndex:0].text;
        [self addWithName:input];
    }
}


#pragma mark -
#pragma mark - UITableView Delegate & Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionHeaders.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self itemsAtSection:section] count];
//    return self.list.items.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.sectionHeaders[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NTItemCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    Item *item = [self itemAtIndexPath:indexPath];
    
    cell.nameLabel.text = item.name;
    cell.tagLabel.text = item.tag;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self toggleItemCompletedAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    _accessoryTappedIndexPath = indexPath;
    [self performSegueWithIdentifier:@"item" sender:self];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        NSMutableArray *array = (indexPath.section?self.completedItems:self.todoItems);
        [array removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        
        [NTDatabaseController saveContext];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    Item *item = [self itemAtIndexPath:sourceIndexPath];
    
    if(destinationIndexPath.section != sourceIndexPath.section){
        if(destinationIndexPath.section == 0){
            // Todos
            item.completedDate = nil;
            
            [self.completedItems removeObject:item];
            [self.todoItems insertObject:item atIndex:destinationIndexPath.row];
            
        } else {
            // Completed
            item.completedDate = [NSDate date];
            
            [self.todoItems removeObject:item];
            [self.completedItems insertObject:item atIndex:destinationIndexPath.row];
            
        }
    } else {
        if(destinationIndexPath.section == 0){
            [self.todoItems exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
        } else {
            [self.completedItems exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
            
        }
    }
}

#pragma mark -
#pragma mark - Getters & Setters
- (void)toggleItemCompletedAtIndexPath:(NSIndexPath *)indexPath
{
    
    Item *item = [self itemAtIndexPath:indexPath];
    NSIndexPath *newIndexPath;
    
    if(item.completedDate){
        // Todos
        item.completedDate = nil;
        
        [self.completedItems removeObject:item];
        [self.todoItems insertObject:item atIndex:self.todoItems.count];
        
        newIndexPath = [NSIndexPath indexPathForItem:self.todoItems.count-1 inSection:0];
    } else {
        // Completed
        item.completedDate = [NSDate date];
        
        [self.todoItems removeObject:item];
        [self.completedItems insertObject:item atIndex:0];
        
        newIndexPath = [NSIndexPath indexPathForItem:0 inSection:1];
    }
    
    // save
    [NTDatabaseController saveContext];

    [self.tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
}

- (NSArray *)itemsAtSection:(NSInteger)section
{
    if(section == 0) return self.todoItems;
    else return self.completedItems;
}

- (Item *)itemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self itemsAtSection:indexPath.section][indexPath.row];
}

- (void)setItems:(NSArray *)items
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"completedDate != nil"];
    self.completedItems = [NSMutableArray arrayWithArray:[items filteredArrayUsingPredicate:pred]];
    
    pred = [NSPredicate predicateWithFormat:@"completedDate == nil"];
    self.todoItems = [NSMutableArray arrayWithArray:[items filteredArrayUsingPredicate:pred]];
}

//// =================
////     SAVE CODE
//// =================
//- (NSFetchedResultsController *)fetchedResultController
//{
//    if(_fetchedResultsController) return _fetchedResultsController;
//    
//    NSManagedObjectContext *context = [NTDatabaseController managedObjectContext];
//    
//    // Create request
//    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Item"];
//    [request setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
//    
//    // Create controller
//    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
//    
//    NSError *error = nil;
//    [_fetchedResultsController performFetch:&error];
//    if(error){
//        NSLog(@"Fetching Error. %@", error.localizedDescription);
//        return nil;
//    }
//    
//    return _fetchedResultsController;
//}


@end
