//
//  ListTableViewController.m
//  Lists
//
//  Created by Ryan Cortez on 6/28/16.
//  Copyright © 2016 Ryan Cortez. All rights reserved.
//

#import "ListTableViewController.h"

@implementation ListTableViewController

#pragma View Lifecycle

- (void)viewWillAppear:(BOOL)animated {
    self.navigationItem.title = @"Lists";
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    [self checkForIntialLaunch];
    [self readFromPersistentStorageAndUpdateView];
}

#pragma mark - Helper Methods


// Fills in the table view with example categories and food on the inital launch
- (void) checkForIntialLaunch {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (![userDefaults boolForKey:@"isFirstLaunch"]) {
        // Create a default collection of lists
        [self initViewWithDefaultValues];
        [self saveListsToUserDefault];
        [userDefaults setBool:YES forKey:@"isFirstLaunch"];
    }
}

// Create a default collection of lists
- (void) initViewWithDefaultValues {
    List *dinner = [[List alloc]initWithTitle:@"Dinner" andListItemTitles:[NSArray arrayWithObjects:@"Carrots", @"Onions", nil]];
    List *breakfast = [[List alloc]initWithTitle:@"Breakfast" andListItemTitles:[NSArray arrayWithObjects:@"Eggs", @"Bacon", nil]];
    NSMutableArray *categoriesArray = [[NSMutableArray alloc]initWithObjects:dinner, breakfast, nil];
    _lists = categoriesArray;
}


// Pull data from persistent storage
- (void) readFromPersistentStorageAndUpdateView {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *listsData = [userDefaults objectForKey:@"lists"];
    _lists = (NSMutableArray *) [NSKeyedUnarchiver unarchiveObjectWithData:listsData];
    [self.tableView reloadData];
}

// Save new items made from the AddListItemTableViewController
- (void) saveListItems: (NSArray *) listItems inList: (List *) list {
    NSMutableArray *listItemsMutableArray = [[NSMutableArray alloc]initWithArray:listItems];
    [_lists addObject:[list initWithTitle:list.title andListItems:listItemsMutableArray]];
    [self saveListsToUserDefault];
}

// Save the current state of the lists to persisent storage
- (void) saveListsToUserDefault {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *lists = [[NSMutableArray alloc]initWithArray:_lists];
    NSData *listData = [NSKeyedArchiver archivedDataWithRootObject:lists];
    [userDefaults setObject:listData forKey:@"lists"];
    [userDefaults synchronize];
}


#pragma mark - TableView Data Source

// Create each cell for the table view
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *listCell = [tableView dequeueReusableCellWithIdentifier:@"ListCell"];
    List *list = _lists[indexPath.row];
    listCell.textLabel.text = list.title;
    return listCell;
}

// Return the number of rows that should be in the table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _lists.count;
}

#pragma mark - TableView Delegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // What happens when the delete button is tapped
        [_lists removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self saveListsToUserDefault];
    }
}

#pragma mark - Segues

// Pass information to the next ViewController
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"listTableViewToListItemTableView"]){
        [self transferModelFromCurrentViewControllerToListItemViewController:(ListItemsTableViewController *) segue.destinationViewController];
    }
    if ([segue.identifier isEqualToString:@"listTableViewToAddListTableViewSegue"]) {
        [self transferModelFromCurrentViewControllerToNavigationViewController: (UINavigationController *)segue.destinationViewController];
    }
}

// Passing information to ListItemViewController
- (void) transferModelFromCurrentViewControllerToListItemViewController: (ListItemsTableViewController *) listItemsTableViewController {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    listItemsTableViewController.index = indexPath.row;
    listItemsTableViewController.lists = _lists;
}

// Passing information to the AddListViewController
- (void) transferModelFromCurrentViewControllerToNavigationViewController: (UINavigationController *) navigationController {
    AddListViewController *addListViewController = (AddListViewController *) navigationController.viewControllers.firstObject;
    addListViewController.delegate = self;

}

@end
