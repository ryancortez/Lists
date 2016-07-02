
//
//  ListItemSTableViewController.m
//  Lists
//
//  Created by Ryan Cortez on 6/28/16.
//  Copyright © 2016 Ryan Cortez. All rights reserved.
//

#import "ListItemsTableViewController.h"
#import "AddListItemViewController.h"

@implementation ListItemsTableViewController

#pragma mark - View Lifecycle

- (void)viewWillAppear:(BOOL)animated {
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    self.navigationItem.title = [_lists[self.index] title];
    [self.tableView reloadData];
}

#pragma mark - Saving Content

// Saving content added from the AddItemView Controller
- (void) saveListItems: (NSArray *) listItems inList: (List *) list {
    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithArray:list.listItems];
    _lists[_index] = list;
    [self saveListsToUserDefault];
    [_list setTitle:list.title andListItems:mutableArray];
}

// Saving content added from the AddItemView Controller
- (void) saveLists: (NSMutableArray *) lists {
    _lists = lists;
    [self saveListsToUserDefault];
    [self.tableView reloadData];
}

// Make the newly added content persistent
- (void) saveListsToUserDefault {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *lists = [[NSMutableArray alloc]initWithArray:_lists];
    NSData *listData = [NSKeyedArchiver archivedDataWithRootObject:lists];
    [userDefaults setObject:listData forKey:@"lists"];
    [userDefaults synchronize];
}

#pragma mark - TableView Data Source

// Fill in the table view
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *listItemCell = [tableView dequeueReusableCellWithIdentifier:@"ListItemCell"];
    List *list = _lists[self.index];
    ListItem *listItem = list.listItems[indexPath.row];
    listItemCell.textLabel.text = listItem.title;
    return listItemCell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    List *list = _lists[self.index];
    return list.listItems.count;
}

#pragma mark - TableView Delegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // What happens when the delete button is tapped
        [[_lists[self.index] listItems] removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self saveListsToUserDefault];
    }
}


#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"listItemTableViewToAddListItemTableViewSegue"]) {
        UINavigationController *navigationController = (UINavigationController *) segue.destinationViewController;
        AddListItemViewController *addListItemViewController = navigationController.viewControllers.firstObject;
        addListItemViewController.delegate = self;
        addListItemViewController.lists = _lists;
        addListItemViewController.index = self.index;
    }
}

@end
