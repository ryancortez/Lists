//
//  ListItemsTableViewController.h
//  Lists
//
//  Created by Ryan Cortez on 6/28/16.
//  Copyright © 2016 Ryan Cortez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddListItemViewController.h"
#import "List.h"
#import "ListItem.h"

@interface ListItemsTableViewController : UITableViewController <SaveListItemDelegate>

@property List *list;
@property NSInteger index;
@property NSMutableArray *lists;

@end
