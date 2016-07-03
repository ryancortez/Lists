
//
//  ListItemsTableViewController.m
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
    self.navigationItem.title = [_lists[self.index] title];
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListItemCell"];
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 0;
    [cell.textLabel setFont:[UIFont systemFontOfSize:20]];
    List *list = _lists[self.index];
    ListItem *listItem = list.listItems[indexPath.row];
    cell.textLabel.text = listItem.title;
    
    return cell;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Create height based off of how many lines of text are added to the cell content
    List *list = _lists[self.index];
    ListItem *listItem = list.listItems[indexPath.row];
    NSString *cellText = listItem.title;
    
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:20.0];
    
    NSAttributedString *attributedText =
    [[NSAttributedString alloc]
     initWithString:cellText
     attributes:@
     {
     NSFontAttributeName: cellFont
     }];
    CGRect rect = [attributedText boundingRectWithSize:CGSizeMake(tableView.bounds.size.width, CGFLOAT_MAX)
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];

    return rect.size.height + 40.0;
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
