//
//  GroceryItem.h
//  Groceries
//
//  Created by Ryan Cortez on 6/28/16.
//  Copyright © 2016 Ryan Cortez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListItem : NSObject

@property NSString *title;

- (instancetype) initWithTitle: (NSString *) title;

@end
