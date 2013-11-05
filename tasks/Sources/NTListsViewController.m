//
//  NTViewController.m
//  tasks
//
//  Created by Nate Ramirez on 11/5/13.
//  Copyright (c) 2013 natewire. All rights reserved.
//

#import "NTListsViewController.h"
#import "NTListCell.h"
#import "NTItemsViewController.h"

@implementation NTListsViewController
{
    NSFetchedResultsController *_fetchedResultsController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.lists = [NSMutableArray array];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = self.collectionView.indexPathsForSelectedItems.firstObject;
    List *list = self.lists[indexPath.row];
    
    NTItemsViewController *itemsVC = segue.destinationViewController;
    [itemsVC setList:list];
}


#pragma mark -
#pragma mark - Other Functions
- (void)addWithName:(NSString *)name
{
    NSManagedObjectContext *context = [NTDatabaseController managedObjectContext];
    List *list = [NSEntityDescription insertNewObjectForEntityForName:@"List" inManagedObjectContext:context];
    
    // set List
    list.name = name;

    // Save and update fetch
    [NTDatabaseController saveContext];
    if([self fetchedResultController]) [[self fetchedResultController] performFetch:nil];
    
//    [self.lists addObject:list]; // old
    

//    [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.lists.count-1 inSection:0]]];
    [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.lists.count-1 inSection:0]]];
}

- (void)deleteItem:(id)item
{
    
}

#pragma mark -
#pragma mark - Actions
- (IBAction)add:(id)sender
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Add" message:@"Please enter list title." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Create", nil];
    [av setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [av show];
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
#pragma mark - UICollectionView Delegate & Datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NTListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    List *list = self.lists[indexPath.row];
    cell.titleLabel.text = list.name;
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.lists.count;
}


#pragma mark -
#pragma mark - Getters & Setters
- (NSFetchedResultsController *)fetchedResultController
{
    if(_fetchedResultsController) return _fetchedResultsController;
    
    NSManagedObjectContext *context = [NTDatabaseController managedObjectContext];
    
    // Create request
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"List"];
    [request setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
    
    // Create controller
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    
    NSError *error = nil;
    [_fetchedResultsController performFetch:&error];
    if(error){
        NSLog(@"Fetching Error. %@", error.localizedDescription);
        return nil;
    }
    
    return _fetchedResultsController;
}

- (NSMutableArray *)lists
{
//    return _lists;
    
    NSFetchedResultsController *fetch = [self fetchedResultController];
    if(! fetch) return [NSMutableArray array];
    
    return [NSMutableArray arrayWithArray:fetch.fetchedObjects];
}

@end
