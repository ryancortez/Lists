//
//  List.m
//  Lists
//
//  Created by Ryan Cortez on 6/28/16.
//  Copyright © 2016 Ryan Cortez. All rights reserved.
//

#import "List.h"

@implementation List

- (instancetype)initWithTitle: (NSString *) title {
    self = [super init];
    self.title = title;
    
    return self;
}

- (instancetype)initWithTitle: (NSString *) title andListItems: (NSMutableArray *) listItems {
    self = [super init];
    self.title = title;
    self.listItems = listItems;
    
    return self;
}

- (instancetype)initWithTitle: (NSString *) title andListItemTitles: (NSArray *) titles {
    self = [super init];
    self.title = title;
    self.listItems = [self listItemsForTitles:[NSMutableArray arrayWithArray:titles]];
    return self;
}

- (NSMutableArray *)listItemsForTitles:(NSMutableArray *) titles {
    NSMutableArray *listItems = [[NSMutableArray alloc]init];
    for (NSString *title in titles) {
        ListItem *listItem = [[ListItem alloc]initWithTitle:title];
        [listItems addObject:listItem];
    }
    self.listItems = listItems;
    return listItems;
}


- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    self.title = [coder decodeObjectForKey:@"title"];
    self.listItems = [coder decodeObjectForKey:@"groceryItems"];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.title forKey:@"title"];
    [coder encodeObject:self.listItems forKey:@"groceryItems"];
}

- (void)setTitle: (NSString *) title andListItems: (NSMutableArray *) listItems {
    self.title = title;
    self.listItems = listItems;
}

- (void)addListItem:(ListItem *)listItem {
    [self.listItems addObject:listItem];
}

@end
