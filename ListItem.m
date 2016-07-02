//
//  ListItem.m
//  Lists
//
//  Created by Ryan Cortez on 6/28/16.
//  Copyright © 2016 Ryan Cortez. All rights reserved.
//

#import "ListItem.h"

@implementation ListItem

- (instancetype) initWithTitle: (NSString *) title {
    self = [super init];
    self.title = title;
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    self.title = [coder decodeObjectForKey:@"title"];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.title forKey:@"title"];
}

@end
