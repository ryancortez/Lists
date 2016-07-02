//
//  List.h
//  Lists
//
//  Created by Ryan Cortez on 6/28/16.
//  Copyright © 2016 Ryan Cortez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ListItem.h"

@interface List : NSObject

@property NSString *title;
@property NSMutableArray *listItems;

- (instancetype)initWithTitle: (NSString *) title;
- (instancetype)initWithTitle: (NSString *) title andListItems: (NSMutableArray *) listItems;
- (instancetype)initWithTitle: (NSString *) title andListItemTitles: (NSArray *) titles;
- (void)setTitle: (NSString *) title andListItems: (NSMutableArray *) listItems;
- (void)addListItem:(ListItem *)listItem;

@end
