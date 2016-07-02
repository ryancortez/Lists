//
//  ListItemViewController.h
//  Lists
//
//  Created by Ryan Cortez on 6/28/16.
//  Copyright © 2016 Ryan Cortez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "List.h"
#import "ListItem.h"
#import "TextFieldTableViewCell.h"

@protocol SaveListItemDelegate <NSObject>

- (void) saveListItems: (NSArray *) listItems inList: (List *) list;
- (void) saveLists: (NSMutableArray *) lists;

@end

@interface AddListItemViewController : UITableViewController <UITextFieldDelegate>

@property id<SaveListItemDelegate> delegate;
@property NSInteger index;
@property NSMutableArray *lists;

@end
