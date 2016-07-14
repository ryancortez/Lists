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
    [super viewWillAppear:animated];
    
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
    List *tutorialList = [[List alloc]initWithTitle:@"To-Do List" andListItemTitles:[NSArray arrayWithObjects:@"Learn how to use Lists", @"Tap the Edit button and add a few items", @"Swipe left on this item, and tap Delete", nil]];
    List *shoppingList = [[List alloc]initWithTitle:@"Shopping List" andListItemTitles:[NSArray arrayWithObjects:@"Milk", @"Bread", @"Eggs", nil]];
    NSMutableArray *categoriesArray = [[NSMutableArray alloc]initWithObjects:tutorialList, shoppingList, nil];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListCell"];
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 0;
    [cell.textLabel setFont:[UIFont systemFontOfSize:20]];
    List *list = _lists[indexPath.row];
    cell.textLabel.text = list.title;
    return cell;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Create height based off of how many lines of text are added to the cell content
    List *list = _lists[indexPath.row];
    NSString *cellText = list.title;
    
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
    return rect.size.height + 50;
}

// Sets the icons to the left of the cell when tableview is being edited
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.editing == NO && !indexPath) {
        return  UITableViewCellEditingStyleNone;
    }
    if (self.editing && indexPath.row == _lists.count) {
        return UITableViewCellEditingStyleInsert;
    } else {
        return UITableViewCellEditingStyleDelete;
    }
}

// Set what cell are able to be reordered
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// Update the model when the cells are rearranged
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    List *list = [[List alloc]init];
    list = _lists[sourceIndexPath.row];
    
    [_lists removeObjectAtIndex:sourceIndexPath.row];
    [_lists insertObject:list atIndex:destinationIndexPath.row];
}

#pragma mark - Actions


// When the Reorder Button is pressed
- (IBAction)reorderButtonTouchUp:(UIBarButtonItem*)reorderButton {
    if (self.tableView.isEditing) {
        [self.tableView setEditing:NO animated:YES];
        reorderButton.style = UIBarButtonItemStylePlain;
        reorderButton.title = @"Reorder";
    }
    else {
        [self.tableView setEditing:YES animated:YES];
        reorderButton.style = UIBarButtonItemStyleDone;
        reorderButton.title = @"Done";
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
