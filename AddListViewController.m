//
//  AddListViewController.m
//  Lists
//
//  Created by Ryan Cortez on 6/28/16.
//  Copyright © 2016 Ryan Cortez. All rights reserved.
//

#import "AddListViewController.h"

@implementation AddListViewController {
    int numberOfListItemCellsAddedByTheUser;
    int numberOfListItemCellsAddedWhenViewLoads;
}

#pragma mark - ViewController Lifecycle

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    numberOfListItemCellsAddedByTheUser = 0;
    numberOfListItemCellsAddedWhenViewLoads = 1;
    NSMutableArray *mutableArray = [[NSMutableArray alloc]init];
    _list = [[List alloc]initWithTitle:@"" andListItems:mutableArray];
}

#pragma mark - TableView DataSource

// Fill in the TableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        TextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFieldTableViewCell"];
        [cell.textField setPlaceholder: @"Add a list name"];
        return cell;
    } else if (indexPath.section == 1) {
        TextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFieldTableViewCell"];
        cell.textField.placeholder = @"Add a list item";
        [cell.textField addTarget:self
                           action:@selector(textFieldWasTapped:)
                 forControlEvents:UIControlEventEditingDidBegin];
        return cell;
    } else {
        TextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFieldTableViewCell"];
        return cell;
    }
}

// Assign the number of the sections in the TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

// Assign the number of rows in each section of the TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 1 + numberOfListItemCellsAddedByTheUser;
    } else {
        return 0;
    }
}

- (void) insertRowInTable {
    numberOfListItemCellsAddedByTheUser++;
    NSArray *indexPaths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:(numberOfListItemCellsAddedByTheUser) inSection:1]];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView scrollToRowAtIndexPath:indexPaths.firstObject atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}


#pragma mark - TextField Delegate

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

// Triggered when the return button is pressed
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    // When the return button is press, go the next tableViewCell
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)textField.superview.superview];
    indexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
    TextFieldTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell.textField becomeFirstResponder];
    return YES;
}

#pragma mark - Actions

- (IBAction)cancelButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{    }];
}

#pragma mark Save Content

// Take all text content from the TableView rows and add it to the model
- (IBAction)saveButtonPressed:(id)sender {
    [self saveCategoryTitleFromTextFieldTableViewCellContent];
    [self saveContentFromTextFieldsIntoList];
    [self.delegate saveListItems:_list.listItems inList: _list];
    [self dismissViewControllerAnimated:YES completion:^{  }];
}

#pragma mark Save Content - Helper Methods

// Get the list title from the text
- (void) saveCategoryTitleFromTextFieldTableViewCellContent {
    NSIndexPath *categoryTitleIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    TextFieldTableViewCell *textFieldTableViewCell = [self.tableView cellForRowAtIndexPath:categoryTitleIndexPath];
    _list.title = textFieldTableViewCell.textField.text;
}

// Get the content add by the user in the list item text fields
- (void) saveContentFromTextFieldsIntoList {
    NSInteger tableViewCellCount = numberOfListItemCellsAddedByTheUser + numberOfListItemCellsAddedWhenViewLoads;
    
    for (int index = 0; index < tableViewCellCount; index++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:1];
        TextFieldTableViewCell *textFieldTableViewCell = [self.tableView cellForRowAtIndexPath:indexPath];
        if (![textFieldTableViewCell.textField.text isEqual: @""]) {
            ListItem *listItem = [[ListItem alloc]initWithTitle:textFieldTableViewCell.textField.text];
            
            _list.listItems[index] = listItem;
            
        }
    }
}




@end
