//
//  AddListViewController.h
//  Lists
//
//  Created by Ryan Cortez on 6/28/16.
//  Copyright © 2016 Ryan Cortez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "List.h"
#import "ListItem.h"
#import "TextFieldTableViewCell.h"

// Allow any view to save the new content created in the is view
@protocol SaveListDelegate <NSObject>

- (void) saveListItems: (NSArray *) listItems inList: (List *) list;

@end

@interface AddListViewController : UITableViewController <UITextFieldDelegate>

@property List *list;
@property (nonatomic, weak) id<SaveListDelegate> delegate;

@end
