//
//  ListTableViewController.h
//  Lists
//
//  Created by Ryan Cortez on 6/28/16.
//  Copyright © 2016 Ryan Cortez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddListViewController.h"
#import "List.h"
#import "ListItem.h"
#import "ListItemsTableViewController.h"

// A view that displays a collection of lists
@interface ListTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, SaveListDelegate>

@property NSMutableArray *lists;

@end
