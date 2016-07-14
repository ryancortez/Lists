//
//  AddListItemController.m
//  Lists
//
//  Created by Ryan Cortez on 6/28/16.
//  Copyright © 2016 Ryan Cortez. All rights reserved.
//

#import "AddListItemViewController.h"

@implementation AddListItemViewController {
    int numberOfCellsAddedByTheUser;
    int numberOfCellsAddedWhenViewLoads;
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    numberOfCellsAddedByTheUser = 0;
    numberOfCellsAddedWhenViewLoads = 1;
    List *list = _lists[self.index];
    self.navigationController.title = list.title;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *listsData = [userDefaults objectForKey:@"lists"];
    _lists = (NSMutableArray *) [NSKeyedUnarchiver unarchiveObjectWithData:listsData];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    List *list = _lists[self.index];
    if (indexPath.section == 0) {
        TextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFieldTableViewCell"];
        cell.textField.text = list.title;
        return cell;
    } else if(indexPath.section == 1) {
        if (indexPath.row < list.listItems.count) {
            TextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFieldTableViewCell"];
            cell.textField.placeholder = @"Add list item";
            ListItem *listItem = list.listItems[indexPath.row];
            cell.textField.text = listItem.title;
            return cell;
        } else {
            TextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BlankTextFieldTableViewCell"];
            cell.textField.placeholder = @"Add list item";
            [cell.textField addTarget:self
                          action:@selector(textFieldWasTapped:)
                forControlEvents:UIControlEventEditingDidBegin];
            return cell;
        }
    } else {
        TextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFieldTableViewCell"];
        return cell;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    List *list = _lists[self.index];
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return list.listItems.count + numberOfCellsAddedWhenViewLoads + numberOfCellsAddedByTheUser;
    } else {
        return 0;
    }
}

- (void) insertRowInTable {
    List *list = _lists[self.index];
    numberOfCellsAddedByTheUser++;
    NSArray *indexPaths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:(list.listItems.count + numberOfCellsAddedByTheUser) inSection:1]];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView scrollToRowAtIndexPath:indexPaths.firstObject atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void) textFieldWasTapped: (UITextField *) textField {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)textField.superview.superview];
    indexPath = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
    TextFieldTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    // If there is text in the previous cell add a new cell
    if (![cell.textField.text isEqual: @""]) {
        [textField removeTarget:self action:@selector(textFieldWasTapped:) forControlEvents:UIControlEventEditingDidBegin];
        [self insertRowInTable];
    }
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    // When the return button is press, go the next tableViewCell
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)textField.superview.superview];
    indexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
    TextFieldTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell.textField becomeFirstResponder];
    return YES;
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{    }];
}

- (IBAction)saveButtonPressed:(id)sender {
    List *list = _lists[self.index];
    [self saveTitleFromTextFieldIntoList:list];
    [self saveContentFromTextFieldsIntoList:list];
    _lists[self.index] = list;
    [self.delegate saveLists:_lists];
    [self dismissViewControllerAnimated:YES completion:^{    }];
}

- (void) saveTitleFromTextFieldIntoList: (List *) list {
    NSIndexPath *listTitleIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];;
    TextFieldTableViewCell *textFieldTableViewCell = [self.tableView cellForRowAtIndexPath:listTitleIndexPath];
    if (![textFieldTableViewCell.textField.text isEqual: @""]) {
        list.title = textFieldTableViewCell.textField.text;
    }
}

// Keeps adding to listItems
- (void) saveContentFromTextFieldsIntoList:(List *) list {
    
    NSInteger tableViewCellCount = list.listItems.count + numberOfCellsAddedWhenViewLoads + numberOfCellsAddedByTheUser;
    for (int index = 0; index < tableViewCellCount; index++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:1];
        TextFieldTableViewCell *textFieldTableViewCell = [self.tableView cellForRowAtIndexPath:indexPath];
        if (![textFieldTableViewCell.textField.text isEqual: @""]) {
            ListItem *listItem = [[ListItem alloc]initWithTitle:textFieldTableViewCell.textField.text];
            list.listItems[index] = listItem;
        }
    }

}

@end
